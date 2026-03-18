     H OPTION(*SRCSTMT : *NODEBUGIO) DatFmt(*ISO)

     FAM#PP46   IF   E           K DISK
     FAM#WP446P O  A E           K DISK

     D                SDS
     D  #PGM                   1     10
     D  #USER                254    263

     D  DateIn         S              8
     D  TimeIn         S              6
     D  SectIn         S              3
     D  SysDate        S              8  0
     D  SysTime        S              6  0
     D  QtrStrTime     S              6  0
     D  QtrEndTime     S              6  0
     D  CurShift       S              1  0
     D  CurQtr         S              1  0
     D  CalcPlanPct    S              4  3
     D  CalcPlanQty    S              6  3
     D  CurPlanQty     S              6  0
     D  TotPlanQty     S              6  0
     D  ShfPlanQty     S              6  0
     D  To_DTTM        S               Z
     D  Fr_DTTM        S               Z
     D  PastMinutes    S              6  3
     D  QtrMinutes     S              3  0
     D  DateRolled     S              1
     D  FromDate       S              8  0
     D  ToDate         S              8  0
     D  Sys_Date       S               D
     D  ShftStrDat     S              8  0

     D                 DS
     D  DT                     1      8  0
     D  TM                     9     14  0
     D  microsecs             15     20  0 inz(0)
     D  DTTM                   1     20  0

     C     *Entry        PList
     C                   Parm                    SectIn
     C                   Parm                    DateIn
     C                   Parm                    TimeIn

     C     Key46         KLIST
     C                   KFld                    SectIn

      *----------------------------------------------------------------
      *  M  A  I  N  L  I  N  E.
      *----------------------------------------------------------------
      *
     C                   Exsr      #Init
     C                   Exsr      #GetSSD
     C                   Exsr      #GetPlan
     C                   Exsr      #WrtPlan

     C                   Eval      *InLR = *On
     C                   Return
      *----------------------------------------------------------------
      *  Initialization
      *----------------------------------------------------------------
      *
     C     #Init         BegSr

      *  current date and time passed in as parameters...
     C                   Eval      SysTime= %dec(TimeIn:6:0)
     C                   Eval      SysDate= %dec(DateIn:8:0)

     C     Key46         SetLL     AM#PP46
      *  get current shift and current quarter of shift...
     C                   DoU       %eof
     C     Key46         ReadE     AM#PP46
     C                   If        SysTime >= T1Q1ST and SysTime <= T1Q4ET
     C                   Eval      CurShift = T1SHFT
     C                   Exsr      GetCurQtr
     C                   Leave
     C                   EndIf
     C                   EndDo

      *  if current shift was not found, it's 3rd shift, get current quarter-shift...
     C                   If        CurShift = *zero

     C                   Eval      CurShift = 3
     C                   Exsr      GetCurQtr

     C                   If        CurQtr = *zero
     C                   Eval      CurQtr = 1
     C                   Eval      QtrStrTime = T1Q1ST
     C                   Eval      QtrEndTime = T1Q1ET
     C                   Eval      CurPlanQty = T1QTY1
     C                   EndIf

     C                   Select
     C                   When      SysTime >= T1Q1ST and SysTime <= 235959
     C                   Eval      DateRolled = 'N'
     C                   When      SysTime >= *zero  and SysTime <= T1Q1ET
     C                   Eval      DateRolled = 'Y'
     C                   EndSl

     C                   EndIf

     C                   EndSr
      *----------------------------------------------------------------
      *  Get Shift Start Date
      *----------------------------------------------------------------
      *
     C     #GetSSD       BegSr

     C                   Select
     C                   When      CurShift < 3
     C                   Eval      ShftStrDat = SysDate
     C                   When      CurShift = 3 and DateRolled = 'N'
     C                   Eval      ShftStrDat = SysDate
     C                   Other
     C                   Eval      Sys_Date = %date(SysDate)
     C                   SubDur    1:*D          Sys_Date
     C                   Eval      ShftStrDat = %dec(Sys_Date)
     C                   EndSl

     C                   EndSr
      *----------------------------------------------------------------
      *  Get Current Quarter of Shift and QTD Planned Qty
      *----------------------------------------------------------------
      *
     C     GetCurQtr     BegSr

     C                   Select
     C                   When      SysTime >= T1Q1ST and SysTime <= T1Q1ET
     C                   Eval      CurQtr = 1
     C                   Eval      QtrStrTime = T1Q1ST
     C                   Eval      QtrEndTime = T1Q1ET
     C                   Eval      CurPlanQty = T1QTY1
     C                   When      SysTime >= T1Q2ST and SysTime <= T1Q2ET
     C                   Eval      CurQtr = 2
     C                   Eval      QtrStrTime = T1Q2ST
     C                   Eval      QtrEndTime = T1Q2ET
     C                   Eval      CurPlanQty = T1QTY2
     C                   Eval      TotPlanQty = T1QTY1
     C                   When      SysTime >= T1Q3ST and SysTime <= T1Q3ET
     C                   Eval      CurQtr = 3
     C                   Eval      QtrStrTime = T1Q3ST
     C                   Eval      QtrEndTime = T1Q3ET
     C                   Eval      CurPlanQty = T1QTY3
     C                   Eval      TotPlanQty = T1QTY1 + T1QTY2
     C                   When      SysTime >= T1Q4ST and SysTime <= T1Q4ET
     C                   Eval      CurQtr = 4
     C                   Eval      QtrStrTime = T1Q4ST
     C                   Eval      QtrEndTime = T1Q4ET
     C                   Eval      CurPlanQty = T1QTY4
     C                   Eval      TotPlanQty = T1QTY1 + T1QTY2 + T1QTY3
     C                   EndSl

     C                   Eval      ShfPlanQty=T1QTY1+T1QTY2+T1QTY3+T1QTY4

     C                   EndSr
      *----------------------------------------------------------------
      *  Get Planned Information
      *----------------------------------------------------------------
      *
     C     #GetPlan      BegSr

      * get the number of minutes between Qtr Start and Qtr End Times...= Qtr mins
      ***  quarter shift start date/time
     C                   Eval      DT = SysDate
     C                   Eval      TM = QtrStrTime
     C                   Eval      Fr_DTTM = %timestamp(DTTM)

      ***  3rd shift, quarter 1 logic...because it rolls from one day to the next...
      ***  if current date rolls from one day to the next...
     C                   If        DateRolled = 'Y'
     C                   SubDur    1:*D          Fr_DTTM
     C                   EndIf

     C                   Eval      FromDate = %dec(%date(Fr_DTTM))

      ***  quarter shift end date/time
     C                   Eval      DT = SysDate
     C                   Eval      TM = QtrEndTime
     C                   Eval      To_DTTM = %timestamp(DTTM)

      ***  3rd shift, quarter 1 logic...because it rolls from one day to the next...
      ***  if current date did NOT roll from one day to the next...
     C                   If        DateRolled = 'N'
     C                   AddDur    1:*D          To_DTTM
     C                   EndIf

     C                   Eval      ToDate = %dec(%date(To_DTTM))

      * calculate minutes within the entire quarter shift ...
     C                   Eval(H)   QtrMinutes = %diff(To_DTTM: Fr_DTTM: *mn) + 1

      * calculate minutes between quarter shift Start and Current time...= mins passed
     C                   Eval      DT = SysDate
     C                   Eval      TM = SysTime
     C                   Eval      To_DTTM = %timestamp(DTTM)
     C                   Eval      PastMinutes = %diff(To_DTTM: Fr_DTTM: *mn)

      * calculate percentage of qtr time-period passed...
     C                   Eval      CalcPlanPct = PastMinutes / QtrMinutes

      * calculate quantity that should be complete for this time period....planned qty...
     C                   Eval      CalcPlanQty = CurPlanQty * CalcPlanPct

      * total planned qty = passed quarter quantities plus the quantity for the current quarter...
     C                   Eval      TotPlanQty += CalcPlanQty

     C                   EndSr
      *----------------------------------------------------------------
      *  Write Planned Information to workfile
      *----------------------------------------------------------------
      *
     C     #WrtPlan      BegSr

     C                   Eval      W1SECT = SectIn
     C                   Eval      W1CDATE = SysDate
     C                   Eval      W1CTIME = SysTime

     C                   Eval      W1SHIFT = CurShift
     C                   Eval      W1SSDAT = ShftStrDat
     C                   Eval      W1SSTIM = T1Q1ST
     C                   Eval      W1SEDAT = ToDate
     C                   Eval      W1SETIM = T1Q4ET

     C                   Eval      W1Qtr = CurQtr
     C                   Eval      W1QSDAT = FromDate
     C                   Eval      W1QSTIM = QtrStrTime
     C                   Eval      W1QEDAT = ToDate
     C                   Eval      W1QETIM = QtrEndTime

     C                   Eval      W1QMINS = QtrMinutes
     C                   Eval      W1PMINS = PastMinutes
     C                   Eval      W1PPERC = CalcPlanPct

     C                   Eval      W1QPQTY = CalcPlanQty
     C                   Eval      W1SPQTY = TotPlanQty
     C                   Eval      W1STQTY = ShfPlanQty
     C                   Eval      W1QTQTY = CurPlanQty
     C                   Eval      W1STSEL = T1SELT

     C                   Write     AM#WP446P1
     C                   EndSr
      *----------------------------------------------------------------
