             PGM        PARM(&PDATA)
             /** AGJC43 **********************************************/
             /* INQ #OF A-PICS KANBAN  CSV DATA(GRAPH)               */
             /*    SAKAKI.          2019.10.23                       */
             /********************************************************/
             DCL        VAR(&PDATA) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&AGJWP40) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AGJWP41) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AGJWP42) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AGJWP43) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FNAM) TYPE(*CHAR) LEN(30) +
                          VALUE('#OF A-PICS KANBAN(GRAPH)')

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&AGJWP40) VALUE('AGJWP40' *CAT &WS3)
             CHGVAR     VAR(&AGJWP41) VALUE('AGJWP41' *CAT &WS3)
             CHGVAR     VAR(&AGJWP42) VALUE('AGJWP42' *CAT &WS3)
             CHGVAR     VAR(&AGJWP43) VALUE('AGJWP43' *CAT &WS3)

             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

 STP10:
             DLTF       FILE(&WLIB/&AGJWP43)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AGJWP43) RCDLEN(256) +
                          OPTION(*NOLIST *NOSRC) SIZE(90000 1000 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AGJWP40) TOFILE(&WLIB/&AGJWP40)
             OVRDBF     FILE(AGJWP41) TOFILE(&WLIB/&AGJWP41)
             OVRDBF     FILE(AGJWP42) TOFILE(&WLIB/&AGJWP42)
             OVRDBF     FILE(AGJWP43) TOFILE(&WLIB/&AGJWP43)
             CALL       PGM(AGJR43) PARM(&PDATA)

             CALL       PGM(APLC94) PARM('1' &AGJWP43 &WLIB +
                          &FNAM 'Y' ' ' 'Y')


 #END:       ENDPGM
