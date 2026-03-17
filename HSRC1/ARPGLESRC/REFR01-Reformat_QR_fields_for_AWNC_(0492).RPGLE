     H option(*nodebugio:*srcstmt)
      //************************************************************************
      // REFR01
      // LEC          2017/04/18
      // This program reformats all QR code fields into 1 pipe delimited QR code
      //************************************************************************

     D P_01            S              2
     D P_02            S              1
     D P_03            S              4
     D P_04            S              2
     D P_05            S             11
     D P_06            S              5
     D P_07            S              6S 0
     D P_08            S              4S 0
     D P_09            S              8
     D P_10            S              8
     D P_11            S              2
     D P_12            S             13
     D P_13            S             20
     D P_14            S             10
     D P_15            S             10
     D P_16            S              5
     D QR_out          S            150

     C     *Entry        PList
     C                   Parm                    P_01
     C                   Parm                    P_02
     C                   Parm                    P_03
     C                   Parm                    P_04
     C                   Parm                    P_05
     C                   Parm                    P_06
     C                   Parm                    P_07
     C                   Parm                    P_08
     C                   Parm                    P_09
     C                   Parm                    P_10
     C                   Parm                    P_11
     C                   Parm                    P_12
     C                   Parm                    P_13
     C                   Parm                    P_14
     C                   Parm                    P_15
     C                   Parm                    P_16
     C                   Parm                    QR_out

      **********************************************************************************
      *         M    A    I    N    L    I    N    E
      *
      *
     C                   Eval      QR_out = P_01 + '|' + P_02 + '|' +
     C                             P_03 + '|' + %trim(P_04) + '|' +
     C                             %trim(P_05) + '|' + %trim(P_06) + '|' +
     C                             %trim(%editc(P_07:'Z')) + '|' +
     C                             %trim(%editc(P_08:'Z')) + '|' + P_09 + '|' +
     C                             P_10 + '|' +  P_11 + '|' +
     C                             %trim(P_12) + '|' +  %trim(P_13) + '|' +
     C                             %trim(P_14) + '|' +  %trim(P_15) + '|' +
     C                             %trim(P_16)
      *
     C                   Eval      *InLR = *On
     C                   Return
      **********************************************************************************
