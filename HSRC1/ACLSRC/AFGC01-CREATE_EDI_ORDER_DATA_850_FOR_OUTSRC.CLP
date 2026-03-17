             PGM        PARM(&SUPP)
             /** AFGC01 **********************************/
             /* CREATE EDI ORDER DATA 850 FOR OUTSOURCE  */
             /*   T.SAKAKI            2016.10.25         */
             /*     ADD APLR80        2018.06.07 %0001   */
             /*****************************+**** AFGC01 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)    TYPE(*CHAR) LEN(3)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&SUPP)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&PMSG)  TYPE(*CHAR) LEN(256)
             DCL        VAR(&CMD)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&AFGWP01) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AFGWP02) TYPE(*CHAR) LEN(10)

             DCL        VAR(&PIPGMN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POWSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POUSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POKONA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POSTTS) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&AFGWP01) VALUE('AFGWP01' *CAT &WS)
             CHGVAR     VAR(&AFGWP02) VALUE('AFGWP02' *CAT &WS)
    /*--------------------------------------------*/
    /*    CHECK ENVIRONMENT                       */
    /*--------------------------------------------*/
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

    /*--------------------------------------------*/
    /*   %0001  CHECK AND REGISTER                */
    /*--------------------------------------------*/
             CHGVAR     VAR(&PIPGMN) VALUE('AFGC01' *TCAT &SUPP)
             CALL       PGM(APLC80) PARM(&PIPGMN &POWSID &POUSID +
                          &POKONA &POSTTS)
    /*  LOCKED by other user */
          IF         COND(&POSTTS *EQ '2') THEN(DO)
             GOTO       CMDLBL(@END2)
             ENDDO

STEP01:
             DLTF       FILE(&WLIB/&AFGWP01)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AFGWP01) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(AFGWP01) +
                          OPTION(*NOLIST *NOSRC) SIZE(9999 1000 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AFGWP01) TOFILE(&AFGWP01)
    /*--------------*/
    /* MAIN PROGRAM */
    /*--------------*/
             CALL       PGM(AFGR01) PARM(&SUPP)

             RTVMBRD    FILE(&WLIB/&AFGWP01) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             CHGVAR     VAR(&PMSG) VALUE('NO DATA.          ')
             CALL       PGM(QUILNGTX) PARM(&PMSG X'00000046' '       +
                          ' '                    ' X'00000000')
             GOTO       CMDLBL(@END)
             ENDDO

STEP02:
             DLTF       FILE(&WLIB/&AFGWP02)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AFGWP02) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(AFGWP02) +
                          OPTION(*NOLIST *NOSRC) SIZE(9999 1000 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AFGWP02) TOFILE(&AFGWP02)
    /*--------------*/
    /* MAIN PROGRAM */
    /*--------------*/
             CHGVAR     VAR(&CMD) VALUE('  ')
             CALL       PGM(AFGR02) PARM(&SUPP &CMD)

             IF         COND(&CMD *EQ 'UP') THEN(DO)
             GOTO       CMDLBL(STEP01)
             ENDDO

             DLTOVR     FILE(*ALL)

 @END:
        /*--------------------------------*/
        /* %0001  UNLOCK MULTIPLE CONTROL */
        /*--------------------------------*/
             CALL       PGM(APLR81) PARM(&PIPGMN)

 @END2:
             ENDPGM
