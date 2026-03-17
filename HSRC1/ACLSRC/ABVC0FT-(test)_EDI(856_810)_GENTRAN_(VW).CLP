             PGM
             /** ABVC0F ****************************************************/
             /*  EDI(856/810) GENTRAN                                      */
             /*                                                            */
             /* TCHK  04/28/14 CREATE(COPY FROM AB#C0F)                    */
             /* JW1   2016.04.18 ADDED: SAVE ABVEP52/53/54/55/56/57        */
             /* JW2   2018.11.21 ADDED: COPY ABVEP52 TO ABVEP51            */
             /* JW3   2020.07.23 ADDED: COPY ABVEP52 TO ABVEP51            */
             /**************************************************************/
             DCLF       FILE(AB#PW0G)

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
             DCL        VAR(&ENV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&REC)   TYPE(*DEC)  LEN(10 0)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CHGJOB     SWS(00000000)

             CALL       PGM(UTLR39) PARM(&ENV)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

       /**   ALCOBJ     OBJ((AB#EP60 *FILE *EXCLRD)) WAIT(1)           **/
       /**   MONMSG     MSGID(CPF0000) EXEC(DO)                        **/
       /**   CALL       PGM(QUILNGTX) PARM('GENTRAN IS WORKING NOW. +  **/
       /**                PLEASE TRY IT AGAIN IN ONE MINUTE. THANK +   **/
       /**                YOU. ' X'00000046' '       ' +               **/
       /**                '                    ' X'00000000')          **/
       /**   CHGVAR     VAR(&FLAG) VALUE('1')                          **/
       /**   GOTO END                                                  **/
       /**   ENDDO                                                     **/

   /* GM */
       /**   ALCOBJ     OBJ((AB#EP57 *FILE *EXCLRD)) WAIT(1)           **/
       /**   MONMSG     MSGID(CPF0000) EXEC(DO)                        **/
       /**   CALL       PGM(QUILNGTX) PARM('GENTRAN IS WORKING NOW. +  **/
       /**                PLEASE TRY IT AGAIN IN ONE MINUTE. THANK +   **/
       /**                YOU. ' X'00000046' '       ' +               **/
       /**                '                    ' X'00000000')          **/
       /**                                                             **/
       /**   CHGVAR     VAR(&FLAG) VALUE('1')                          **/
       /**   GOTO END                                                  **/
       /**   ENDDO                                                     **/

  /* CREATE WORK FILES  */
             DLTF       FILE(QTEMP/ABVWP0F)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ABVWP0F) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/ABVWP0F

             CRTDUPOBJ  OBJ(MITANKF) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/MITANKF
             CRTDUPOBJ  OBJ(AB#WP34) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/AB#WP34

             CRTDUPOBJ  OBJ(AB#WP33) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/AB#WP33

             DLTF       FILE(QTEMP/AB#WP0G)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(AB#WP0G) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/AB#WP0G

/* CLEAR ABVEP51 JW */
             RTVMBRD    FILE(TFILE1/ABVEP57) NBRCURRCD(&REC)
             IF         COND(&REC = 0) THEN(DO)
             CLRPFM     FILE(TFILE1/ABVEP51)
             ENDDO

             OVRDBF     FILE(MITANKF) TOFILE(QTEMP/MITANKF)
             OVRDBF     FILE(ABVWP0F) TOFILE(QTEMP/ABVWP0F)
             OVRDBF     FILE(AB#WP34) TOFILE(QTEMP/AB#WP34)
             OVRDBF     FILE(AB#WP0G) TOFILE(QTEMP/AB#WP0G)

             OVRDBF     FILE(ABVEP51)  TOFILE(TFILE1/ABVEP51)
             OVRDBF     FILE(ABVEP52)  TOFILE(TFILE1/ABVEP52)
             OVRDBF     FILE(ABVEP53)  TOFILE(TFILE1/ABVEP53)
             OVRDBF     FILE(ABVEP54)  TOFILE(TFILE1/ABVEP54)
             OVRDBF     FILE(ABVEP55)  TOFILE(TFILE1/ABVEP55)
             OVRDBF     FILE(ABVEP56)  TOFILE(TFILE1/ABVEP56)
             OVRDBF     FILE(ABVEP57)  TOFILE(TFILE1/ABVEP57)
             OVRDBF     FILE(ABVEL57B) TOFILE(TFILE1/ABVEL57B)
             OVRDBF     FILE(AB#EP6A)  TOFILE(TFILE1/AB#EP6A)

             CALL       PGM(ABVR0F) PARM(&FLAG  &PERR)

/**** TEMP ***********************************************************/
 GOTO SKP
/*********************************************************************/



             IF         COND(&FLAG *EQ '9') THEN(GOTO CMDLBL(END))

/* JW2 2018.11.21 ADDED: COPY ABVEP52 TO ABVEP51 */
             CPYF       FROMFILE(HFILE1/ABVEP52) +
                          TOFILE(HFILE1/ABVEP51) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF2869 CPF2817)

/* JW1 2016.04.18 ADDED: SAVE ABVEP52/53/54/55/56/57  */
             CALL       PGM(EDSR5V)

             OVRDBF     FILE(AB#WP34) TOFILE(QTEMP/AB#WP34)
             CALL       PGM(AB#RE9)

 /* UNIT PRICE ERROR */
             IF         (&PERR *EQ '*') DO

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(LANPRT50) +
                          FORMTYPE(K6H1) HOLD(*NO) IGCDTA(&PIGCD)

             CALL       PGM(AB#R0D)
             ENDDO

 END:
             DLCOBJ     OBJ((AB#EP60 *FILE *EXCLRD))
             MONMSG     MSGID(CPF0000)
             DLCOBJ     OBJ((AB#EP57 *FILE *EXCLRD))
             MONMSG     MSGID(CPF0000)

             IF         COND(&FLAG *NE ' ') THEN(GOTO CMDLBL(SKP))

             IF         COND(&FLAG *EQ ' ') THEN(DO)
             SNDRCVF    RCDFMT(W01)

             DLTOVR     FILE(AB#WP0G)
             CPYF       FROMFILE(QTEMP/AB#WP0G) +
                          TOFILE(&WLIB/AB#WP0G) MBROPT(*ADD)
             MONMSG     MSGID(CPF0000)
 /* SAVE AB#WP0G */
             CPYF       FROMFILE(QTEMP/AB#WP0G) +
                          TOFILE(&WLIB/AB#WP0H) MBROPT(*ADD)
             MONMSG     MSGID(CPF0000)

             ENDDO

             DLTOVR     FILE(*ALL)
             SBMJOB     CMD(CALL PGM(AB#CAR)) USER(EDIUSER)
  SKP:
             ENDPGM
