  PGM
/** AB#C90 ************************************************/
/* APICS EQ-ER-ES-ET ISSUED INQUIRY                       */
/*                                                        */
/* TCHK  04/14/11 CREATE                                  */
/**********************************************************/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PCBL)  TYPE(*CHAR) LEN(1)

             DCL        VAR(&WS)     TYPE(*CHAR) LEN(2)
             DCL        VAR(&FILE)  TYPE(*CHAR)  LEN(8)

             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&FILE)  VALUE('TSLOCF' *CAT &WS)

             DLTF       FILE(&FILE)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(QTEMP/AH#WP90)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AH#WP90) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/AH#WP90)

             OVRDBF     FILE(TSLOCF)  TOFILE(HWFILE1/&FILE)
             OVRDBF     FILE(AH#WP90) TOFILE(QTEMP/AH#WP90)

             CALL       PGM(AH#R90)

             DLTOVR     FILE(*ALL)

             ENDPGM
