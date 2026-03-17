             PGM

             DCL        VAR(&SYSN)     TYPE(*CHAR) LEN(8)
             DCL        VAR(&RCVF)     TYPE(*CHAR) LEN(52)
             DCL        VAR(&WSID)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS03)     TYPE(*CHAR) LEN(3)
             DCL        VAR(&WFLB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&RINWP02)  TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID)
             CHGVAR     VAR(&WS03) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&WFLB) VALUE('HWFILE1')


 STEP01:     /*===< DSPOBJD >===*/
             DLTF       FILE(QTEMP/@DSPOBJD)
             MONMSG     MSGID(CPF3261 CPF2105)
             DSPOBJD    OBJ(HOBJ1/*ALL) OBJTYPE(*PGM) +
                        DETAIL(*FULL) OUTPUT(*OUTFILE) +
                        OUTFILE(QTEMP/@DSPOBJD)


 STEP02:     /*===< DSPOBJD --> RINPP01 >===*/
             DLTF       FILE(QTEMP/RINPP01)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTDUPOBJ  OBJ(RINPP01) FROMLIB(HFILE1) OBJTYPE(*FILE) +
                        TOLIB(QTEMP)

             OVRDBF     FILE(RINPP01) TOFILE(QTEMP/RINPP01)
             CALL       PGM(RINR01)
             DLTOVR     FILE(RINPP01)


 STEP03:     /*===< RINPP01 --> CSV >===*/
             CHGVAR     VAR(&RINWP02) VALUE('RINWP02' *CAT &WS03)
             DLTF       FILE(&WFLB/&RINWP02)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WFLB/&RINWP02) RCDLEN(300) +
                        OPTION(*NOLIST) SIZE(10000 3000) +
                        LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(RINPP01) TOFILE(QTEMP/RINPP01)
             OVRDBF     FILE(RINWP02) TOFILE(&WFLB/&RINWP02)
             CALL       PGM(RINR02)
             DLTOVR     FILE(RINPP01)
             DLTOVR     FILE(RINWP02)


 STEP04:     /*===< CSV TRNSFER  >===*/
             RTVNETA    SYSNAME(&SYSN)
             CHGVAR     VAR(&RCVF) +
                        VALUE('C:/AS400/DATA/IAF_DSPOBJD.CSV')

             CALL       PGM(APLC98) +
                        PARM(&WFLB &RINWP02 &SYSN &RCVF ' 1')


 STEP99:     /*===< PGM END >===*/
             ENDPGM
