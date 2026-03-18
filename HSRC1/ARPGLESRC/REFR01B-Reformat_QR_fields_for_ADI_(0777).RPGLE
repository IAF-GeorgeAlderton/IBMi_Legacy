     H option(*nodebugio:*srcstmt)
      //************************************************************************
      // REFR01B  (COPIED FROM REFR01A)
      // This program reformats all QR code fields into 1 pipe delimited QR code
      // QR Code for ADI  (0777)
      // JW          2025.07.31
      //************************************************************************
     C     *Entry        PList
     C                   Parm                    P1                5            Qualifier
     C                   Parm                    P2                6            Kanban#
     C                   Parm                    P3                7            Supplier
     C                   Parm                    P4                8            Serial#
     C                   Parm                    P5               20            Part#
     C                   Parm                    P6                4            Year
     C                   Parm                    P7                2            # of Box
     C                   Parm                    P8                2            ECI
     C                   Parm                    P9               16            PO#
     C                   Parm                    QRCODE          150            QR Code
      **********************************************************************************
      *         M    A    I    N    L    I    N    E
      **********************************************************************************
      *
     C                   Eval      QRCODE = %trim(P1)               + '|' +
     C                                      %trim(P2)               + '|' +
     C                                      %trim(P3)               + '|' +
     C                                      %trim(P3) + %trim(P4)   + '|' +
     C                                      %trim(P5)               + '|' +
     C                                      %trim(P6)               + '|' +
     C                                      %trim(P7)               + '|' +
     C                                      %trim(P8)               + '|' +
     C                                      %trim(P9)
      *
     C                   Eval      *InLR = *On
     C                   Return
