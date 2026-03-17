             PGM
             /** ABBC95 **********************************************/
             /* DAILY INVENTORY INQUIRY(CSV)                         */
             /*    SAKAKI.          2019.10.15                       */
             /********************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&ABBWP92) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ABBWP95) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FNAM) TYPE(*CHAR) LEN(30) +
                          VALUE('DAILY INVENTORY')

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&ABBWP92) VALUE('ABBWP92' *CAT &WS3)
             CHGVAR     VAR(&ABBWP95) VALUE('ABBWP95' *CAT &WS3)

             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

 STP10:
             DLTF       FILE(&WLIB/&ABBWP95)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABBWP95) RCDLEN(150) +
                          OPTION(*NOLIST *NOSRC) SIZE(90000 1000 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(ABBWP92) TOFILE(&WLIB/&ABBWP92)
             OVRDBF     FILE(ABBWP95) TOFILE(&WLIB/&ABBWP95)
             CALL       PGM(ABBR95)

             CALL       PGM(APLC94) PARM('1' &ABBWP95 &WLIB +
                          &FNAM 'Y' ' ' 'Y')


 #END:       ENDPGM
