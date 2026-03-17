             PGM
             /** AB#C6A ************************/
             /*  ..TMMNA ACCOUNT PAYBALE LIST  */
             /*    N-HYOTO 2000.11.20          */
             /************************ AB#C6A **/
             DCLF       FILE(AB#PW6A)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PNONY) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USR)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CALL       PGM(ALBC00) PARM(&USR &WLIB)
 @STRT:
             SNDRCVF    RCDFMT(DSP01)

             CHGVAR     VAR(&IN61) VALUE('0')

             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@END))
             IF         COND(&IN05 *EQ '0') THEN(GOTO CMDLBL(@STRT))
             IF         COND(&SLCT *LT '1' *OR &SLCT *GT '3') +
                          THEN(GOTO CMDLBL(@STRT))

             IF         COND(&CUST *LT '1' *OR &CUST *GT '3') THEN(DO)
             CHGVAR     VAR(&IN61) VALUE('1')
             GOTO       CMDLBL(@STRT)
             ENDDO

             CRTDUPOBJ  OBJ(AB#PP6A) FROMLIB(HFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP) NEWOBJ(AB#PP6A)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(AB#PL6A) FROMLIB(HFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP) NEWOBJ(AB#PL6A)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/AB#PP6A)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(AB#PP6A) TOFILE(QTEMP/AB#PP6A)
             OVRDBF     FILE(AB#PL6A) TOFILE(QTEMP/AB#PL6A)

             IF         COND(&CUST *EQ '1') THEN(CALL PGM(AB#R6A))
             IF         COND(&CUST *EQ '2') THEN(CALL PGM(AB#R6E))
             IF         COND(&CUST *EQ '3') THEN(CALL PGM(AB#R6F))

 /* LIST */
             IF         COND(&SLCT *NE '2') THEN(DO)

             OVRPRTF    FILE(QPRINT) PAGESIZE(66) OVRFLW(65) +
                          OUTQ(QPRINT)
             CALL       PGM(AB#R6B)
             ENDDO
  /* DATA */
             IF         COND(&SLCT *NE '1') THEN(DO)
             CLRPFM     FILE(AB#PP6B)
             CLRPFM     FILE(AB#PP6C)
             CALL       PGM(AB#R6D)
             ENDDO

             DLTOVR     FILE(*ALL)

 @END:       ENDPGM
