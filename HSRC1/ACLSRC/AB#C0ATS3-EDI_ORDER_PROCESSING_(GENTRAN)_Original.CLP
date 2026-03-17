 PGM
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PFLG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PSIRE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&KEN)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PSPO) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ID)   TYPE(*CHAR) LEN(1)
/* TCHK7 */  DCL        VAR(&PRUN) TYPE(*CHAR) LEN(1)
/* JW2   */  DCL        VAR(&REC)  TYPE(*DEC)  LEN(10 0)
/* JW4   */  DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)

/* TCHK6 */  OVRDBF     FILE(AGDPP11) TOFILE(HFILE1/A@DPP11)
/* TCHK6 */  OVRDBF     FILE(AGDPL11) TOFILE(HFILE1/A@DPL11)
/* TCHK6 */  OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/A@DPL12)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGJOB     SWS(00000000)

             DLTF       FILE(QTEMP/AB#WP451)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP451) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(30000) LVLCHK(*NO) +
                          AUT(*ALL)

             DLTF       FILE(QTEMP/AB#WP452)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP452) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(30000) LVLCHK(*NO) +
                          AUT(*ALL)

             DLTF       FILE(QTEMP/AB#WP2A)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP2A) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(30000) LVLCHK(*NO) +
                          AUT(*ALL)

             DLTF       FILE(QTEMP/AB#EP4T)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AB#EP4T) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/AB#EP4T

   /*  CREATE TOYOTA EDI WORKFILE    */
             DLTF       FILE(QTEMP/AB#WP15)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTDUPOBJ  OBJ(AB#WP15) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(AB#WP15) TOFILE(QTEMP/AB#WP15)

        /* JW1 2016.02.18 ADDED: SAVE AB#EP40 TO AB#EP40S */
  /** TEST * CALL       PGM(EDSR40)   ********************/

             OVRDBF     FILE(AB#EP4T) TOFILE(QTEMP/AB#EP4T)

             OVRDBF     FILE(AB#WP451) TOFILE(QTEMP/AB#WP451)
             OVRDBF     FILE(AB#WP2A) TOFILE(QTEMP/AB#WP2A)
  /** TEST **/
             OVRDBF     FILE(AB#EP40) TOFILE(TFILE1/AB#EP40)

             CALL       PGM(AB#R0A)

             DLTOVR     FILE(*ALL)

             ENDPGM
