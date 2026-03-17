             PGM        PARM(&SUPP)
             /** AFGC10 ****************************/
             /* INQUIRY & RE-CREATE EDI ORDER      */
             /*   T.SAKAKI      2016.10.25         */
             /**************************** AFGC02 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)    TYPE(*CHAR) LEN(3)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&PMSG)  TYPE(*CHAR) LEN(256)

             DCL        VAR(&SUPP)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&P1SDAT) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&P1EDAT) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&P1GPPO) TYPE(*CHAR) LEN(17)
             DCL        VAR(&PCMD)    TYPE(*CHAR) LEN(2)

             DCL        VAR(&AFGWP01) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AFGWP02) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&AFGWP01) VALUE('AFGWP01' *CAT &WS)
             CHGVAR     VAR(&AFGWP02) VALUE('AFGWP02' *CAT &WS)
    /*--------------------------------------------*/
    /*    CHECK ENVIRONMENT                       */
    /*--------------------------------------------*/
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

    /*--------------*/
    /* INPUT SCREEN */
    /*--------------*/
STEP01:
             CALL       PGM(AFGR10) PARM(&SUPP &P1SDAT &P1EDAT +
                          &P1GPPO &PCMD)
             IF         COND(&PCMD *EQ '03') THEN(DO)
             GOTO       CMDLBL(@END)
             ENDDO

    /*--------------*/
    /* MAIN PROGRAM */
    /*--------------*/
STEP02:
             DLTF       FILE(&WLIB/&AFGWP01)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AFGWP01) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AFGWP01) OPTION(*NOLIST *NOSRC) +
                          SIZE(9999 1000 3) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AFGWP01) TOFILE(&AFGWP01)
             CALL       PGM(AFGR11) PARM(&SUPP &P1SDAT &P1EDAT &P1GPPO)

             RTVMBRD    FILE(&WLIB/&AFGWP01) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             CHGVAR     VAR(&PMSG) VALUE('NO DATA.          ')
             CALL       PGM(QUILNGTX) PARM(&PMSG X'00000046' '       +
                          ' '                    ' X'00000000')
             GOTO       CMDLBL(@END)
             ENDDO

             DLTF       FILE(&WLIB/&AFGWP02)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AFGWP02) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AFGWP02) OPTION(*NOLIST *NOSRC) +
                          SIZE(9999 1000 3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AFGWP02) TOFILE(&AFGWP02)
    /*--------------*/
    /* MAIN PROGRAM */
    /*--------------*/
             CALL       PGM(AFGR12) PARM(&SUPP &P1SDAT &P1EDAT &P1GPPO &PCMD)
             IF         COND(&PCMD *EQ 'UP') THEN(DO)
             GOTO       CMDLBL(STEP02)
             ENDDO
             GOTO       CMDLBL(STEP01)

 @END:
             DLTOVR     FILE(*ALL)
             ENDPGM
