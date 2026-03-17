 PGM
/** ALHC90 ***************************************************/
/*  LOQ INPROCESS SCAN  *TEMP                                */
/*                                                           */
/*************************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&ALHWP90) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FNAM) TYPE(*CHAR) LEN(30) +
                          VALUE('LOQ_INPROCESS_DATA')

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&ALHWP90) VALUE('ALHWP90')

             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)
 STP10:
             DLTF       FILE(&WLIB/&ALHWP90)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ALHWP90) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(300000 1000 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(ALHWP90) TOFILE(&WLIB/&ALHWP90)
             CALL       PGM(ALHR90)

 ENDPGM
