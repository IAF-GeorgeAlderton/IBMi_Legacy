     H DATEDIT(*YMD.) Option(*SrcStmt:*NoDebugIO)
      ** IWAR70U2  ****************************************************
      *  UPDATE WASHER ORDER IN INVENTORY AND LOG FILES
      *   LEC   2025.07.07
      *****************************************************************
     FALBPL30   IF   E           K DISK
     FAKBPL06   IF   E           K DISK
     FGDMPL10   IF   E           K DISK
     FIWAPP70   UF   E           K DISK
     FIWAPP71   UF A E           K DISK
     FIWAPP7L   O  A E           K DISK
      *
     D  KBNBC          S             20
     D  NUM6           S              6  0
     D  ##LOTSZ        S              2  0
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
     D                 DS
     D  @WOKBN                 1     20
     D  @WOTYP                 1      1
     D  @WOZET                 2      5
     D  @WOORD                 6     11
     D  @WOLOT                13     16
      *
     D                SDS
     D  W#PGM            *PROC
     D  W#WSID               244    253
     D  W#USER               254    263
     D  W#JBNO               264    269
      *
     C     *Entry        PList
     C                   Parm                    PWKBN            20
     C                   Parm                    PWOKB            20
     C                   Parm                    PLOCN             6
     C                   Parm                    PWKCD             6
     C                   Parm                    PPGMN            10
     C                   Parm                    PSTEP             1
     C                   Parm                    #RTNC             1

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
     C                   Eval      @WOKBN= PWOKB
     C                   Exsr      #SB100

     C                   If        Valid = 'Y'
     C                   Exsr      #SB70
     C                   Exsr      #SB70L
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

      * get lot size...
     C     Key2          KList
     C                   KFld                    L1SHN1
     C                   KFld                    L1SHN2
     C                   KFld                    L1SHN3

     C     Key2          Chain     GDMPL10
     C                   If        %found(GDMPL10)
     C                   Eval      ##LOTSZ = M1LOTN
     C                   EndIf

     C                   EndSr
      *----------------------------------------------------*
      *  Washer Kanban Scan to Inventory File
      *----------------------------------------------------*
     C     #SB70         BegSr

     C                   Time                    @TIME
     C                   Clear                   IWAPP701

     C                   Eval      KBNBC = PWKBN
     C     KBNBC         Chain     IWAPP70                            62
     C                   If        *IN62 = *Off and W0CSTS = 'F'
     C                   Eval      W0KODT = @SYSHZ
     C                   Eval      W0KOTM = @SYSTM
     C                   Eval      W0KOUS = ##TMNM
     C                   Eval      W0KOPG = PPGMN

     C                   Eval      W0OBCD = PWOKB
     C                   Eval      W0OZET = @WOZET
     C                   Eval      W0OLOT = @WOLOT
     C                   Eval      W0OORD = @WOORD
     C                   Eval      W0OQTY = ##LOTSZ * L1SYOS

     C                   Eval      W0PLOC = W0CLOC
     C                   Eval      W0CLOC = PLOCN
     C                   Eval      W0CSTS = 'C'

     C                   Eval      W0MIFC = PSTEP

     C                   Update    IWAPP701
     C                   Exsr      #SB71
     C                   EndIf
      *
     C                   EndSr
      *----------------------------------------------------*
      *  Washer Kanban Scan to Inventory File - CANS
      *----------------------------------------------------*
     C     #SB71         BegSr

     C                   Clear                   IWAPP711

     C     PWOKB         Chain     IWAPP71                            62
     C                   If        *IN62 = *On
     C                   Eval      W1KODT = @SYSHZ
     C                   Eval      W1KOTM = @SYSTM
     C                   Eval      W1KOUS = ##TMNM
     C                   Eval      W1KOPG = PPGMN

     C                   Eval      W1CODT = @SYSHZ
     C                   Eval      W1COTM = @SYSTM
     C                   Eval      W1COUS = ##TMNM

     C                   Eval      W1OBCD = PWOKB
     C                   Eval      W1OZET = @WOZET
     C                   Eval      W1OLOT = @WOLOT
     C                   Eval      W1OORD = @WOORD
     C                   Eval      W1OQTY = L1SYOS
     C                   Eval      W1SUPP = L1BMON

     C                   Eval      W1PLOC = *BLANK
     C                   Eval      W1CLOC = PLOCN
     C                   Eval      W1OSTS = 'F'
     C                   Eval      W1MIFC = PSTEP
     C                   Write     IWAPP711

     C                   Else
     C                   Eval      W1KODT = @SYSHZ
     C                   Eval      W1KOTM = @SYSTM
     C                   Eval      W1KOUS = ##TMNM
     C                   Eval      W1KOPG = PPGMN
     C                   Eval      W1OQTY += L1SYOS

     C                   Update    IWAPP711
     C                   EndIf
      *
     C                   EndSr
      *----------------------------------------------------*
      * Write Washer Kanban Scan to Inventory Log File
      *----------------------------------------------------*
     C     #SB70L        BegSr
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

     C                   Eval      LGOBCD  = W1OBCD
     C                   Eval      LGOZET  = W1OZET
     C                   Eval      LGOORD  = W1OORD
     C                   Eval      LGOLOT  = W1OLOT
     C                   Eval      LGOQTY  = W1OQTY

     C                   Eval      LGPLOC  = W0PLOC
     C                   Eval      LGCLOC  = W0CLOC
      *
     C                   Eval      LGCSTS  = W0CSTS
     C                   Eval      LGOSTS  = W1OSTS
      *
     C                   Write     IWAPP7L1
      *
     C                   EndSr
      *------------------------------------------------------------*

