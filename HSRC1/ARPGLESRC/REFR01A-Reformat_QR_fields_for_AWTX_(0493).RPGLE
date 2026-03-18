     H option(*nodebugio:*srcstmt)
      //************************************************************************
      // REFR01A  (COPIED FROM REFR01)
      // This program reformats all QR code fields into 1 pipe delimited QR code
      // QR Code for AWTX (0493)
      // JW          2025.07.17
      //************************************************************************
     C     *Entry        PList
     C                   Parm                    P1                5            Qualifier
     C                   Parm                    P2                6            Kanban#
     C                   Parm                    P3                7            Supplier
     C                   Parm                    P4                8            Serial#
     C                   Parm                    P5               22            Part#
     C                   Parm                    P6                6            QTY
     C                   Parm                    P7                2            ECI
     C                   Parm                    P8               16            RAN#
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
     C                                      %trim(P8)
      *
     C                   Eval      *InLR = *On
     C                   Return
