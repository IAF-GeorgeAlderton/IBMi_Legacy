     H DATEDIT(*YMD.) Option(*SrcStmt:*NoDebugIO)
      ** IWAR70U1  ****************************************************
      *  UPDATE WASHER KANBAN IN INVENTORY AND LOG
      *   LEC   2025.07.07
      *****************************************************************
     FALBPL30   IF   E           K DISK
     FAKBPL06   IF   E           K DISK
     FIWAPP70   UF A E           K DISK
     FIWAPP7L   O  A E           K DISK
      *
     D  KBNBC          S             20
     D  NUM6           S              6  0
     D  ##TMNM         S             20
     D  Valid          S              1
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
     D  @WORD#                 6     11
     D  @WLOT#                13     16
      *
     D                SDS
     D  W#PGM            *PROC
     D  W#WSID               244    253
     D  W#USER               254    263
     D  W#JBNO               264    269
      *
     C     *Entry        PList
     C                   Parm                    PWKBN            20
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

     C                   Eval      @WKBN = PWKBN
     C                   Exsr      #SB100

     C                   If        Valid = 'Y'
     C                   Exsr      #SB500
     C                   Exsr      #SB501
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
      *  Washer Kanban Scan to Inventory File
      *----------------------------------------------------*
     C     #SB500        BegSr

     C                   Time                    @TIME
     C                   Clear                   IWAPP701

     C                   Eval      KBNBC = PWKBN
     C     KBNBC         Chain     IWAPP70                            62
     C                   If        *IN62 = *On
      *
     C                   Eval      W0KODT = @SYSHZ
     C                   Eval      W0KOTM = @SYSTM
     C                   Eval      W0KOUS = ##TMNM
     C                   Eval      W0CODT = @SYSHZ
     C                   Eval      W0COTM = @SYSTM
     C                   Eval      W0COUS = ##TMNM
     C                   Eval      W0KOPG = PPGMN

     C                   Eval      W0CBCD = PWKBN
     C                   Eval      W0ZETI = @WZETI
     C                   Eval      W0CHN1 = L1SHN1
     C                   Eval      W0CHN2 = L1SHN2
     C                   Eval      W0CHN3 = L1SHN3
     C                   Eval      W0CORD = @WORD#
     C                   Eval      W0CLOT = @WLOT#
     C                   Eval      W0CLC1 = L1TKR1
     C                   Eval      W0CLC2 = L1TKR2
     C                   Eval      W0CLC3 = L1TKR3
     C                   Eval      W0CLC4 = L1TKR4
     C                   Eval      W0SUPP = L1BMON
     C                   Eval      W0KTEI = L1KTEI
     C                   Eval      W0QPC  = L1SYOS
      *
     C                   Eval      W0PLOC = *blank
     C                   Eval      W0CLOC = PLOCN

     C                   Eval      W0MIFC = PSTEP
     C                   Eval      W0CSTS = 'F'

     C                   Write     IWAPP701
     C                   EndIf
      *
     C                   EndSr
      *----------------------------------------------------*
      * Write Washer Kanban Scan to Inventory Log File
      *----------------------------------------------------*
     C     #SB501        BegSr
      *
     C                   Clear                   IWAPP7L1
     C                   Eval      LGKODT  = @SYSHZ
     C                   Eval      LGKOTM  = @SYSTM
     C                   Eval      LGKOUS  = ##TMNM
     C                   Eval      LGKOPG  = PPGMN
      *
     C                   Eval      LGCBCD  = W0CBCD
     C                   Eval      LGZETI  = W0ZETI
     C                   Eval      LGCHN1  = W0CHN1
     C                   Eval      LGCHN2  = W0CHN2
     C                   Eval      LGCHN3  = W0CHN3
     C                   Eval      LGCORD  = W0CORD
     C                   Eval      LGCLOT  = W0CLOT

     C                   Eval      LGPLOC  = W0PLOC
     C                   Eval      LGCLOC  = W0CLOC
     C                   Eval      LGCSTS  = W0CSTS
      *
     C                   Write     IWAPP7L1
      *
     C                   EndSr
      *------------------------------------------------------------*

