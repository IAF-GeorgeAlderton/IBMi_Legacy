     H DATEDIT(*YMD.) Option(*SrcStmt:*NoDebugIO)
      ** IWAR77U2  ****************************************************
      *  UPDATE OUTSOURCE WASHER INVENTORY AND LOG - steps 2,3,4,6
      *   LEC   2025.10.16
      *****************************************************************
     FALBPL30   IF   E           K DISK
     FAKBPL06   IF   E           K DISK
     FAKBPL07   IF   E           K DISK
     FIWAPP71   UF A E           K DISK
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
     D  @RKBN                  1     20
     D  @RTYPE                 1      1
     D  @RSHIN                 1     14
     D  @RSHN1                 1      5
     D  @RSHN2                 7     11
     D  @RSHN3                13     14
      *
     D                 DS
     D  @OKBN                  1     20
     D  @OTYPE                 1      1
     D  @OZETI                 2      5
     D  @OSUPP                 6      9  0
     D  @OPAGE                11     13
      *
     D D5QR            DS
     D  D5QRA                  1    256
     D  D5TYPE                 1      3
     D  D5SHIN                34     45
     D  D5SHN1                34     38
     D  D5SHN2                39     43
     D  D5SHN3                44     45
     D  D5NXLC                53     58
     D  D5MLC1                53     53
     D  D5MLC2                54     55
     D  D5MLC3                56     57
     D  D5MLC4                58     58
     D  D5FRLC                79     84
     D  D5PROC               175    177
     D  D5MCH#               178    180
     D  D5CHIN               219    230
     D  D5CHN1               219    223
     D  D5CHN2               224    228
     D  D5CHN3               229    230
     D  D5QRB                257    400
      *
     D                SDS
     D  W#PGM            *PROC
     D  W#WSID               244    253
     D  W#USER               254    263
     D  W#JBNO               264    269
      *
     C     *Entry        PList
     C                   Parm                    PRTKAN           20
     C                   Parm                    PORKAN           20
     C                   Parm                    PMFKAN          400
     C                   Parm                    PLOTID           20
     C                   Parm                    PWKCD             6
     C                   Parm                    PPGMN            10
     C                   Parm                    PLOCN             6
     C                   Parm                    POSTS             1
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

     C                   If        PRTKAN <> *blank
     C                   Eval      @RKBN = PRTKAN
     C                   Exsr      #SB050
     C                   EndIf

     C                   If        PORKAN <> *blank
     C                   Eval      @OKBN = PORKAN
     C                   Exsr      #SB100
     C                   EndIf

     C                   If        Valid = 'Y'
     C                   Exsr      #SB71
     C                   EndIf

     C                   Eval      #RTNC = Valid
     C                   Eval      *InLR = *On
     C                   Return

      *------------------------------------------------------*
      * Check Washer Kanban Master File
      *------------------------------------------------------*
     C     #SB050        BegSr

     C                   Eval      L1STYY = 9999

      * check for washer part number...
     C     Key1          KList
     C                   KFld                    @RSHN1
     C                   KFld                    @RSHN2
     C                   KFld                    @RSHN3
     C                   KFld                    L1STYY

     C     Key1          Chain     AKBPL07
     C                   If        %found
     C                   Eval      Valid = 'Y'
     C                   Else
     C                   Eval      Valid = 'N'
     C                   EndIf

     C                   EndSr
      *----------------------------------------------------*
      * Check Washer Kanban Master File
      *------------------------------------------------------*
     C     #SB100        BegSr

      * check for washer ID...
     C     Key2          KList
     C                   KFld                    @OZETI

     C     Key2          SetGT     AKBPL06
      *
     C                   DoW       *In91 = *Off
     C     Key2          ReadPE    AKBPL06                                91

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
     C                   If        *IN62 = *Off
     C                   Eval      W1KODT = @SYSHZ
     C                   Eval      W1KOTM = @SYSTM
     C                   Eval      W1KOUS = ##TMNM
     C                   Eval      W1KOPG = PPGMN

     C                   Eval      W1CODT = @SYSHZ
     C                   Eval      W1COTM = @SYSTM
     C                   Eval      W1COUS = ##TMNM

     C                   Eval      W1OSTS = POSTS
     C                   Eval      W1MIFC = PSTEP

     C                   If        PMFKAN <> *blank
     C                   Eval      D5QR  = PMFKAN
     C                   Eval      W1PBCD = PMFKAN
     C                   Eval      W1MHN1 = D5SHN1
     C                   Eval      W1MHN2 = D5SHN2
     C                   Eval      W1MHN3 = D5SHN3

     C                   Eval      W1PHN1 = D5CHN1
     C                   Eval      W1PHN2 = D5CHN2
     C                   Eval      W1PHN3 = D5CHN3

     C                   Eval      W1MLC1 = D5MLC1
     C                   Eval      W1MLC2 = D5MLC2
     C                   Eval      W1MLC3 = D5MLC3
     C                   Eval      W1MLC4 = D5MLC4

     C                   Eval      W1PROC = D5PROC
     C                   Eval      W1MCH# = D5MCH#
     C                   EndIf

     C                   Eval      W1PLOC = W1CLOC
     C                   Eval      W1CLOC = PLOCN

     C                   If        PORKAN <> *blank and PORKAN <> W1FLD4
     C                   Eval      W1FLD4 = PORKAN
     C                   EndIf

     C                   If        PRTKAN <> *blank
     C                   Eval      W1RBCD = PRTKAN
     C                   EndIf

     C                   Update    IWAPP711
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

