             PGM
             /** AB#C0K# ***************************************************/
             /*  TEST AB#R0K                                               */
             /**************************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIPGMN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POWSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POUSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POKONA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POSTTS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PMSG)  TYPE(*CHAR) LEN(256)
             DCL        VAR(&REC1)  TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&RTN1)  TYPE(*CHAR) LEN(1)

             DCLF       FILE(AB#PW0G)

/* JW2 CHECK OTHER USER IS USING  ==================================*/
/*TST        CALL CHKC45 ('AB#C0K' 'AB#C0K' 'Y'  'CHK' &RTN1)    TST*/
/*TST        IF         COND(&RTN1 *NE ' ') THEN(GOTO END3)      TST*/
/* =================================================================*/

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CRTDUPOBJ  OBJ(MITANKF) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/MITANKF)
             CRTDUPOBJ  OBJ(AB#WP34) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/AB#WP34)

             OVRDBF     FILE(MITANKF) TOFILE(QTEMP/MITANKF)
             OVRDBF     FILE(AB#WP34) TOFILE(QTEMP/AB#WP34)

/*TST***************/
             CLRPFM     FILE(TFILE1/AB#EP63)
             CLRPFM     FILE(TFILE1/AB#EP64)
             CLRPFM     FILE(TFILE1/AB#EP65)
             CLRPFM     FILE(TFILE1/AB#EP66)

             OVRDBF     FILE(AB#EP63) TOFILE(TFILE1/AB#EP63)
             OVRDBF     FILE(AB#EP64) TOFILE(TFILE1/AB#EP64)
             OVRDBF     FILE(AB#EP65) TOFILE(TFILE1/AB#EP65)
             OVRDBF     FILE(AB#EP66) TOFILE(TFILE1/AB#EP66)
/*TST***************/

 /* MAIN PROGRAM  -> AB#EP63,64,65,66 */
             CALL       PGM(AB#R0K#)

/***************************************/
  GOTO ENDP
/***************************************/

 ENDP:
             DLTOVR     FILE(*ALL)

             ENDPGM
