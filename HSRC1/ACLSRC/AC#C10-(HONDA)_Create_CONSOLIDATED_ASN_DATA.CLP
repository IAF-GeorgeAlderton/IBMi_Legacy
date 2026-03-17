             PGM
 /** AB#C1N ****************************************************/
 /*  CREATE CONSOLIDATED ASN (HONDA)                           */
 /*                                                            */
 /*  JW   2017.01.31                                           */
 /**************************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLAG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PERR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCLF       FILE(AB#PW0G)
             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

 /* TEMP     ALCOBJ     OBJ((AB#EP59 *FILE *EXCLRD)) WAIT(3)           */
 /*          MONMSG     MSGID(CPF0000) EXEC(DO)                        */
 /*          CALL       PGM(QUILNGTX) PARM('GENTRAN IS WORKING NOW. +  */
 /*                       PLEASE TRY IT AGAIN IN ONE MINUTE. THANK +   */
 /*                       YOU. ' X'00000046' '       ' +               */
 /*                       '                    ' X'00000000')          */
 /*          GOTO END                                                  */
 /*          ENDDO                                                     */

  STP0:
             CRTDUPOBJ  OBJ(MITANKF) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/MITANKF

             CRTDUPOBJ  OBJ(AB#WP34) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/AB#WP34

             OVRDBF     FILE(MITANKF) TOFILE(QTEMP/MITANKF)
             OVRDBF     FILE(AB#WP34) TOFILE(QTEMP/AB#WP34)

             CHGVAR     VAR(&FLAG) VALUE(' ')
             CALL       PGM(AC#R10) PARM(&FLAG  &PERR)

             IF         COND(&FLAG *EQ '9') THEN(GOTO CMDLBL(END))

 END:
    /* TEMP  DLCOBJ     OBJ((AB#EP59 *FILE *EXCLRD))        */
    /*       MONMSG     MSGID(CPF0000)                      */

             IF         COND(&FLAG *EQ ' ') THEN(DO)
             SNDRCVF    RCDFMT(W01)
             ENDDO

             IF         (%SWITCH(1XXXXXXX)) DO
             OVRDBF     FILE(AB#WP34) TOFILE(QTEMP/AB#WP34)
             CALL       PGM(AB#RE9)
             DLTOVR     FILE(*ALL)
             ENDDO

        /* JW1 2016.03.22 ADDED: SAVE AB#EP59/67/68/69    */
             CALL       PGM(EDSR6H)

             ENDPGM
