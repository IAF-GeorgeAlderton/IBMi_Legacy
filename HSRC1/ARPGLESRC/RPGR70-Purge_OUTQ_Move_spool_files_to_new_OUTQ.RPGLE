     H option(*nodebugio:*srcstmt)
      //************************************************************************
      // RPGR70
      // LEC          2019/01/28
      // This program purges spool files from specified OUTQ if older than 4 months
      // and moves spool file if created within the last 3 months to the new OUTQ
      // that has been set up for OQ new laser printers. IAF wanted to keep outq
      // name the same but hang on to last 4 months worth of spool files.
      //************************************************************************

     FOQSPLFILESIF   F  132        DISK

     D SysDateYMD      S               D   inz(*SYS) datfmt(*ymd)               system date (date)
     D CutOffDate      S               D   datfmt(*ymd)                         cutoff date (date)
     D Today           S              6S 0                                      today's date
     D CutOff60        S              6S 0                                      delete all before
      *                                                                         move all after this
      *                                                                         leave today alone
     D CrtDate         S              6S 0                                      date file created
     D CrtTime         S              6S 0                                      time file created
     D CrtYMD          S              6                                         date file created
     D CrtHMS          S              6                                         time file created
     D OutQ            S             10
     D NewOutQ         S             10

     IOQSPLFILESAA  01
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
      *
     C                   Move      SysDateYMD    Today
     C     SysDateYMD    SubDur    4:*months     CutOffDate
     C                   Move      CutOffDate    CutOff60
     C                   Eval      NewOutQ = %trim(OutQ) + 'NW'
      *
     C                   Do        *HiVal
      *
     C                   Read      OQSPLFILES                             50
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
     C                   Select
     C                   When      CrtDate < CutOff60
      *   delete spool file
     C                   Call      'UTLC70D'
     C                   Parm                    filename
     C                   Parm                    jobname
     C                   Parm                    userid
     C                   Parm                    jobnbr
     C                   Parm                    splnbr
     C                   Parm                    CrtYMD
     C                   Parm                    CrtHMS
     C                   When      CrtDate >= CutOff60
      *   move spool file to new outq
      *******            Call      'UTLC70M'
      *******            Parm                    filename
      *******            Parm                    jobname
      *******            Parm                    userid
      *******            Parm                    jobnbr
      *******            Parm                    splnbr
      *******            Parm                    CrtYMD
      *******            Parm                    CrtHMS
      *******            Parm                    NewOutq
     C                   EndSl
      *
     C                   EndDo
      *
     C                   Eval      *InLR = *On
     C                   Return
      *
      **********************************************************************************
