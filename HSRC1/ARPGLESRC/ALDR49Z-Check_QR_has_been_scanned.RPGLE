     H OPTION(*SRCSTMT : *NODEBUGIO) DatFmt(*ISO)

     FALDPL35E  IF   E           K DISK

     D                SDS
     D  #PGM                   1     10
     D  #WSID                244    253
     D  #USER                254    263

      *  current date/time
     D                 DS
     D  WSDT                   1     14  0
     D  InTime                 1      4
     D  InDate                 7     14

      *  record scanned date/time
     D                 DS
     D  ScanDTTM               1     12  0
     D  A9CODT                 1      8  0
     D  A9COTM                 9     14  0

      *  date/time 4 hours before current date/time
     D                 DS
     D  DTTM4hrsAgo            1     12  0
     D  RtnDate                1      8
     D  RtnTime                9     12

     D                 DS
     D  QRcode                 1    512
     D  QR1                    1    256
     D  QR2                  257    512

     C     *Entry        PList
     C                   Parm                    InQR1           256
     C                   Parm                    InQR2           256
     C                   Parm                    ReturnCode        1

      *----------------------------------------------------------------
      *  M  A  I  N  L  I  N  E.
      *----------------------------------------------------------------

     C                   Eval      QR1 = InQR1
     C                   Eval      QR2 = InQR2

     C                   Time                    WSDT
     C                   Exsr      Get4HrsAgo

      *  check file for QR code, if there get last scanned date/time...
     C     QRcode        SetGT     ALDPL35E

     C                   DoW       NOT %eof(ALDPL35E)
     C     QRcode        ReadPE    ALDPL35E

     C                   If        %eof(ALDPL35E)
     C                   Eval      ReturnCode = *blank
     C                   Leave
     C                   EndIf

     C                   If        A9SKJY = 'D'
     C                   Iter
     C                   EndIf

      * if qr code scanned between now and 4 hours ago, then throw error...
     C                   If        ScanDTTM > DTTM4hrsAgo
     C                   Eval      ReturnCode = 'E'
     C                   Else
     C                   Eval      ReturnCode = *blank
     C                   EndIf

     C                   Leave
     C                   EndDo

     C                   Eval      *InLR = *On
     C                   Return
      *----------------------------------------------------------------
      *  Get Date/Time 4 Hours Ago...
      *----------------------------------------------------------------
      *
     C     Get4HrsAgo    BegSr

      *  subtract 240 minutes from current date/time...4 hours ago...
     C                   Call      'DATR45'
     C                   Parm                    InDate
     C                   Parm                    InTime
     C                   Parm                    RtnDate
     C                   Parm                    RtnTime
     C                   Parm      '-'           Operand           1
     C                   Parm      '00240'       Minutes           5

     C                   EndSr
      *----------------------------------------------------------------
