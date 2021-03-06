      SUBROUTINE WILVEC (D,O,VAL,VLOC,V,F,P,Q,R,VEC,NX,SVEC)
C
C     WILKINSON EIGENVECTOR SOLUTION FOR LARGE SYM MATRICES
C
      INTEGER          VLOC(1),ENTRY,V2,XENTRY,PV,VECTOR,VV,V1,MCB(7),
     1                 SYSBUF,MCB1(7),PHIA,SVEC(1),PATH
      DOUBLE PRECISION D(1),O(1),VAL(1),V(1),P(1),F(1),Q(1),R(1),
     1                 VEC(NX,1),VALUE,W,X,Y,Z,DLMDAS,
     2                 RMULT,RRMULT,SFT,SFTINV,DEPS,VMULT,ZERO,ONE
      CHARACTER        UFM*23,UWM*25,UIM*29
      COMMON /XMSSG /  UFM,UWM,UIM
      COMMON /GIVN  /  TITLE(1),MO,T3,MR,MT1,T6,MV1,T8(3),ENTRY,T12(5),
     1                 RSTRT,V2,T19,XENTRY,T21(80),VCOM(30),T131(20)
      COMMON /PACKX /  IT1,IT2,II,JJ,INCR
      COMMON /UNPAKX/  IT3,III,JJJ,INCR1
      COMMON /SYSTEM/  SYSBUF,IOTPE,KSYS(52),IPREC
      COMMON /REIGKR/  IOPTN
      COMMON /MGIVXX/  DLMDAS
      EQUIVALENCE      (N     ,VCOM( 1)), (PV    ,VCOM( 5)),
     1                 (NV    ,VCOM( 7)), (NRIGID,VCOM(10)),
     2                 (PHIA  ,VCOM(12)), (NVER  ,VCOM(13)),
     3                 (MAXITR,VCOM(15)), (ITERM ,VCOM(16))
      DATA    MUL3  ,  MCB1,MCB / 0, 0,0,0,2,2,0,0, 7*0    /
      DATA    ZERO  ,  ONE      / 0.0D+0,  1.0D+0          /
      DATA    MGIV  /  4HMGIV   /
C
C     D        = DIAGONAL     TERMS OF THE TRIDIAGONAL MATRIX (N)
C     O        = OFF-DIAGONAL TERMS OF THE TRIDIAGONAL MATRIX (N)
C     VAL      = EIGENVALUES (NV)
C     VLOC     = ORIGINAL ORDERING OF THE EIGENVALUES (NV)
C     V,F,P,Q,R= N DIMENSIONAL ARRAYS
C     VEC      = THE REST OF OPEN CORE
C
C     MT       = TRANSFORMATION TAPE
C     N        = ORDER  OF PROBLEM
C     NV       = NUMBER OF EIGENVECTORS
C     RSTRT
C     V2       = NUMBER   OF EIGENVECTORS ALREADY CLLCULATED
C     VV       = POINTER  TO CURRENT VECTOR IN CORE VEC(1,VV)
C     NM2X     = MIDPOINT OF PROBLEM (SWITCH SINE SAVE TAPES)
C
C
C     INITALIZE VARIABLES
C
      DEPS  = 1.0D-35
      SFT   = 1.0D+20
      SFTINV= 1.0D+0/SFT
      VMULT = 1.0D-02
      NZ    = KORSZ(SVEC)
      IBUF1 = NZ - SYSBUF + 1
      IBUF2 = IBUF1 - SYSBUF
      IM    = 1
      CALL MAKMCB (MCB1,PHIA,N,2,IPREC)
      IM1   = 2
      NZ    = IBUF2 - 1
      PATH  = 0
      NV1   = (NZ-1)/(N+N)
      IM2   = 2
      NM1   = N - 1
      NM2   = N - 2
      NVER  = 0
      V2    = NRIGID
C
C     REARRANGE EIGENVALUES AND EXTRACTION ORDER FOR MULTIPLE ROOTS
C     TO GUARANTEE THAT THEY ARE IN SUBMATRIX ORDER FOR PURPOSES
C     OF TRIAL VECTOR AND ORTHOGONOLIZATION COMPUTATIONS
C
      RMULT = VMULT
      RRMULT= VMULT/100.0D0
      ICLOS = 0
      I = NRIGID + 1
   10 IF (DABS(VAL(I))+DABS(VAL(I+1)) .LT. RMULT) GO TO 20
      IF (VAL(I) .EQ. ZERO) GO TO 90
      IF (DABS(ONE-VAL(I)/VAL(I+1)) .GT. RRMULT) GO TO 80
   20 IF (ICLOS .NE. 0) GO TO 90
      ICLOS = I
      GO TO 90
   30 CONTINUE
      DO 50 I1 = ICLOS,I
      MIN   = VLOC(I1)
      VALUE = VAL(I1)
      K = I1
      DO 40 J = I1,I
      IF (VLOC(J) .GE. MIN) GO TO 40
      K    = J
      MIN  = VLOC(J)
      VALUE= VAL(J)
   40 CONTINUE
      VLOC(K) = VLOC(I1)
      VAL(K)  = VAL(I1)
      VLOC(I1)= MIN
      VAL(I1) = VALUE
   50 CONTINUE
      ICLOS = 0
   80 IF (ICLOS .NE. 0) GO TO 30
   90 I = I + 1
      IF (I     .LT. NV) GO TO 10
      IF (ICLOS .NE.  0) GO TO 30
C
C     START LOOP FOR CORE LOADS OF VECTORS
C
  100 CALL KLOCK (IST)
      V1   = V2 + 1
      V2   = V2 + NV1
      MUL2 = MUL3
      MULP2= 0
      MUL3 = 0
      IF (NV-V2) 101,110,102
  101 V2   = NV
      GO TO 110
C
C     SEARCH FOR MULTIPLICITIES OF EIGENVALUES V2 AND V2+1.
C
  102 VV = V2
  103 IF (DABS(VAL(V2))+DABS(VAL(V2+1)) .LT. RMULT) GO TO 1041
      IF (DABS(ONE-VAL(V2)/VAL(V2+1))   .GT. RMULT) GO TO 110
 1041 CONTINUE
      L1 = VLOC(V2  )
      L2 = VLOC(V2+1)
      N1 = MIN0(L1,L2)
      N2 = MAX0(L1,L2) - 1
      DO 104 K = N1,N2
      IF (O(K) .EQ. ZERO) GO TO 110
  104 CONTINUE
      V2 = V2 - 1
      IF (V2+6.GT.N1 .AND. V2.GT.V1) GO TO 103
      V2 = VV
      MUL3  = 1
C
C     FIND EIGENVECTORS V1 - V2.
C
  110 N1 = 0
      N2 = 0
      NV2= V2 - V1 + 1
      DO 175 VV = 1,NV2
      VECTOR = V1 + VV - 1
      VALUE  = VAL (VECTOR)
C
C     FOR MGIV METHOD, USE ORIGINAL LAMBDA COMPUTED BY QRITER
C     IN EIGENVECTOR COMPUTATIONS
C
      IF (IOPTN .EQ. MGIV) VALUE = 1.0D0/(VALUE + DLMDAS)
      LOC = VLOC(VECTOR)
      IF (LOC.GE.N1 .AND. LOC.LE.N2) GO TO 120
C
C     SEARCH FOR A DECOUPLED SUBMATRIX.
C
      MUL1 = 0
      IF (LOC .EQ. 1) GO TO 112
      DO 111 K = 2,LOC
      N1 = LOC - K + 2
      IF (O(N1-1) .EQ. ZERO) GO TO 113
  111 CONTINUE
  112 N1 = 1
  113 IF (LOC .EQ. N) GO TO 115
      DO 114 K = LOC,NM1
      IF (O(K) .EQ. ZERO) GO TO 116
  114 CONTINUE
  115 N2 = N
      GO TO 120
  116 N2 = K
  120 IF (MUL1.NE.0 .OR. MUL2.NE.0) GO TO 122
      DO 121 I = 1,N
      V(I) = ZERO
  121 CONTINUE
      IF (N1 .NE. N2) GO TO 122
      V(LOC) = ONE
      GO TO 152
  122 N2M1 = N2 - 1
      N2M2 = N2 - 2
C
C     SET UP SIMULTANEOUS EQUATIONS
C
      X = D(N1) - VALUE
      Y = O(N1)
      DO 131 K = N1,N2M1
      IF (X .EQ. ZERO) GO TO 125
      F(K) = -O(K)/X
      GO TO 126
  125 F(K) = -SFT*O(K)
  126 IF (DABS(X)-DABS(O(K))) 127,128,129
C
C     PIVOT.
C
  127 P(K) = O(K)
      Q(K) = D(K+1) - VALUE
      R(K) = O(K+1)
      Z    =-X/P(K)
      X    = Z*Q(K) + Y
      Y    = Z*R(K)
      GO TO 130
C
C     DO NOT PIVOT.
C
  128 IF (X .EQ. ZERO) X = SFTINV
  129 P(K) = X
      Q(K) = Y
      R(K) = ZERO
      X    = D(K+1) - (VALUE+O(K)*(Y/X))
      Y    = O(K+1)
  130 CONTINUE
  131 CONTINUE
      IF (MUL1.NE.0 .OR. MUL2.NE.0) GO TO 135
      DO 134 K = N1,N2M1
  134 V(K) = ONE
      W    = ONE/DSQRT(DBLE(FLOAT(N2-N1+1)))
      V(N2)= ONE
C
C     SOLVE FOR AN EIGENVECTOR OF THE TRIDIAGONAL MATRIX.
C
  135 MUL2   = 0
      MAXITR = 3
      DO 150 ITER = 1,MAXITR
C
C     BACK SUBSTITUTION
C
      IF (X .EQ. ZERO) GO TO 136
      V(N2) = V(N2)/X
      GO TO 137
  136 V(N2  ) = V(N2)*SFT
  137 V(N2-1) = (V(N2-1) - Q(N2-1)*V(N2))/P(N2-1)
      MAX = N2
      IF (DABS(V(N2)) .LT. DABS(V(N2-1))) MAX = N2M1
      IF (N2M2 .LT. N1) GO TO 140
      DO 138 K = N1,N2M2
      L    = N2M2 - (K-N1)
      V(L) = (V(L)-Q(L)*V(L+1) - R(L)*V(L+2))/P(L)
      IF (DABS(V(L)) .GT. DABS (V(MAX))) MAX = L
  138 CONTINUE
C
C     NORMALIZE THE VECTOR.
C
  140 Y = DABS(V(MAX))
      Z = ZERO
      DO 141 I = N1,N2
      V(I) = V(I)/Y
      IF (DABS(V(I)) .LT. DEPS) GO TO 141
      Z = Z + V(I)*V(I)
  141 CONTINUE
      Z = DSQRT(Z)
      DO 142 I = N1,N2
      V(I) = V(I)/Z
  142 CONTINUE
C
C     CHECK CONVERGENCE OF THE LARGEST COMPONENT OF THE VECTOR.
C
      Y = DABS(V(MAX))
      IF (SNGL(W) .EQ. SNGL(Y)) GO TO 152
      IF (ITER    .EQ.  MAXITR) GO TO 150
      W = Y
C
C     PIVOT V.
C
      DO 145 I = N1,N2M1
      IF (P(I) .EQ. O(I)) GO TO 144
      V(I+1) = V(I+1) + V(I)*F(I)
      GO TO 145
  144 Z =  V(I+1)
      V(I+1) = V(I) + Z/F(I)
      V(I  ) = Z
  145 CONTINUE
  150 CONTINUE
C
C     TOO MANY ITERATIONS.
C
C     THE ACCURACY OF EIGENVECTOR XXXX CORRESPONDING TO THE EIGENVALUE
C     XXXXXXX  IS IN DOUBT.
C
  152 DO 153 I = 1,N
      VEC(I,VV) = V(I)
  153 CONTINUE
C
C     CHECK MULTIPLICITY OF THE NEXT EIGENVALUE IF IT IS IN THE SAME
C     SUBMATRIX AS THIS ONE.
C
      IF (VECTOR .EQ. V2) GO TO 160
C
C     FOR MGIV METHOD, USE ADJUSTED LAMBDA COMING OUT OF QRITER
C     IN THE FOLLOWING CHECKS
C
      IF (DABS(VAL(VECTOR+1))+DABS(VAL(VECTOR)) .LT. RMULT) GO TO 154
      IF (DABS(VAL(VECTOR+1)-VAL(VECTOR)) .GT.RMULT*DABS(VAL(VECTOR+1)))
     1    GO TO 160
  154 CONTINUE
      L1 = VLOC(VECTOR+1)
      IF (L1.LT.N1 .OR. L1.GT.N2) GO TO 160
C
C     A MULTIPLICITY DOES EXIT...THE INITIAL APPROXIMATION OF THE NEXT
C     EIGENVECTOR SHOULD BE ORTHOGONAL TO THE ONE JUST CALCULATED.
C
      IF (MUL1 .EQ. 0) MUL1 = VV
      MULP2 = MULP2 + 1
      MULP3 = MULP2 + MUL1 - 1
      DO 4001 KKK = N1,N2
 4001 V(KKK) = ONE
      DO 4003 JJJ = MUL1,MULP3
      Z = ZERO
      DO 4004 KK = N1,N2
      DO 4005 II = N1,N2
 4005 Z = Z + VEC(II,JJJ)*V(II)
 4004 V(KK) = V(KK) - Z*VEC(KK,JJJ)
 4003 CONTINUE
      GO TO 175
C
C     DOES THIS EIGENVALUE = PREVIOUS ONE(S) IN THIS SUBMATRIX
C
  160 IF (MUL1 .EQ. 0) GO TO 175
C
C     A MULTIPLICITY OF EIGENVALUES OCCURRED...IMPROVE THE ORTHOGONALITY
C     OF THE CORRESPONDING EIGENVECTORS.
C
      MULP1 = MUL1 + 1
      DO 170 L = MULP1,VV
      DO 161 I = N1,N2
      P(I) = VEC(I,L)
      Q(I) = ZERO
  161 CONTINUE
      LM1 = L - 1
      DO 164 K = MUL1,LM1
      Z = ZERO
      DO 162 I = N1,N2
      Z = Z + P(I)*VEC(I,K)
  162 CONTINUE
      DO 163  I = N1,N2
      Q(I) = Q(I) + Z*VEC(I,K)
  163 CONTINUE
  164 CONTINUE
      Z = ZERO
      DO 165  K = N1,N2
      Q(K) = P(K) - Q(K)
      IF (DABS(Q(K)) .LT. DEPS) GO TO 165
      Z = Z + Q(K)*Q(K)
  165 CONTINUE
      Z = DSQRT(Z)
      DO 166 K = N1,N2
      VEC(K,L) = Q(K)/Z
  166 CONTINUE
  170 CONTINUE
      MUL1  = 0
      MULP2 = 0
  175 CONTINUE
C
C     CORE IS NOW FULL OF EIGENVECTORS OF THE TRIDIAGONAL MATRIX.
C     CONVERT THEM TO EIGENVECTORS OF THE ORIGINAL MATRIX.
C
      IT1 = 2
      IT2 = 2
      JJ  = N
      INCR= 1
C
C     IS THE ORIGINAL MATRIX A 2X2
C
      IF (NM2  .EQ. 0) GO TO 186
      MT = MT1
      IF (PATH .NE. 0) GO TO 176
      MT = MO
  176 CALL GOPEN (MT,SVEC(IBUF1),IM2)
      IF (PATH.EQ.0 .AND. V2.NE.NV) CALL GOPEN (MT1,SVEC(IBUF2),1)
      IT3  = 2
      JJJ  = N
      INCR1= 1
      DO 185 M = 1,NM2
      L1  = N - M
      III = L1+ 1
      IF (PATH .EQ. 0) CALL BCKREC (MT)
      CALL UNPACK (*167,MT,P)
      GO TO 180
  167 DO 179 I = 1,M
      P(I) = ZERO
  179 CONTINUE
  180 IF (PATH.NE.0 .OR. V2.EQ.NV) GO TO 177
      II = L1+1
      CALL PACK (P,MT1,MCB)
  177 IF (PATH .EQ. 0) CALL BCKREC (MT)
      DO 182 K = 1,M
      L2 = N - K + 1
      I  = M - K + 1
      Y  = P(I)
      IF (Y .EQ. ZERO) GO TO 182
      X = ZERO
      IF (DABS(Y) .LT. ONE) X = DSQRT(ONE-Y**2)
      DO 181 VV = 1,NV2
      Z = X*VEC(L1,VV) -Y*VEC(L2,VV)
      VEC(L2,VV) = X*VEC(L2,VV) + Y*VEC(L1,VV)
      VEC(L1,VV) = Z
  181 CONTINUE
  182 CONTINUE
  185 CONTINUE
      CALL CLOSE (MT,1)
      IF (PATH .NE. 0) GO TO 186
      IF (V2 .NE. NV) WRITE (IOTPE,1001) UIM,N,NV,NV1
 1001 FORMAT (A29,' 2016A, WILVEC EIGENVECTOR COMPUTATIONS.', /37X,
     1       'PROBLEM SIZE IS',I6,', NUMBER OF EIGENVECTORS TO BE ',
     2       'RECOVERED IS',I6 , /37X,'SPILL WILL OCCUR FOR THIS ',
     3       'CORE AT RECOVERY OF',I6,' EIGENVECTORS.')
      PATH = 1
      CALL CLOSE (MT1,1)
      IM2  = 0
C
C     WRITE THE EIGENVECTORS ONTO PHIA
C
  186 CALL GOPEN (PHIA,SVEC(IBUF1),IM)
      II  = 1
      IT2 = IPREC
      IF (IM.NE.1 .OR. NRIGID.LE.0) GO TO 205
C
C     PUT OUT ZERO VECTORS FOR RIGID BODY MODES
C
      JJ = 1
      DO 206 VV = 1,NRIGID
      CALL PACK (ZERO,PHIA,MCB1)
  206 CONTINUE
      JJ = N
  205 CONTINUE
      IM = 3
      IF (N .EQ. 1) GO TO 250
      DO 192 VV = 1,NV2
      CALL PACK (VEC(1,VV),PHIA,MCB1)
  192 CONTINUE
  250 IF (V2 .EQ. NV) IM1 = 1
      CALL CLOSE (PHIA,IM1)
      XENTRY = -ENTRY
C
C     ANY TIME LEFT TO FIND MORE
C
      CALL TMTOGO (ITIME)
      CALL KLOCK  (IFIN)
      IF (2*(IFIN-IST) .GE. ITIME) GO TO 200
      IF (V2 .NE. NV) GO TO 100
  201 CALL WRTTRL (MCB1)
      RETURN
C
C     MAX TIME
C
  200 ITERM = 3
      GO TO 201
      END
