             PGM
  /** ALRC10 *************************************/
  /*  PASS THRU  INVENTORY CHECK LIST            */
  /*   SAKAKI          2019.10.25                */
  /***********************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&ALRWP10) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ALRWP11) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ALRWP12) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FNAM) TYPE(*CHAR) LEN(30) +
                          VALUE('PT_BPT_INVENTORY_CHECK')

             RTVJOBA    JOB(&WSID) USER(&USER)

             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&ALRWP10) VALUE('ALRWP10' *CAT &WS3)
             CHGVAR     VAR(&ALRWP11) VALUE('ALRWP11' *CAT &WS3)
             CHGVAR     VAR(&ALRWP12) VALUE('ALRWP12' *CAT &WS3)

             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             DLTF       FILE(&WLIB/&ALRWP10)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ALRWP10) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ALRWP10) OPTION(*NOLIST *NOSRC) +
                          SIZE(10000)
             DLTF       FILE(&WLIB/&ALRWP11)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ALRWP11) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ALRWP11) OPTION(*NOLIST *NOSRC) +
                          SIZE(10000)
             DLTF       FILE(&WLIB/&ALRWP12)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ALRWP12) RCDLEN(512) +
                          IGCDTA(*YES) OPTION(*NOLIST *NOSRC) +
                          SIZE(10000)

             OVRDBF     FILE(ALRWP10) TOFILE(&WLIB/&ALRWP10)
             CALL       PGM(ALRR10)

             OVRDBF     FILE(ALRWP11) TOFILE(&WLIB/&ALRWP11)
             CALL       PGM(ALRR11)

             OVRDBF     FILE(ALRWP12) TOFILE(&WLIB/&ALRWP12)
             CALL       PGM(ALRR12)

             CALL       PGM(APLC94) PARM('1' &ALRWP12 &WLIB +
                          &FNAM 'Y' ' ' 'Y')

             DLTOVR     FILE(*ALL)

             ENDPGM
