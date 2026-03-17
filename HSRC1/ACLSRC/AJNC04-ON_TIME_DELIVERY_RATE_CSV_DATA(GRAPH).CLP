             PGM
             /** AJNC02 **********************************************/
             /* ON-TIME DELIVERY RATE  CSV DATA(GRAPH)               */
             /*    SAKAKI.          2019.10.07                       */
             /********************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&AJNWP03) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AJNWP04) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FNAM) TYPE(*CHAR) LEN(30) +
                          VALUE('ONTIME_DELIVERY_RATE_GRAPH')

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&AJNWP03) VALUE('AJNWP03' *CAT &WS3)
             CHGVAR     VAR(&AJNWP04) VALUE('AJNWP04' *CAT &WS3)

             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

 STP10:
             DLTF       FILE(&WLIB/&AJNWP04)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AJNWP04) RCDLEN(256) +
                          OPTION(*NOLIST *NOSRC) SIZE(90000 1000 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AJNWP03) TOFILE(&WLIB/&AJNWP03)
             OVRDBF     FILE(AJNWP04) TOFILE(&WLIB/&AJNWP04)
             CALL       PGM(AJNR04)

             CALL       PGM(APLC94) PARM('1' &AJNWP04 &WLIB +
                          &FNAM 'Y' ' ' 'Y')


 #END:       ENDPGM
