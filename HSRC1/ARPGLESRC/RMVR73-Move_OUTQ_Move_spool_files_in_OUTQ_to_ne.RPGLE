     H option(*nodebugio:*srcstmt)
      //************************************************************************
      // RMVR73
      // LEC          2019/04/08
      // This program moves spool files from specified OUTQ to the new OUTQ.
      //************************************************************************

     FSPLFILES  IF   F  132        DISK

     D CrtDate         S              6S 0                                      date file created
     D CrtTime         S              6S 0                                      time file created
     D CrtYMD          S              6                                         date file created
     D CrtHMS          S              6                                         time file created
     D OutQ            S             10
     D NewOutQ         S             10

     ISPLFILES  AA  01
     I                                  1  132  REC
     I                                  2   11  filename
     I                                 13   22  userid
     I                                 70   78  splnbr
     I                                 84   93  jobname
     I                                 95  100  jobnbr
     I                                102  103  CRTYY
     I                                105  106  CRTMO
     I                                108  109  CRTDD
     I                                111  112  CRTHH
     I                                114  115  CRTMN
     I                                117  118  CRTSS
     I                                111  114  HEADING

      **********************************************************************************
      *         M    A    I    N    L    I    N    E
      **********************************************************************************
      *
     C     *Entry        PList
     C                   Parm                    OutQ
     C                   Parm                    NewOutQ
      *
     C                   Do        *HiVal
      *
     C                   Read      SPLFILES                               50
     C                   If        *In50 = *On
     C                   Leave
     C                   EndIf
      *
     C                   If        HEADING = *blanks  OR HEADING = 'Time'
     C                   Iter
     C                   EndIf
      *
     C                   Eval      CrtYMD  = CRTYY + CRTMO + CRTDD
     C                   Eval      CrtHMS  = CRTHH + CRTMN + CRTSS
     C                   Eval      CrtDate = %dec(CRTYY + CRTMO + CRTDD:6:0)
     C                   Eval      CrtTime = %dec(CRTHH + CRTMN + CRTSS:6:0)
     C                   Eval      splnbr = %trim(splnbr)
      *
      *   move spool file to new outq
     C                   Call      'UTLC73M'
     C                   Parm                    filename
     C                   Parm                    jobname
     C                   Parm                    userid
     C                   Parm                    jobnbr
     C                   Parm                    splnbr
     C                   Parm                    CrtYMD
     C                   Parm                    CrtHMS
     C                   Parm                    NewOutq
     C                   EndDo
      *
     C                   Eval      *InLR = *On
     C                   Return
      *
      **********************************************************************************
