/** AB#C2F ************************************************/
/*  TAKUMI ORDER PROCESSING                               */
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

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&PRTG) VALUE('LANPRT50  ')
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGJOB     SWS(00000000)

/* FUTABA TEXAS */
             IF         COND(&PSIRE *EQ '0578') THEN(DO)
             CHGVAR     VAR(&SR) VALUE('FT')
             CHKOBJ     OBJ(FUTABTXO) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@SKP1))

    /* FUTABA TEXAS Order upload(format) */
             OVRDBF     FILE(AB#WFTX) TOFILE(&WLIB/AB#WFTX)
             CLRPFM     FILE(AB#WFTX)
             OVRDBF     FILE(FUTABTXO)   TOFILE(&WLIB/FUTABTXO)
             CALL       PGM(A#R0578O) PARM(&PID)

       /*    CPYF       FROMFILE(*LIBL/FUTABTXO) +                 */
       /*                 TOFILE(*LIBL/FUTABTXOSV) MBROPT(*ADD) +  */
       /*                 FMTOPT(*NOCHK)                           */
       /*    MONMSG     MSGID(CPF2802)                             */
       /*                                                          */
       /*    DLTF       FILE(FUTABTXO)                             */

             IF         COND(&PID *EQ ' ') THEN(DO)
                        GOTO       CMDLBL(@END)
             ENDDO

             ENDDO


/* FUTABA INDIANA */
             IF         COND(&PSIRE *EQ '0567') THEN(DO)
             CHGVAR     VAR(&SR) VALUE('FI')
             CHKOBJ     OBJ(FUTABINO) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@SKP1))

    /* FUTABA INDIANA Order upload(format) */
             OVRDBF     FILE(AB#WFIN) TOFILE(&WLIB/AB#WFIN)
             CLRPFM     FILE(AB#WFIN)
             OVRDBF     FILE(FUTABINO)   TOFILE(&WLIB/FUTABINO)
             CALL       PGM(A#R0567O) PARM(&PID)

         /*  CPYF       FROMFILE(*LIBL/FUTABINO) +                 */
         /*               TOFILE(*LIBL/FUTABINOSV) MBROPT(*ADD) +  */
         /*               FMTOPT(*NOCHK)                           */
         /*  MONMSG     MSGID(CPF2802)                             */
         /*                                                        */
         /*  DLTF       FILE(FUTABINO)                             */

             IF         COND(&PID *EQ ' ') THEN(DO)
                        GOTO       CMDLBL(@END)
             ENDDO

             ENDDO


/* FUTABA CANADA */
             IF         COND(&PSIRE *EQ '0579') THEN(DO)
             CHGVAR     VAR(&SR) VALUE('FC')
             CHKOBJ     OBJ(FUTABCNO) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@SKP1))

    /* FUTABA CANADA Order upload(format) */
             OVRDBF     FILE(AB#WFCN) TOFILE(&WLIB/AB#WFCN)
             CLRPFM     FILE(AB#WFCN)
             OVRDBF     FILE(FUTABCNO)   TOFILE(&WLIB/FUTABCNO)
             CALL       PGM(A#R0579O) PARM(&PID)
/*JW3*/      CALL       PGM(A#R0579U)

         /*  CPYF       FROMFILE(*LIBL/FUTABCNO) +                 */
         /*               TOFILE(*LIBL/FUTABCNOSV) MBROPT(*ADD) +  */
         /*               FMTOPT(*NOCHK)                           */
         /*  MONMSG     MSGID(CPF2802)                             */
         /*                                                        */
         /*  DLTF       FILE(*LIBL/FUTABCNO)                       */

             IF         COND(&PID *EQ ' ') THEN(DO)
                        GOTO       CMDLBL(@END)
             ENDDO

             ENDDO


/* FUTABA CHICAGO */
             IF         COND(&PSIRE *EQ '0556') THEN(DO)
             CHGVAR     VAR(&SR) VALUE('FH')
             CHKOBJ     OBJ(FUTABCHO) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@SKP1))

    /* FUTABA CANADA Order upload(format) */
             OVRDBF     FILE(AB#WFCH) TOFILE(&WLIB/AB#WFCH)
             CLRPFM     FILE(AB#WFCH)
             OVRDBF     FILE(FUTABCHO)   TOFILE(&WLIB/FUTABCHO)
             CALL       PGM(A#R0556O) PARM(&PID)
/*JW3*/      CALL       PGM(A#R0556U)

         /*  CPYF       FROMFILE(*LIBL/FUTABCHO) +                 */
         /*               TOFILE(*LIBL/FUTABCHOSV) MBROPT(*ADD) +  */
         /*               FMTOPT(*NOCHK)                           */
         /*  MONMSG     MSGID(CPF2802)                             */
         /*                                                        */
         /*  DLTF       FILE(FUTABCHO)                             */

             IF         COND(&PID *EQ ' ') THEN(DO)
                        GOTO       CMDLBL(@END)
             ENDDO

             ENDDO

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
                          OUTQ(EPRINT1) FORMTYPE(K6H1) HOLD(*YES) +
                          /*JW*/

             OVRDBF     FILE(AGDPL12) TOFILE(*LIBL/A@DPL12)

             CALL       PGM(AB#R2F) PARM(&PSIRE)
             DLTOVR     FILE(QPRINT)

  @END:
             DLTOVR     FILE(*ALL)
             ENDPGM
