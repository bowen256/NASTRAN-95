      BLOCK DATA IFX5BD
CIFX5BD
C
C     THE FIRST  WORD OF EACH PAIR IS AN INDEX INTO /IFPX7/ FOR INPUT
C     CARD SPECIFICATION
C     THE SECOND WORD IS THE FIELD-2-UNIQUENESS-CHECK FLAG
C
      COMMON /IFPX5/ I1(100),I2(100),I3(100),I4(100),I5(100),
     1               I6(100),I7(100),I8( 40)
      DATA I1/
     1      1, 1,    13, 2,   537, 0,    37, 0,    37, 0,    37, 0,
     *     37, 0,    45, 1,    45, 1,    45, 1,   505, 0,    -1, 0,
     3     -1, 1,    37, 0,    37, 0,   101, 0,    -1, 0,   109, 0,
     *    109, 0,   121, 0,   121, 0,   133, 0,   133, 0,   145, 0,
     5    157, 0,   165, 1,   157, 0,    -1, 1,   165, 1,   177, 1,
     *    189, 0,   537, 0,   221, 1,   237, 0,   257, 1,   257, 1,
     7    237, 0,   221, 1,   237, 0,   257, 1,   237, 0,   237, 0,
     *    237, 0,   269, 0,   269, 0,   497, 0,   277, 1,    37, 0,
     9     37, 0,    37, 0/
      DATA I2/
     1    537, 0,   313, 1,   313, 1,   313, 1,   313, 1,   313, 1,
     *    325, 1,   325, 1,   325, 1,   325, 1,   337, 1,   337, 1,
     3    349, 1,   377, 1,   337, 1,   397, 1,    37, 0,   409, 0,
     *    337, 1,   397, 1,    37, 0,   409, 0,   337, 1,   417, 1,
     5     37, 0,   409, 0,   429, 1,   445, 1,   738, 1,   737, 1,
     *    157, 0,    -1, 2,    -1, 1,    -1, 1,   469, 1,   469, 1,
     7     -1, 1,   537, 0,    -1, 2,   545, 1,   545, 1,    -1, 0,
     *     -1, 1,    -1, 1,    -1, 1,    -1, 1,    -1, 1,   269, 1,
     9    537, 0,   537, 0/
      DATA I3/
     1    537, 0,   525, 1,   537, 0,   750, 1,   794, 0,   537, 0,
     *    925, 1,   925, 1,   925, 1,   925, 1,   925, 1,   925, 1,
     3    925, 1,   925, 1,   925, 1,   925, 1,   925, 1,   925, 1,
     *     -1, 0,    -1, 0,   237, 0,   445, 1,    -1, 1,   794, 0,
     5    705, 0,    -1, 1,   725, 0,   725, 0,   725, 0,   725, 0,
     *    337, 1,   337, 1,    -1, 1,    -1, 1,    37, 0,    -1, 0,
     7    713, 0,   681, 1,   689, 1,    -1, 1,    -1, 1,    -1, 1,
     *     -1, 1,    93, 0,   245, 1,   645, 1,   653, 1,   485, 0,
     9     -1, 0,   337, 0/
      DATA I4/
     1    337, 0,   517, 1,   177, 1,    61, 0,   237, 0,   109, 0,
     *    109, 0,   561, 0,   925, 1,   925, 1,   925, 1,    -1, 1,
     3    925, 1,   925, 1,   925, 1,   705, 0,    -1, 0,    -1, 0,
     *     45, 1,    -1, 0,    -1, 0,  1080, 0,    -1, 0,    -1, 0,
     5     -1, 1,    -1, 0,    -1, 0,    -1, 0,    25, 2,    73, 1,
     *    621, 1,   101, 0,   101, 0,   101, 0,    -1, 1,  1073, 0,
     7   1073, 0,     1, 0,   525, 1,   109, 0,    -1, 1,    -1, 0,
     *   1065, 0,    -1, 0,   782, 0,   752, 0,    -1, 1,   993, 0,
     9     -1, 0,    -1, 0/
      DATA I5/
     1     -1, 0,    -1, 0,    -1, 0,    -1, 0,     1, 1,    -1, 0,
     *    497, 1,   834, 0,   845, 1,   853, 1,   861, 1,    -1, 0,
     3     -1, 0,   834, 0,    37, 0,    -1, 0,   337, 1,   525, 1,
     *    531, 1,   531, 1,    -1, 0,   826, 0,   869, 1,   877, 1,
     5    877, 1,   877, 1,   877, 1,   877, 1,   885, 1,   893, 1,
     *     -1, 0,   909, 1,   901, 0,   198, 1,   198, 1,   350, 1,
     7     37, 1,    37, 1,    -1, 0,   350, 0,    -1, 0,    -1, 0,
     *     -1, 0,    -1, 0,    -1, 0,    -1, 0,    -1, 0,    -1, 0,
     9    325, 1,   237, 0/
      DATA I6/
     1    951, 1,   951, 1,   951, 1,   981, 1,   949, 0,   101, 0,
     *     -1, 0,    -1, 0,   325, 1,   237, 0,  1418, 1,  1434, 1,
     3     39, 1,    37, 1,     2, 0,    42, 1,  1025, 1,    -1, 0,
     *    197, 0,   805, 0,   805, 0,  1005, 1,    -1, 1,    -1, 1,
     5     -1, 1,    -1, 0,  1017, 0,  1037, 0,    -1, 1,    -1, 1,
     *     -1, 1,    -1, 1,    -1, 1,    -1, 1,   313, 1,   349, 1,
     7    325, 1,   349, 1,   326, 1,    -1, 0,   913, 1,   802, 1,
     *    913, 1,  1089, 1,    -1, 0,    -1, 0,    37, 1,    -1, 1,
     9    913, 1,  1105, 1/
      DATA I7/
     1     39, 1,    39, 1,    39, 1,  1129, 1,   801, 1,    -1, 1,
     *     -1, 1,   165, 0,    39, 1,    -1, 1,  1080, 0,  1080, 0,
     3   1080, 0,  1153, 0,  1201, 1,  1201, 1,  1257, 1,  1257, 1,
     *   1201, 1,  1257, 1,  1313, 0,  1329, 0,  1048, 1,  1057, 1,
     5   1361, 0,  1329, 0,  1337, 0,  1345, 0,    -1, 1,    -1, 1,
     *    505, 1,    -1, 1,   531, 1,   531, 1,   337, 1,   525, 1,
     7    198, 1,    73, 1,   802, 1,    -1, 0,   725, 0,    37, 1,
     *    445, 1,    -1, 0,    -1, 1,    45, 1,   545, 1,   545, 1,
     9    545, 1,    -1, 1/
      DATA I8/
     1     -1, 1,    -1, 1,    -1, 1,  1454, 1,    -1, 1,    37, 1,
     *    313, 1,   337, 1,   269, 1,    22* 0/
C
      END
