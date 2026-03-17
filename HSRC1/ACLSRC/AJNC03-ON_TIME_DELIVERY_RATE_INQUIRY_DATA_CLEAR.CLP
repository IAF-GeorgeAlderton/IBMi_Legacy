             PGM
             /** AJNC03 **********************************************/
             /* ON-TIME DELIVERY RATE INQUIRY  DATA CLEAR            */
             /*納期遵守率の見える化                                */
             /*    SAKAKI.          2019.10.02                       */
             /********************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&AJNWP01) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AJNWP03) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&AJNWP01) VALUE('AJNWP01' *CAT &WS3)
             CHGVAR     VAR(&AJNWP03) VALUE('AJNWP03' *CAT &WS3)

             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

 STP10:
             DLTF       FILE(&WLIB/&AJNWP01)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AJNWP01) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AJNWP01) OPTION(*NOLIST *NOSRC) +
                          SIZE(500000 1500 3) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&WLIB/&AJNWP03)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AJNWP03) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AJNWP03) OPTION(*NOLIST *NOSRC) +
                          SIZE(500000 1500 3) LVLCHK(*NO) AUT(*ALL)

 #END:       ENDPGM
