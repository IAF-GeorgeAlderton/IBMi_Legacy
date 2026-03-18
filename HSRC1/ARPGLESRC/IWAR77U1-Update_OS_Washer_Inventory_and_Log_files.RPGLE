     H DATEDIT(*YMD.) Option(*SrcStmt:*NoDebugIO)
      ** IWAR77U1  ****************************************************
      *  UPDATE OUTSOURCE WASHER INVENTORY AND LOG
      *   LEC   2025.08.20
      *****************************************************************
     FALBPL30   IF   E           K DISK
     FAKBPL06   IF   E           K DISK
     FIWAPP71   UF A E           K DISK
     FIWAPP7L   O  A E           K DISK
      *
     D  KBNBC          S             20
     D  NUM6           S              6  0
     D  ##TMNM         S             20
     D  Valid          S              1
     D  PQTY           S              6P 0
      *
     D                 DS
     D  @TIME                  1     14  0
     D  @SYSTM                 1      6  0
     D  @SYSHZ                 7     14  0
      *
     D                 DS
     D  @WKBN                  1     20
     D  @WTYPE                 1      1
     D  @WZETI                 2      5
     D  @WSUPP                 6      9  0
     D  @WPAGE                11     13
      *
     D                SDS
     D  W#PGM            *PROC
     D  W#WSID               244    253
     D  W#USER               254    263
     D  W#JBNO               264    269
      *
     C     *Entry        PList
     C                   Parm                    POKBN            20
     C                   Parm                    PLOTID           20
     C                   Parm                    PQTY
     C                   Parm                    PLOCN             6
     C                   Parm                    PWKCD             6
     C                   Parm                    PPGMN            10
     C                   Parm                    PSTEP             1
     C                   Parm                    #RTNC             1
      *
      *
      * get worker name...
     C                   Eval      NUM6 = %dec(PWKCD:6:0)
     C     NUM6          Chain     ALBPL30                            98
     C                   If        *IN98 = *OFF
     C                   Eval      ##TMNM = ALWKNM
     C                   Else
     C                   Eval      ##TMNM = *blank
     C                   EndIf
      *
      *----------------------------------------------------*
      * Mainline                                           *
      *----------------------------------------------------*
      *

     C                   Eval      @WKBN = POKBN
     C                   Exsr      #SB100

     C                   If        Valid = 'Y'
     C                   Exsr      #SB71
     C                   EndIf

     C                   Eval      #RTNC = Valid
     C                   Eval      *InLR = *On
     C                   Return

      *------------------------------------------------------*
      * Check Washer Kanban Master File
      *------------------------------------------------------*
     C     #SB100        BegSr

      * check for washer ID...
     C     Key1          KList
     C                   KFld                    @WZETI

     C     Key1          SetGT     AKBPL06
      *
     C                   DoW       *In91 = *Off
     C     Key1          ReadPE    AKBPL06                                91

     C                   If        *In91 = *On
     C                   Leave
     C                   EndIf
      *
     C                   If        L1SKJY = 'D'
     C                   Iter
     C                   EndIf
      *
     C                   If        L1STYY = 9999
     C                   Leave
     C                   EndIf
     C                   EndDo

     C                   If        *IN91 = *On
     C                   Eval      Valid = 'N'
     C                   Else
     C                   Eval      Valid = 'Y'
     C                   EndIf

     C                   EndSr
      *----------------------------------------------------*
      *  Washer Kanban Scan to Inventory File - CANS
      *----------------------------------------------------*
     C     #SB71         BegSr

     C                   Time                    @TIME
     C                   Clear                   IWAPP711

     C     PLOTID        Chain     IWAPP71                            62
     C                   If        *IN62 = *On
     C                   Eval      W1KODT = @SYSHZ
     C                   Eval      W1KOTM = @SYSTM
     C                   Eval      W1KOUS = ##TMNM
     C                   Eval      W1KOPG = PPGMN

     C                   Eval      W1CODT = @SYSHZ
     C                   Eval      W1COTM = @SYSTM
     C                   Eval      W1COUS = ##TMNM

     C                   Eval      W1OBCD = PLOTID
     C                   Eval      W1OZET = @WZETI
     C                   Eval      W1OORD = *blanks
     C                   Eval      W1OLOT = *blanks
     C                   Eval      W1OQTY = PQTY
     C                   Eval      W1OSTS = 'F'
     C                   Eval      W1SUPP = @WSUPP
     C                   Eval      W1MIFC = PSTEP

     C                   Eval      W1PLOC = *blank
     C                   Eval      W1CLOC = PLOCN
     C                   Eval      W1FLD4 = POKBN
     C                   Write     IWAPP711
     C                   Exsr      #SB7L
     C                   EndIf
      *
     C                   EndSr
      *----------------------------------------------------*
      * Write Washer Kanban Scan to Inventory Log File
      *----------------------------------------------------*
     C     #SB7L         BegSr
      *
     C                   Clear                   IWAPP7L1
     C                   Eval      LGKODT  = @SYSHZ
     C                   Eval      LGKOTM  = @SYSTM
     C                   Eval      LGKOUS  = ##TMNM
     C                   Eval      LGKOPG  = PPGMN
      *
     C                   Eval      LGZETI  = W1OZET
     C                   Eval      LGCHN1  = L1SHN1
     C                   Eval      LGCHN2  = L1SHN2
     C                   Eval      LGCHN3  = L1SHN3
      *
     C                   Eval      LGOBCD  = W1OBCD
     C                   Eval      LGOZET  = W1OZET
     C                   Eval      LGOORD  = *blanks
     C                   Eval      LGOLOT  = *blanks
     C                   Eval      LGOQTY  = W1OQTY

     C                   Eval      LGOSTS  = W1OSTS
     C                   Eval      LGPLOC  = W1PLOC
     C                   Eval      LGCLOC  = W1CLOC
      *
     C                   Write     IWAPP7L1
      *
     C                   EndSr
      *------------------------------------------------------------*

