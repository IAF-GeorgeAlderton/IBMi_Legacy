/** AB#C2F ************************************************/
/*  TAKUMI ORDER PROCESSING                               */
/*  ORDER/FORECAST UPLOAD PROCESS              2006.02.09 */
/*  (THIS PROGRAM IS CALLED BY AB#R2Z)                    */
/*                                                        */
/*  TCHK1 10/29/09 RE-MAKE                                */
/*  TCHK2 12/11/09 RMV OHASHI FORECAST PROCESS            */
/*  TCHK3 05/20/10 ADD TIEM ORDER PROCESS                 */
/*  TCHK4 05/28/10 ADD TAKUMI CANADA ORDER PROCESS        */
/*  TCHK5 10/26/12 ADD ACZ ORDER PROCESS                  */
/*  TCHK6 08/29/13 CHG PRINT SETTING                      */
/*  TCHK7 11/12/13 ADD ARJ ORDER PROCESS                  */
/*  TCHK8 06/18/14 CHG NIFAST(MI) FORECAST PROCESS        */
/*  TCHK9 07/22/14 ADD ADI ORDER/FORECAST PROCESS         */
/*  JW1   05/31/17 SAVE TAKUMITX TO TAKUMITX@             */
/*  JW2   06/19/17 ADD OVRDBF TO CALENDAR FILE            */
/*  JW3   02/01/18 ADD A#R0556U FOR FUTABA CHICAGO        */
/*  JW3            ADD A#R0579U FOR FUTABA CANADA         */
/*  JW4   05/22/18 ADD CPYF COMMAND                       */
/**********************************************************/
 PGM     PARM(&PSIRE)
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&SR)     TYPE(*CHAR) LEN(2)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PFLG)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE1)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE2)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE3)  TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE4)  TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE5)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE6)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&PSIRE)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&SIREF)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&PID)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&ID)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&PFG)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PTN)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PYM)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&ABADS1) TYPE(*CHAR) LEN(48)
             DCL        VAR(&REC)    TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&USER2) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&PRTG) VALUE('LANPRT50  ')
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGJOB     SWS(00000000)

/* PMO ************************************************************/
             IF         COND(&PSIRE *EQ '0681') THEN(DO)
             CHGVAR     VAR(&SR) VALUE('PM')
             CHKOBJ     OBJ(PMO)  OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@SKP1))

             OVRDBF     FILE(AB#WPMO) TOFILE(&WLIB/AB#WPMO)
             CLRPFM     FILE(AB#WPMO)
             OVRDBF     FILE(PMO)     TOFILE(&WLIB/PMO)
             CALL       PGM(A#R0681O) PARM(&PID)

             OVRDBF     FILE(ABAWPMF) TOFILE(&WLIB/ABAWPMF)
             CLRPFM     FILE(ABAWPMF)
             CALL       PGM(A#R0681F) PARM(&ID)

/* SAVE PMO  JW  */
             CPYF       FROMFILE(HWFILE1/PMO) +
                          TOFILE(TWFILE1/PMOSV) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2802)

             DLTF       FILE(PMO)

             IF         COND(&ID *NE ' ') THEN(DO)
  /*JW*/                OVRPRTF    FILE(QPRINT2) LPI(6) +
                                     RPLUNPRT(*YES) OUTQ(EPRINT1 ) +
                                     FORMTYPE(K6H1) HOLD(*YES)
                        CALL       PGM(ABAR1K)
                        DLTOVR     FILE(QPRINT2)
                        CALL       PGM(ABACP6) PARM(&PSIRE)
             ENDDO

             IF         COND(&PID *EQ ' ') THEN(DO)
                        GOTO       CMDLBL(@END)
             ENDDO
             ENDDO

/* TAKUMI OHIO ****************************************************/
             IF         COND(&PSIRE *EQ '0645') THEN(DO)
             CHGVAR     VAR(&SR) VALUE('TA')
             CHKOBJ     OBJ(TAKUMI) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@SKP1))

             CLRPFM     FILE(AB#WTAK)
             CALL       PGM(A#R0645O) PARM(&PID)

             OVRDBF     FILE(ABAWTAF) TOFILE(&WLIB/ABAWTAF)
             CLRPFM     FILE(ABAWTAF)
             CALL       PGM(A#R0645F) PARM(&ID)

             IF         COND(&ID *NE ' ') THEN(DO)
  /*JW*/                OVRPRTF    FILE(QPRINT2) LPI(6) +
                                     RPLUNPRT(*YES) OUTQ(EPRINT1 ) +
                                     FORMTYPE(K6H1) HOLD(*YES)
                        CALL       PGM(A#R0645G)
                        DLTOVR     FILE(QPRINT2)
                        CALL       PGM(ABACP6) PARM(&PSIRE)

             ENDDO

/* SAVE TAKUMI  JW  */
             CPYF       FROMFILE(HWFILE1/TAKUMI) +
                          TOFILE(TWFILE1/TAKUMISV) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2802)

             DLTF       FILE(TAKUMI)
             IF         COND(&PID *EQ ' ') THEN(DO)
             GOTO       CMDLBL(@END)
             ENDDO
             ENDDO

/* TAKUMI TEXAS ***************************************************/
             IF         COND(&PSIRE *EQ '0646') THEN(DO)
             RTVMBRD    FILE(TAKUMITX) NBRCURRCD(&REC)
  /*JW*/     MONMSG     MSGID(CPF9812) EXEC(GOTO CMDLBL(@JUMP))

@JUMP:
             CHGVAR     VAR(&SR) VALUE('TX')
             CHKOBJ     OBJ(TAKUMITX) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@SKP1))

             OVRDBF     FILE(AB#WTAX) TOFILE(&WLIB/AB#WTAX)
             CLRPFM     FILE(AB#WTAX)
             CALL       PGM(A#R0646O) PARM(&PID)
             OVRDBF     FILE(ABAWTAXF) TOFILE(&WLIB/ABAWTAXF)
             CLRPFM     FILE(ABAWTAXF)
             CALL       PGM(A#R0646F) PARM(&ID)

             IF         COND(&ID *NE ' ') THEN(DO)
 /*JW*/                 OVRPRTF    FILE(QPRINT2) LPI(6) +
                                     RPLUNPRT(*YES) OUTQ(EPRINT1 ) +
                                     FORMTYPE(K6H1) HOLD(*YES)
                        CALL       PGM(A#R0646G)
                        DLTOVR     FILE(QPRINT2)
                        CALL       PGM(ABACP6) PARM(&PSIRE)
             ENDDO

/* SAVE TAKUMITX JW          */
             CPYF       FROMFILE(HWFILE1/TAKUMITX) +
                          TOFILE(TWFILE1/TAKUMITXSV) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2802)

             DLTF       FILE(TAKUMITX)

             IF         COND(&PID *EQ ' ') THEN(DO)
             GOTO       CMDLBL(@END)
             ENDDO
             ENDDO

/* TAKUMI CANADA **************************************************/
             IF         COND(&PSIRE *EQ '0647') THEN(DO)
             CHGVAR     VAR(&SR) VALUE('TC')
             CHKOBJ     OBJ(TAKUMICN) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@SKP1))

             OVRDBF     FILE(AB#WTAC) TOFILE(&WLIB/AB#WTAC)
             CLRPFM     FILE(AB#WTAC)
             CALL       PGM(A#R0647O) PARM(&PID)

             CPYF       FROMFILE(*LIBL/TAKUMICN) +
                          TOFILE(*LIBL/TAKUMICNSV) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2802)

             DLTF       FILE(TAKUMICN)

             IF         COND(&PID *EQ ' ') THEN(DO)
             GOTO       CMDLBL(@END)
             ENDDO
             ENDDO

/* OHASHI *********************************************************/
             IF         COND(&PSIRE *EQ '5671') THEN(DO)
             CHGVAR     VAR(&SR) VALUE('OH')
             CHKOBJ     OBJ(OHASHI) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@SKP1))

             CLRPFM     FILE(AB#WOHA)
             CALL       PGM(A#R5671O) PARM(&PID &PFG &PTN)
             CPYF       FROMFILE(HWFILE1/OHASHI) TOFILE(HWFILE1/OHASHISV) +
                        MBROPT(*ADD) FMTOPT(*CVTSRC)
             MONMSG     MSGID(CPF2802)

             DLTF       FILE(OHASHI)
             IF         COND(&PID *EQ ' ') THEN(DO)
             GOTO       CMDLBL(@END)
             ENDDO

    /* FORECAST                                     */
    /* TCHK2 CALL       PGM(ABAR1R)                 */
    /* TCHK2 IF         COND(&PFG *EQ '1') THEN(DO) */
    /* TCHK2 CALL       PGM(ABACP6) PARM('5671')    */
    /* TCHK2 ENDDO                                  */

             IF         COND(&PTN *EQ '1') THEN(DO)
             CALL       PGM(ABACP6) PARM('5672')
             ENDDO
             ENDDO

/* ABI (ADVICS) ***************************************************/
             IF         COND(&PSIRE *EQ '0465') THEN(DO)
             CHGVAR     VAR(&SR) VALUE('AB')
             CHKOBJ     OBJ(ABI)  OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@SKP1))

             CLRPFM     FILE(AB#WABI)
             OVRDBF     FILE(AB#WABI) TOFILE(&WLIB/AB#WABI)
             OVRDBF     FILE(ABI)     TOFILE(&WLIB/ABI)
             CALL       PGM(A#R0465O) PARM(&PID)

             OVRDBF     FILE(ABAWABF) TOFILE(&WLIB/ABAWABF)
             CLRPFM     FILE(ABAWABF)
             CALL       PGM(A#R0465F) PARM(&ID)

             CPYF       FROMFILE(*LIBL/ABI) TOFILE(*LIBL/ABISV) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2802)

             DLTF       FILE(ABI)

             IF         COND(&ID *NE ' ') THEN(DO)
 /*JW*/                 OVRPRTF    FILE(QPRINT2) LPI(6) +
                                     RPLUNPRT(*YES) OUTQ(EPRINT1 ) +
                                     FORMTYPE(K6H1) HOLD(*YES)
                        CALL       PGM(ABAR1X)
                        DLTOVR     FILE(QPRINT2)
                        CALL       PGM(ABACP6) PARM(&PSIRE)

             ENDDO

             IF         COND(&PID *EQ ' ') THEN(DO)
                        GOTO       CMDLBL(@END)
             ENDDO
             ENDDO

/* ASJ ************************************************************/
             IF         COND(&PSIRE *EQ '8990') THEN(DO)
             CHGVAR     VAR(&SR) VALUE('AJ')
             CHGVAR     VAR(&PSIRE) VALUE('8990')
             CHKOBJ     OBJ(ASJ)  OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@SKP1))

             CLRPFM     FILE(AB#WASJ)
             OVRDBF     FILE(AB#WASJ) TOFILE(&WLIB/AB#WASJ)
             OVRDBF     FILE(ASJ) TOFILE(&WLIB/ASJ)
             CALL       PGM(AB#R4G) PARM(&PID '1')

             CPYF       FROMFILE(*LIBL/ASJ) TOFILE(*LIBL/ASJSV) +
                          MBROPT(*ADD) CRTFILE(*YES) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2802)

             DLTF       FILE(ASJ)
             IF         COND(&PID *EQ ' ') THEN(DO)
             GOTO       CMDLBL(@END)
             ENDDO
             ENDDO

/* RITATSU ********************************************************/
             IF         COND(&PSIRE *EQ '1301') THEN(DO)
             CHGVAR     VAR(&SR) VALUE('RT')
             CHKOBJ     OBJ(RITATSUF@4)  OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@SKP1))

             CLRPFM     FILE(AB#WRTS)
             OVRDBF     FILE(AB#WRTS) TOFILE(&WLIB/AB#WRTS)
             OVRDBF     FILE(RITATSUF) TOFILE(HWFILE1/RITATSUF@4)

             CALL       PGM(A#R4R) PARM(&PID '1')


     /*      OVRDBF     FILE(ABAWRIF) TOFILE(&WLIB/ABAWRIF)           */
     /*      CLRPFM     FILE(ABAWRIF)                                 */
     /*                                                               */
     /*      CALL       PGM(A#R5D) PARM(&ID)                          */
     /*                                                               */
     /*      CPYF       FROMFILE(*LIBL/RITATSUF) +                    */
     /*                   TOFILE(*LIBL/RITATSUFSV) MBROPT(*ADD) +     */
     /*                   FMTOPT(*NOCHK)                              */
     /*      MONMSG     MSGID(CPF2802)                                */
     /*                                                               */
     /*      DLTF       FILE(RITATSUF)                                */
     /*                                                               */
     /*      IF         COND(&ID *NE ' ') THEN(DO)                    */
     /*                 OVRPRTF    FILE(QPRINT2) LPI(6) +             */
     /*                              RPLUNPRT(*YES) OUTQ(FORECAST) +  */
     /*                              FORMTYPE(K6H1) HOLD(*YES)        */
     /*                 OVRPRTF    FILE(QPRINT2) LPI(6) +             */
     /*                              RPLUNPRT(*YES) OUTQ(FORECAST) +  */
     /*                              FORMTYPE(K6H1) HOLD(*YES)        */
     /*                 CALL       PGM(ABAR1U)                        */
     /*                 DLTOVR     FILE(QPRINT2)                      */
     /*                 CALL       PGM(ABACP6) PARM(&PSIRE)           */
     /*      ENDDO                                                    */

             IF         COND(&PID *EQ ' ') THEN(DO)
                        GOTO       CMDLBL(@END)
             ENDDO
             ENDDO

/* NIFAST MICHIGAN ************************************************/
             IF         COND(&PSIRE *EQ '0203') THEN(DO)
             CHGVAR     VAR(&SR) VALUE('NI')
             CHKOBJ     OBJ(NIFAST)  OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@SKP1))

             CLRPFM     FILE(AB#WNIF)
             OVRDBF     FILE(AB#WNIF) TOFILE(&WLIB/AB#WNIF)
             OVRDBF     FILE(NIFAST)  TOFILE(&WLIB/NIFAST)
             CALL       PGM(A#R4H)  PARM(&PID)

             OVRDBF     FILE(ABAWNMF) TOFILE(&WLIB/ABAWNMF)
             CLRPFM     FILE(ABAWNMF)

/* TCHK8 */  CALL       PGM(A#R0203F) PARM(&ID)

             CPYF       FROMFILE(*LIBL/NIFAST) +
                          TOFILE(*LIBL/NIFASTSV) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2802)

             DLTF       FILE(NIFAST)

             IF         COND(&ID *NE ' ') THEN(DO)
                        OVRPRTF    FILE(QPRINT2) LPI(6) +
                                     RPLUNPRT(*YES) OUTQ(FORECAST) +
                                     FORMTYPE(K6H1) HOLD(*YES)
                        CALL       PGM(A#R0203G)
                        DLTOVR     FILE(QPRINT2)
                        CALL       PGM(ABACP6) PARM(&PSIRE)
             ENDDO

             IF         COND(&PID *EQ ' ') THEN(DO)
                        GOTO       CMDLBL(@END)
             ENDDO
             ENDDO

/* NIFAST CANADA **************************************************/
             IF         COND(&PSIRE *EQ '1431') THEN(DO)
             CHGVAR     VAR(&SR) VALUE('NC')
             CHKOBJ     OBJ(NIFASTCA) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@SKP1))

             CLRPFM     FILE(AB#WNIC)
             OVRDBF     FILE(AB#WNIC) TOFILE(&WLIB/AB#WNIC)
             OVRDBF     FILE(NIFASTCA) TOFILE(&WLIB/NIFASTCA)
             CALL       PGM(A#R1431O) PARM(&PID)

             CALL       PGM(A#R1431F) PARM(&ID)

             CPYF       FROMFILE(*LIBL/NIFASTCA) +
                          TOFILE(*LIBL/NIFASTCASV) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2802)

             DLTF       FILE(NIFASTCA)

             IF         COND(&ID *NE ' ') THEN(DO)
                        RTVDTAARA  DTAARA(ABADS1) RTNVAR(&ABADS1)
                        CHGVAR     VAR(&PYM) VALUE(%SST(&ABADS1 1 6))
                        CALL       PGM(ABBC61) PARM(&PYM)
             ENDDO

             IF         COND(&PID *EQ ' ') THEN(DO)
                        GOTO       CMDLBL(@END)
             ENDDO
             ENDDO

/* OTICS **********************************************************/
             IF         COND(&PSIRE *EQ '0740') THEN(DO)
             CHGVAR     VAR(&SR) VALUE('OT')
             CHKOBJ     OBJ(OTICS) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@SKP1))

             OVRDBF     FILE(AB#WOTI) TOFILE(&WLIB/AB#WOTI)
             CLRPFM     FILE(AB#WOTI)
             OVRDBF     FILE(OTICS)   TOFILE(&WLIB/OTICS)
             CALL       PGM(AB#R4I) PARM(&PID)

             OVRDBF     FILE(ABAWOTF) TOFILE(&WLIB/ABAWOTF)
             CLRPFM     FILE(ABAWOTF)
             CALL       PGM(AB#R5I) PARM(&ID)

             CPYF       FROMFILE(*LIBL/OTICS) +
                          TOFILE(*LIBL/OTICSSV) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2802)

             DLTF       FILE(OTICS)

             IF         COND(&ID *NE ' ') THEN(DO)
                        OVRPRTF    FILE(QPRINT2) LPI(6) +
                                     RPLUNPRT(*YES) OUTQ(FORECAST) +
                                     FORMTYPE(K6H1) HOLD(*YES)
                        CALL       PGM(ABAR1Y)
                        DLTOVR     FILE(QPRINT2)
                        CALL       PGM(ABACP6) PARM(&PSIRE)
             ENDDO

             IF         COND(&PID *EQ ' ') THEN(DO)
                        GOTO       CMDLBL(@END)
             ENDDO
             ENDDO

/* FUTABA TEXAS ***************************************************/
             IF         COND(&PSIRE *EQ '0578') THEN(DO)
             CHGVAR     VAR(&SR) VALUE('FT')
             CHKOBJ     OBJ(FUTABTXO) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@SKP1))

             OVRDBF     FILE(AB#WFTX) TOFILE(&WLIB/AB#WFTX)
             CLRPFM     FILE(AB#WFTX)
             OVRDBF     FILE(FUTABTXO)   TOFILE(&WLIB/FUTABTXO)
             CALL       PGM(A#R0578O) PARM(&PID)
             CALL       PGM(A#R0578U)

             CPYF       FROMFILE(*LIBL/FUTABTXO) +
                          TOFILE(*LIBL/FUTABTXOSV) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2802)

             DLTF       FILE(FUTABTXO)

             IF         COND(&PID *EQ ' ') THEN(DO)
                        GOTO       CMDLBL(@END)
             ENDDO
             ENDDO

/* FUTABA INDIANA *************************************************/
             IF         COND(&PSIRE *EQ '0567') THEN(DO)
             CHGVAR     VAR(&SR) VALUE('FI')
             CHKOBJ     OBJ(FUTABINO) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@SKP1))

             OVRDBF     FILE(AB#WFIN) TOFILE(&WLIB/AB#WFIN)
             CLRPFM     FILE(AB#WFIN)
             OVRDBF     FILE(FUTABINO)   TOFILE(&WLIB/FUTABINO)
             CALL       PGM(A#R0567O) PARM(&PID)
             CALL       PGM(A#R0567U)

             CPYF       FROMFILE(*LIBL/FUTABINO) +
                          TOFILE(*LIBL/FUTABINOSV) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2802)

             DLTF       FILE(FUTABINO)

             IF         COND(&PID *EQ ' ') THEN(DO)
                        GOTO       CMDLBL(@END)
             ENDDO
             ENDDO

/* FUTABA CANADA **************************************************/
             IF         COND(&PSIRE *EQ '0579') THEN(DO)
             CHGVAR     VAR(&SR) VALUE('FC')
             CHKOBJ     OBJ(FUTABCNO) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@SKP1))

             OVRDBF     FILE(AB#WFCN) TOFILE(&WLIB/AB#WFCN)
             CLRPFM     FILE(AB#WFCN)
             OVRDBF     FILE(FUTABCNO)   TOFILE(&WLIB/FUTABCNO)
             CALL       PGM(A#R0579O) PARM(&PID)
/*JW3*/      CALL       PGM(A#R0579U)

             CPYF       FROMFILE(*LIBL/FUTABCNO) +
                          TOFILE(*LIBL/FUTABCNOSV) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2802)

             DLTF       FILE(*LIBL/FUTABCNO)

             IF         COND(&PID *EQ ' ') THEN(DO)
                        GOTO       CMDLBL(@END)
             ENDDO
             ENDDO

/* FUTABA CHICAGO *************************************************/
             IF         COND(&PSIRE *EQ '0556') THEN(DO)
             CHGVAR     VAR(&SR) VALUE('FH')
             CHKOBJ     OBJ(FUTABCHO) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@SKP1))

             OVRDBF     FILE(AB#WFCH) TOFILE(&WLIB/AB#WFCH)
             CLRPFM     FILE(AB#WFCH)
             OVRDBF     FILE(FUTABCHO)   TOFILE(&WLIB/FUTABCHO)
             CALL       PGM(A#R0556O) PARM(&PID)
/*JW3*/      CALL       PGM(A#R0556U)

             CPYF       FROMFILE(*LIBL/FUTABCHO) +
                          TOFILE(*LIBL/FUTABCHOSV) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2802)

             DLTF       FILE(FUTABCHO)

             IF         COND(&PID *EQ ' ') THEN(DO)
                        GOTO       CMDLBL(@END)
             ENDDO
             ENDDO

/* JTEKT TEXAS ****************************************************/
             IF         COND(&PSIRE *EQ '3832') THEN(DO)
             CHGVAR     VAR(&SR) VALUE('JT')
             CHKOBJ     OBJ(JTEKTTXO) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@SKP1))

             OVRDBF     FILE(AB#WJTX) TOFILE(&WLIB/AB#WJTX)
             CLRPFM     FILE(AB#WJTX)
             OVRDBF     FILE(JTEKTTXO)   TOFILE(&WLIB/JTEKTTXO)
             CALL       PGM(A#R3832O) PARM(&PID)

             CPYF       FROMFILE(*LIBL/JTEKTTXO) +
                          TOFILE(*LIBL/JTEKTTXOSV) MBROPT(*ADD) +
                          CRTFILE(*YES) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2802)

             DLTF       FILE(JTEKTTXO)

             IF         COND(&PID *EQ ' ') THEN(DO)
                        GOTO       CMDLBL(@END)
             ENDDO
             ENDDO

/* JTEKT VIRGINIA 1 ***********************************************/
             IF         COND(&PSIRE *EQ '3891') THEN(DO)
             CHGVAR     VAR(&SR) VALUE('JV')
             CHKOBJ     OBJ(JTEKTVAO) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@SKP1))

             OVRDBF     FILE(AB#WJVA) TOFILE(&WLIB/AB#WJVA)
             CLRPFM     FILE(AB#WJVA)
             OVRDBF     FILE(JTEKTVAO)   TOFILE(&WLIB/JTEKTVAO)
             CALL       PGM(A#R3891O) PARM(&PID)

             CPYF       FROMFILE(*LIBL/JTEKTVAO) +
                          TOFILE(*LIBL/JTEKTVAOSV) MBROPT(*ADD) +
                          CRTFILE(*YES) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2802)

             DLTF       FILE(JTEKTVAO)

             IF         COND(&PID *EQ ' ') THEN(DO)
                        GOTO       CMDLBL(@END)
             ENDDO
             ENDDO

/* OTHER(COMMON FORMAT) ********************************************/
             IF         COND(&PSIRE *EQ 'OTHC') THEN(DO)
             CHGVAR     VAR(&SR) VALUE('ZZ')
             CHKOBJ     OBJ(OTHCUST) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@SKP1))

    /* FIRM order upload */
             OVRDBF     FILE(AB#WOTH) TOFILE(&WLIB/AB#WOTH)
             CLRPFM     FILE(AB#WOTH)
             OVRDBF     FILE(OTHCUST) TOFILE(&WLIB/OTHCUST)
             CALL       PGM(A#ROTHO) PARM(&PID)

    /* FORECAST upload */
             OVRDBF     FILE(ABAWOTHF) TOFILE(&WLIB/ABAWOTHF)
             CLRPFM     FILE(ABAWOTHF)
             CALL       PGM(A#ROTHF) PARM(&ID)

             CPYF       FROMFILE(*LIBL/OTHCUST) +
                          TOFILE(*LIBL/OTHCUSTSV) MBROPT(*ADD) +
                          CRTFILE(*NO) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2802)

             DLTF       FILE(OTHCUST)

             IF         COND(&ID *NE ' ') THEN(DO)
                        OVRPRTF    FILE(QPRINT2) LPI(6) +
                                     RPLUNPRT(*YES) OUTQ(FORECAST) +
                                     FORMTYPE(K6H1) HOLD(*YES)
                        CALL       PGM(A#ROTHG) PARM(&SIREF)
                        DLTOVR     FILE(QPRINT2)
                        CALL       PGM(ABACP6) PARM(&SIREF)

             ENDDO

             IF         COND(&PID *EQ ' ') THEN(DO)
                        GOTO       CMDLBL(@END)
             ENDDO
             ENDDO


  /* JTEKT VIRGINIA 2 ***********************************************/
             IF         COND(&PSIRE *EQ '3318') THEN(DO)
             CHGVAR     VAR(&SR) VALUE('TB')
             CHKOBJ     OBJ(TBCAO)    OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@SKP1))

             OVRDBF     FILE(AB#W3318) TOFILE(&WLIB/AB#W3318)
             CLRPFM     FILE(AB#W3318)
             OVRDBF     FILE(TBCAO)    TOFILE(&WLIB/TBCAO)
             CALL       PGM(A#R3318O) PARM(&PID)

             CPYF       FROMFILE(*LIBL/TBCAO) TOFILE(*LIBL/TBCAOSV) +
                          MBROPT(*ADD) CRTFILE(*YES) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2802)

             DLTF       FILE(TBCAO)

             IF         COND(&PID *EQ ' ') THEN(DO)
                        GOTO       CMDLBL(@END)
             ENDDO
             ENDDO

/* TIEM ***********************************************************/
             IF         COND(&PSIRE *EQ '0753') THEN(DO)
             CHGVAR     VAR(&SR) VALUE('TI')
             CHKOBJ     OBJ(TIEMO) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@SKP1))

             OVRDBF     FILE(AB#WTIE) TOFILE(&WLIB/AB#WTIE)
             CLRPFM     FILE(AB#WTIE)
             OVRDBF     FILE(TIEMO)   TOFILE(&WLIB/TIEMO)
             CALL       PGM(A#R0753O) PARM(&PID)

             CPYF       FROMFILE(*LIBL/TIEMO) TOFILE(*LIBL/TIEMOSV) +
                          MBROPT(*ADD) CRTFILE(*NO) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2802)

             DLTF       FILE(TIEMO)

             IF         COND(&PID *EQ ' ') THEN(DO)
                        GOTO       CMDLBL(@END)
             ENDDO
             ENDDO

/* ACZ ************************************************************/
             IF         COND(&PSIRE *EQ '0170') THEN(DO)
             CHGVAR     VAR(&SR) VALUE('AC')
             CHKOBJ     OBJ(ACZ)  OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@SKP1))

             OVRDBF     FILE(AB#WACZ) TOFILE(&WLIB/AB#WACZ)
             CLRPFM     FILE(AB#WACZ)
             OVRDBF     FILE(ACZ) TOFILE(&WLIB/ACZ)
             CALL       PGM(A#R0170O) PARM(&PID)

             CPYF       FROMFILE(*LIBL/ACZ) TOFILE(*LIBL/ACZSV) +
                          MBROPT(*ADD) CRTFILE(*YES) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2802)

             DLTF       FILE(ACZ)
             IF         COND(&PID *EQ ' ') THEN(DO)
             GOTO       CMDLBL(@END)
             ENDDO
             ENDDO

/* ARJ ************************************************************/
             IF         COND(&PSIRE *EQ '3201') THEN(DO)
             CHGVAR     VAR(&SR) VALUE('AR')
             CHKOBJ     OBJ(ARJ)  OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@SKP1))

             OVRDBF     FILE(ARJ)     TOFILE(&WLIB/ARJ)
             OVRDBF     FILE(AB#WARJ) TOFILE(&WLIB/AB#WARJ)
             CLRPFM     FILE(AB#WARJ)
             CALL       PGM(A#R3201O) PARM(&PID)

             OVRDBF     FILE(ABAWARF) TOFILE(&WLIB/ABAWARF)
             CLRPFM     FILE(ABAWARF)
             CALL       PGM(A#R3201F) PARM(&ID)

             CPYF       FROMFILE(*LIBL/ARJ) TOFILE(*LIBL/ARJSV) +
                          MBROPT(*ADD) CRTFILE(*NO) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2802)

             DLTF       FILE(ARJ)

             IF         COND(&ID *NE ' ') THEN(DO)
                        OVRPRTF    FILE(QPRINT2) LPI(6) +
                                     RPLUNPRT(*YES) OUTQ(FORECAST) +
                                     FORMTYPE(K6H1) HOLD(*YES)
                        CALL       PGM(A#R3201G)
                        DLTOVR     FILE(QPRINT2)
                        CALL       PGM(ABACP6) PARM(&PSIRE)

             ENDDO

             IF         COND(&PID *EQ ' ') THEN(DO)
                        GOTO       CMDLBL(@END)
             ENDDO
             ENDDO

/* ADI (AISIN) ****************************************************/
             IF         COND(&PSIRE *EQ '0777') THEN(DO)
             CHGVAR     VAR(&SR) VALUE('AX')
             CHKOBJ     OBJ(AISINX) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@SKP1))

             CLRPFM     FILE(AB#WAI4)
             CALL       PGM(A#R0777O) PARM(&PID)
      /*JW   CALL       PGM(A#R0777U)  */

             OVRDBF     FILE(AB#WAIX) TOFILE(&WLIB/AB#WAIX)
             CLRPFM     FILE(AB#WAIX)
             CALL       PGM(A#R0777F) PARM(&ID)

             IF         COND(&ID *NE ' ') THEN(DO)
                        OVRPRTF    FILE(QPRINT2) LPI(6) +
                                     RPLUNPRT(*YES) OUTQ(FORECAST) +
                                     FORMTYPE(K6H1) HOLD(*YES)
                        CALL       PGM(A#R0777G)
                        DLTOVR     FILE(QPRINT2)
                        CALL       PGM(ABACP6) PARM(&PSIRE)
             ENDDO

             CPYF       FROMFILE(*LIBL/AISINX) +
                          TOFILE(*LIBL/AISINXSV) MBROPT(*ADD) +
                          CRTFILE(*NO) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2802)

             DLTF       FILE(AISINX)
             IF         COND(&PID *EQ ' ') THEN(DO)
             GOTO       CMDLBL(@END)
             ENDDO
             ENDDO

/* DISPLAY ORDER DATA ON AS400 SCREEN ============================*/
  @SKP1:
             CHGVAR     VAR(&FILE1) VALUE(AB#WP201 *CAT &SR)
             CHGVAR     VAR(&FILE2) VALUE(AB#WP202 *CAT &SR)
             CHGVAR     VAR(&FILE3) VALUE(AB#WP20 *CAT &SR)
             CHGVAR     VAR(&FILE4) VALUE('MITANKF' *CAT &SR)
             CHGVAR     VAR(&FILE5) VALUE(AB#WP451 *CAT &SR)
             CHGVAR     VAR(&FILE6) VALUE(AB#WP452 *CAT &SR)

             DLTF       FILE(&FILE5)
             MONMSG     MSGID(CPF3261 CPF2105)
             MONMSG     MSGID(CPF5020) EXEC(GOTO CMDLBL(@END))
             CRTPF      FILE(&WLIB/&FILE5) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AB#WP451) TOFILE(&FILE5)
             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(EPRINT1) FORMTYPE(K6H1) HOLD(*YES)
             OVRDBF     FILE(AGDPL12) TOFILE(*LIBL/A@DPL12)

             CALL       PGM(AB#R2F) PARM(&PSIRE)
             DLTOVR     FILE(QPRINT)

             IF         COND(%SWITCH(0XXXXXXX)) THEN(GOTO CMDLBL(@END))

/* TCHK5 */  IF         COND(&PSIRE *EQ '0170') THEN(DO)
             CALL       PGM(GTAR10)
             ENDDO

             DLTF       FILE(&FILE6)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE6) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/&FILE5)) OUTFILE(&WLIB/&FILE6) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S45) +
                          OPTION(*NOPRT)
             DLTF       FILE(&FILE5)
             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE1) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AB#WP452) TOFILE(&FILE6)
             OVRDBF     FILE(AB#WP201) TOFILE(&FILE1)
/*JW*/       OVRPRTF    FILE(QPRINT) OUTQ(EPRINT1 ) HOLD(*YES)
             CALL       PGM(AB#R451)
             DLTOVR     FILE(QPRINT)

/*JW*/       OVRPRTF    FILE(QPRINT)  OUTQ(EPRINT1) HOLD(*YES)
/*JW*/       OVRPRTF    FILE(QPRINT2) OUTQ(EPRINT1) HOLD(*YES)
/*JW*/       OVRPRTF    FILE(QPRINT5) OUTQ(EPRINT1) HOLD(*YES)
/*JW*/       OVRPRTF    FILE(QPRINT6) OUTQ(EPRINT1) HOLD(*YES)

/* &USER2 = &USER + ID(=S) - ORDER ENTRY ID=SHEET   JW */
             CHGVAR     VAR(&USER2) VALUE(&USER)
             CHGVAR     VAR(%SST(&USER2 10 1)) VALUE('S')

             CALL       PGM(AB#R45) PARM(&USER2)

             IF         (%SWITCH(X0XXXXXX)) DO
             SNDPGMMSG  MSG('( G ) THE ORDER HAS BEEN +
                          PROCESSED  < G-ENTER >') TOMSGQ(&WSID) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE = 'G') *OR (&KOTAE = 'g')) +
                          THEN(GOTO CMDLBL(@END))
             CHGVAR     VAR(&KOTAE) VALUE('G')
             GOTO      @END
             ENDDO

             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE2) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/&FILE1)) OUTFILE(&WLIB/&FILE2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S24) +
                          OPTION(*NOPRT)
             DLTF       FILE(&FILE1)

             DLTF       FILE(&FILE3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE3) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AB#WP20) OPTION(*NOLIST *NOSRC) +
                          LVLCHK(*NO) AUT(*ALL)

/*JW*/       OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(EPRINT1) FORMTYPE(K6H1)
/*JW*/       OVRPRTF    FILE(QPRINT2) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(EPRINT1) FORMTYPE(K6H1)

             OVRDBF     FILE(AB#WP202) TOFILE(&FILE2)
             OVRDBF     FILE(AB#WP20) TOFILE(&FILE3)
             CALL       PGM(AB#R21) PARM(&PSIRE)

             OVRDBF     FILE(AB#WP20) TOFILE(&FILE3)
             CALL       PGM(AB#R22)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1)
             OVRPRTF    FILE(QPRINT2) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1)

             OVRDBF     FILE(AB#WP20) TOFILE(&FILE3)

             DLTF       FILE(&FILE4)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE4) RCDLEN(300) +
                          OPTION(*NOLIST *NOSRC) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AB#WP20) TOFILE(&FILE3)
             OVRDBF     FILE(MITANKF) TOFILE(&FILE4)
             CALL       PGM(AB#R25) PARM(&PFLG)

             IF         (&PFLG *EQ '*') DO

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1)

             OVRDBF     FILE(MITANKF) TOFILE(&FILE4)
             CALL       PGM(AB#R26) PARM(&PSIRE)

             SNDPGMMSG  MSG('UNIT PRICES ARE NOT REGISTERED IN THE +
                          SALES UNIT PRICE MASTER FILES. UNIT PRICE +
                          MUST BE REGISTERED.') TOMSGQ(&WSID)
             ENDDO

  @END:
             DLTOVR     FILE(*ALL)
             ENDPGM
