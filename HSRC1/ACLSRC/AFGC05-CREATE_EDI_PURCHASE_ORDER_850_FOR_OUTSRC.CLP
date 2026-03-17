             PGM        PARM(&SUPP &GPPO)
             /** AFGC05 ****************************************/
             /* CREATE EDI PURCHASE ORDER 850 FOR OUTSOURCE    */
             /*   T.SAKAKI                2016.11.16           */
             /**************************************************/
             DCL        VAR(&SUPP)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&GPPO)  TYPE(*CHAR) LEN(17)

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PMSG)  TYPE(*CHAR) LEN(256)

             DCL        VAR(&FNAM)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&SFILE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&SLIBL)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&JYKB) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PTID) TYPE(*CHAR) LEN(12)

             DCL        VAR(&AFGWP05) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&AFGWP05) VALUE('AFGWP05' *CAT &WS3)

    /*--------------------------------------------*/
    /*    CHECK ENVIRONMENT                        */
    /*--------------------------------------------*/
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

 #STP10:
    /*--------------------------------------*/
    /* GET PARTNER GROUP & ID  FROM EDKPP10 */
    /*--------------------------------------*/
             CALL       PGM(EJKR51) PARM(&SUPP 'S' '850' &JYKB &PTID)

    /*---------------------------------*/
    /* GET UNIQUE NUMBER FOR FILE NAME */
    /*---------------------------------*/
             CALL       PGM(EJKC56) PARM('850' &FNAM)

    /*----------------------*/
    /* CREATE EDI FLAT DATA */
    /*----------------------*/
             DLTF       FILE(&WLIB/&AFGWP05)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AFGWP05) RCDLEN(1075) +
                          OPTION(*NOLIST *NOSRC) SIZE(1000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(OUTPUT) TOFILE(&WLIB/&AFGWP05)

    /*-----------*/
    /*  HEADER   */
    /*-----------*/
             CALL       PGM(AFGR05) PARM(&SUPP &GPPO &PTID &FNAM)
    /*-----------*/
    /* DETAIL    */
    /*-----------*/
             CALL       PGM(AFGR06) PARM(&SUPP &GPPO &FNAM)
    /*-----------*/
    /* TRAILER   */
    /*-----------*/
             CALL       PGM(AFGR07) PARM(&FNAM)

 #STP20:
    /*-----------------------------------------------*/
    /* REGISTER RECEPTION FILE FOR B2B_S             */
    /*    &SFILE/&SLIBL --> S888XX0000 -->  EJKPP50  */
    /*-----------------------------------------------*/
             CHGVAR     VAR(&SFILE) VALUE(&AFGWP05)
             CHGVAR     VAR(&SLIBL) VALUE(&WLIB)
             CALL       PGM(EJKC57) PARM(&JYKB '850' &SFILE &SLIBL +
                          &FNAM)

             IF         COND(&SUPP *EQ '2112') THEN(DO)
             CHGVAR     VAR(&PMSG) VALUE('DATA IS CREATED. AND WILL +
                          BE SENT IN 5 MINUTES.')
             CALL       PGM(QUILNGTX) PARM(&PMSG X'00000046' '       +
                          ' '                    ' X'00000000')
             ENDDO

 END:
             DLTOVR     FILE(*ALL)

             ENDPGM
