             PGM
             /** HOAC10 ********************************/
             /*   DELIVERY DATA REGISTRATION         */
             /*    MSK.......           2006.03.15     */
             /*                                        */
             /*    TCHK1 08/16/06 CHG FIXED OUTQ       */
             /* -------------------------------------  */
             /* JW  2026.01.20 CHG GCLSRC --> ACLSRC   */
             /**************************** HOAC10 ******/
             DCL        VAR(&WSID)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS1)      TYPE(*CHAR) LEN(1)
             DCL        VAR(&WS2)      TYPE(*CHAR) LEN(2)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)      TYPE(*CHAR) LEN(7)
             DCL        VAR(&KOJO)     TYPE(*CHAR) LEN(4)
             DCL        VAR(&PCMD)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&PPGMN)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&FILE01)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&SYS)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&CNT)      TYPE(*DEC)  LEN(10 0) VALUE(0)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CHGVAR     VAR(&WS2) VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&WS1) VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&FILE01) VALUE('FOAPP10' *CAT &WS2)

             DLTF       FILE(HWFILE1/&FILE01)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE01) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(FOAPP10) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          LVLCHK(*NO) AUT(*ALL)

RETRY:
         /*----------------------------------------------------*/
         /*   DELIVERY DATA REGISTRATION                     */
         /*----------------------------------------------------*/
             OVRDBF     FILE(FOAPP10) TOFILE(HWFILE1/&FILE01)
             CALL       PGM(FOAR10) PARM(&WS1 &KOJO &PPGMN)
             RTVMBRD    FILE(HWFILE1/&FILE01) NBRCURRCD(&CNT)
             IF         COND(&CNT *EQ 0) THEN(GOTO CMDLBL(END))

         /*----------------------------------------------------*/
         /*   DELIVERY DATA REGISTRATION(FINALPROCESSING)    */
         /*----------------------------------------------------*/
             OVRDBF     FILE(FOAPP10) TOFILE(HWFILE1/&FILE01)
             CHGVAR     VAR(&PCMD) VALUE(' ')
             CALL       PGM(FOAR11) PARM(&PCMD &KOJO &PPGMN)

             IF         COND(&PCMD *EQ '3') THEN(DO)
             GOTO       CMDLBL(RETRY)
             ENDDO

         /*----------------------------------------------------*/
         /*   行先票作成　　　　　　　　　　　　　　　       */
         /*----------------------------------------------------*/
             OVRDBF     FILE(FOAPP10) TOFILE(HWFILE1/&FILE01)
             OVRPRTF    FILE(FOAPR13) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(66) RPLUNPRT(*YES) +
/* TCHK1 */               OUTQ(LANPRT05) FORMTYPE(K6H1) IGCDTA(&PIGCD)
/* TCHK1                  OUTQ(&PRTG) FORMTYPE(K6H1) IGCDTA(&PIGCD) */
             CALL       PGM(FOAR13)

         /*----------------------------------------------------*/
         /* DELIVERY SLIP LIST                                 */
         /*----------------------------------------------------*/
             OVRDBF     FILE(FOAPP10) TOFILE(HWFILE1/&FILE01)
             OVRPRTF    FILE(FOAPR14) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(27) RPLUNPRT(*YES) +
/* TCHK1 */               OUTQ(LANPRT05) FORMTYPE(K6H1) IGCDTA(&PIGCD)
/* TCHK1                  OUTQ(&PRTG) FORMTYPE(K6H1) IGCDTA(&PIGCD) */
             CALL       PGM(FOAR14) PARM(&KOJO)

         /*----------------------------------------------------*/
         /*  IAF > ASJ   DATA TRANSFER                         */
         /*----------------------------------------------------*/
             CHGVAR     VAR(&SYS) VALUE('SYSTEM1')

             DLTOVR     FILE(*ALL)
             DLTF       FILE(HWFILE1/FOAPP10IAF)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/FOAPP10IAF) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(FOAPP10) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          LVLCHK(*NO) AUT(*ALL)

             CPYF       FROMFILE(HWFILE1/&FILE01) +
                          TOFILE(HWFILE1/FOAPP10IAF) MBROPT(*ADD) +
                          INCREL((*IF OBSKJY *EQ ' ')) FMTOPT(*MAP +
                          *DROP)

             RTVMBRD    FILE(HWFILE1/FOAPP10IAF) NBRCURRCD(&CNT)
             IF         COND(&CNT *NE 0) THEN(DO)
             SNDNETF    FILE(HWFILE1/FOAPP10IAF) TOUSRID((QFILE +
                          &SYS))
             /*------------------------------------------*/
             /*   ...SBMNETJOB rｮnﾝｰh ﾆﾞｭﾎﾞ ﾉ ncpｬc...   */
             /*------------------------------------------*/
             SBMNETJOB  FILE(HSRC1/ACLSRC) TOUSRID((QFILE &SYS)) +
                          MBR(FOATX2)
             ENDDO
END:
             ENDPGM
