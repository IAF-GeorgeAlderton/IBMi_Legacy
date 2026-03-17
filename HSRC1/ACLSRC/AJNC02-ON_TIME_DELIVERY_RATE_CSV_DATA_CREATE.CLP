             PGM
             /** AJNC02 **********************************************/
             /* ON-TIME DELIVERY RATE INQUIRY   CSV DOWNLOAD         */
             /*    SAKAKI.          2019.10.02                       */
             /********************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&AJNWP00) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AJNWP01) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AJNWP02) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FNAM) TYPE(*CHAR) LEN(30) +
                          VALUE('ONTIME_DELIVERY_RATE')

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&AJNWP00) VALUE('AJNWP00' *CAT &WS3)
             CHGVAR     VAR(&AJNWP01) VALUE('AJNWP01' *CAT &WS3)
             CHGVAR     VAR(&AJNWP02) VALUE('AJNWP02' *CAT &WS3)

             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

 STP10:
             DLTF       FILE(&WLIB/&AJNWP02)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AJNWP02) RCDLEN(140) +
                          OPTION(*NOLIST *NOSRC) SIZE(90000 1000 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AJNWP01) TOFILE(&WLIB/&AJNWP01)
             OVRDBF     FILE(AJNWP02) TOFILE(&WLIB/&AJNWP02)
             CALL       PGM(AJNR02)

             CALL       PGM(APLC94) PARM('1' &AJNWP02 &WLIB +
                          &FNAM 'Y' ' ' 'Y')


 #END:       ENDPGM
