             PGM        PARM(&SUPP)
             /** AFHC01 **************************************/
             /* CREATE EDI FORECAST DATA 830 FOR OUTSOURCE   */
             /*   T.SAKAKI              2016.08.12           */
             /************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PMSG)  TYPE(*CHAR) LEN(256)
             DCL        VAR(&PMSG2)  TYPE(*CHAR) LEN(256)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SUPP)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)

             DCL        VAR(&FIL1)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&SNAM)  TYPE(*CHAR) LEN(23)

             DCL        VAR(&FNAM)  TYPE(*CHAR) LEN(10)

             DCL        VAR(&P1SDAT) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&P1EDAT) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&P1TER1) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&P1TER2) TYPE(*CHAR) LEN(1)
             DCL        VAR(&P1TMQL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&P1LDT1) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&P1LDT2) TYPE(*CHAR) LEN(1)

             DCL        VAR(&SFILE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&SLIBL)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&JYKB) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PTID) TYPE(*CHAR) LEN(12)
             DCL        VAR(&SND) TYPE(*CHAR) LEN(10)

             DCL        VAR(&PKINP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PKOUT) TYPE(*CHAR) LEN(1)

             DCL        VAR(&AFHWP01) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AFHWP02) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AFHWP03) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AFHWP04) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&AFHWP01) VALUE('AFHWP01' *CAT &WS3)
             CHGVAR     VAR(&AFHWP02) VALUE('AFHWP02' *CAT &WS3)
             CHGVAR     VAR(&AFHWP03) VALUE('AFHWP03' *CAT &WS3)
             CHGVAR     VAR(&AFHWP04) VALUE('AFHWP04' *CAT &WS3)

           /*--------------------------------------------*/
           /*    CHECK ENVIRONMENT                        */
           /*--------------------------------------------*/
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

 #STP10:
    /*--------------*/
    /* INPUT SCREEN */
    /*--------------*/
             CALL       PGM(AFHR01) PARM(&SUPP &P1SDAT &P1TER1 +
                          &P1TER2 &P1TMQL &P1LDT1 &P1LDT2 &PCMD)
             IF         COND(&PCMD *EQ '01') THEN(DO)
             GOTO       CMDLBL(END)
             ENDDO
 #STP20:
             DLTF       FILE(&WLIB/&AFHWP01)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AFHWP01) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AFHWP01) OPTION(*NOLIST *NOSRC) +
                          SIZE(10000 5000 3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AFHWP01) TOFILE(&WLIB/&AFHWP01)

             DLTF       FILE(&WLIB/&AFHWP02)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AFHWP02) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AFHWP02) OPTION(*NOLIST *NOSRC) +
                          SIZE(10000 5000 3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AFHWP02) TOFILE(&WLIB/&AFHWP02)

    /*------------------------------*/
    /* COLLECT PART # AND EACH DATE */
    /*------------------------------*/
             CALL       PGM(AFHR02) PARM(&SUPP &P1SDAT &P1EDAT +
                          &P1TER1 &P1TER2 &P1TMQL &P1LDT1 &P1LDT2)

 #STP30:
             DLTF       FILE(&WLIB/&AFHWP03)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AFHWP03) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AFHWP03) OPTION(*NOLIST *NOSRC) +
                          SIZE(10000 5000 3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AFHWP03) TOFILE(&WLIB/&AFHWP03)

    /*------------------*/
    /* COLLECT FORECAST */
    /*------------------*/
             CALL       PGM(AFHR03)

             RTVMBRD    FILE(&WLIB/&AFHWP03) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             CHGVAR     VAR(&PMSG) VALUE('NO DATA.          ')
             CALL       PGM(QUILNGTX) PARM(&PMSG X'00000046' '       +
                          ' '                    ' X'00000000')
             GOTO       CMDLBL(#STP10)
             ENDDO

 #STP40:
    /*----------------------*/
    /* SAVE CSV DETAIL DATA */
    /*----------------------*/
             CHGVAR     VAR(&FIL1) VALUE(&AFHWP03)
             CHGVAR     VAR(&SNAM) VALUE('EDI 830 FOR ' *CAT &SUPP)
             CALL       PGM(APLC90) PARM(&FIL1 &WLIB &SNAM)

             CHGVAR     VAR(&PMSG2) VALUE('IF DOWNLOADED DATA IS OK, +
                          ENTER "G" AND PRESS THE ENTER KEY TO +
                          CREATE. IF IT IS NG, ENTER "C" TO CANCEL.')
             CHGVAR     VAR(&PKINP) VALUE('GC   ')
             CHGVAR     VAR(&PKOUT) VALUE(' ')
             CALL       PGM(APLR90) PARM(&PMSG2 &PKINP &WSID &PKOUT)
             IF         COND(&PKOUT *EQ 'C') THEN(GOTO CMDLBL(#STP10))

 #STP50:
    /*------------------------*/
    /* GET PARTNER GROUP & ID */
    /*------------------------*/
             CALL       PGM(EJKR51) PARM(&SUPP 'S' '830' &JYKB &PTID)

    /*---------------------------------*/
    /* GET UNIQUE NUMBER FOR FILE NAME */
    /*---------------------------------*/
             CALL       PGM(EJKC56) PARM('830' &FNAM)

    /*----------------------*/
    /* CREATE EDI FLAT DATA */
    /*----------------------*/
             DLTF       FILE(&WLIB/&AFHWP04)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AFHWP04) RCDLEN(504) +
                          OPTION(*NOLIST *NOSRC) SIZE(1000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(OUTPUT) TOFILE(&WLIB/&AFHWP04)
    /*-----------*/
    /*  HEADER   */
    /*-----------*/
             CALL       PGM(AFHR04) PARM(&SUPP 'S' '830' &PTID &FNAM +
                          &P1SDAT &P1EDAT)
    /*-----------*/
    /* DETAIL    */
    /*-----------*/
             CALL       PGM(AFHR05) PARM(&SUPP 'S' '830' &FNAM)
    /*-----------*/
    /* TRAILER   */
    /*-----------*/
             CALL       PGM(AFHR06) PARM(&FNAM)

 #STP60:
    /*-----------------------------------------------*/
    /* REGISTER RECEPTION FILE FOR B2B_S             */
    /*    &SFILE/&SLIBL --> S888XX0000 -->  EJKPP50  */
    /*-----------------------------------------------*/
             CHGVAR     VAR(&SFILE) VALUE(&AFHWP04)
             CHGVAR     VAR(&SLIBL) VALUE(&WLIB)
             CALL       PGM(EJKC57) PARM(&JYKB '830' &SFILE &SLIBL +
                          &FNAM)

             CHGVAR     VAR(&PMSG) VALUE('DATA IS CREATED. AND WILL +
                          BE SENT IN 5 MINUTES.')
             CALL       PGM(QUILNGTX) PARM(&PMSG X'00000046' '       +
                          ' '                    ' X'00000000')

 END:
             DLTOVR     FILE(*ALL)

             ENDPGM
