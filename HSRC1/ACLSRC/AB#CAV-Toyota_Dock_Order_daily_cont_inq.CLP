  PGM
/** AB#CAV ************************************************/
/* TOYOTA DOCK ORDER DAILY CONT INQ                       */
/*                                                        */
/* TCHK1 12/12/08 CREATE(COPY FROM ABAC44)                */
/**********************************************************/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             DCL        VAR(&AB#WPAV2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&REC     ) TYPE(*DEC ) LEN(10 0)
             DCL        VAR(&FNAM) TYPE(*CHAR) LEN(30) +
                          VALUE('TOYOTA_DAILY_CONT            ')

             RTVJOBA    JOB(&WSID) USER(&USER)
             /*--------------------------------------------*/
             /*    CHECK ENVIRONMENT                        */
             /*--------------------------------------------*/
               CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             CHGVAR     VAR(&AB#WPAV2) +
                         VALUE('AB#WPAV' *CAT %SST(&WSID 1 3))
             DLTF       FILE(&WLIB/&AB#WPAV2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AB#WPAV2) RCDLEN(256) +
                          OPTION(*NOLIST *NOSRC) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(QTEMP/AB#WPAV)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AB#WPAV) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/AB#WPAV)

             OVRDBF     FILE(AB#WPAV) TOFILE(QTEMP/AB#WPAV)
             OVRDBF     FILE(AB#WPAV2) TOFILE(&WLIB/&AB#WPAV2)
             CALL       PGM(AB#RAV)


             ENDPGM
