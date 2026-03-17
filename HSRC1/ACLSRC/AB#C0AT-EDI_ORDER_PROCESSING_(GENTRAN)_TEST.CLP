 PGM
/** AB#C0A ************************************************/
/*    EDI ORDER PROCESSING (GENTRAN)                      */
/**********************************************************/
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
/* JE2   */  DCL        VAR(&REC)  TYPE(*DEC)  LEN(10 0)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGJOB     SWS(00000000)

             DLTF       FILE(QTEMP/AB#WP451)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP451) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(QTEMP/AB#WP452)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP452) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(QTEMP/AB#WP2A)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP2A) RCDLEN(100) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(QTEMP/AB#EP4T)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AB#EP4T) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/AB#EP4T

             OVRDBF     FILE(AB#EP4T) TOFILE(QTEMP/AB#EP4T)

             OVRDBF     FILE(AB#WP451) TOFILE(QTEMP/AB#WP451)
             OVRDBF     FILE(AB#WP2A) TOFILE(QTEMP/AB#WP2A)

             OVRDBF     FILE(AB#EP40 ) TOFILE(TFILE1/AB#EP40 )

             CALL       PGM(HOBJ1/AB#R0A)

             ENDPGM
