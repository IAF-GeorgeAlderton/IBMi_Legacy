  PGM
/** AB#C0K ****************************************************/
/*  ANDROID CREATE ASN DATA                                   */
/*                                                            */
/* TCHK1 08/01/06 CREATE(COPY FROM AB#C0K)                    */
/**************************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCLF       FILE(AB#PW0G)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             ALCOBJ     OBJ((AB#EP66 *FILE *EXCLRD)) WAIT(3)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CALL       PGM(QUILNGTX) PARM('GENTRAN IS WORKING NOW. +
                          PLEASE TRY IT AGAIN IN ONE MINUTE. THANK +
                          YOU. ' X'00000046' '       ' +
                          '                    ' X'00000000')

             GOTO END
             ENDDO


             CRTDUPOBJ  OBJ(MITANKF) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     QTEMP/MITANKF

             CRTDUPOBJ  OBJ(AB#WP34) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     QTEMP/AB#WP34

             OVRDBF     FILE(MITANKF) TOFILE(QTEMP/MITANKF)
             OVRDBF     FILE(AB#WP34) TOFILE(QTEMP/AB#WP34)

             CALL       PGM(AN#R0K)

 END:
             DLCOBJ     OBJ((AB#EP66 *FILE *EXCLRD))
             MONMSG     MSGID(CPF0000)
             RCLRSC

 /* UNIT PRICE ERROR */
             IF         (%SWITCH(X1XXXXXX)) DO

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(LANPRT50) +
                          FORMTYPE(K6H1) IGCDTA(&PIGCD)

             CALL       PGM(AB#R0D)
             ENDDO

             IF         (%SWITCH(1XXXXXXX)) DO
             OVRDBF     FILE(AB#WP34) TOFILE(QTEMP/AB#WP34)

             CALL       PGM(AB#RE9)
             DLTOVR     FILE(*ALL)
             ENDDO

             IF         (%SWITCH(XX1XXXXX)) DO
             SNDRCVF    RCDFMT(W01)
             ENDDO

             ENDPGM
