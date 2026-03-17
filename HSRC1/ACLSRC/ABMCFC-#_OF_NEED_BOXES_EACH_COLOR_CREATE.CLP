             PGM
             /** ABMCFC ************************/
             /*副資材　箱色別必要箱数　画面照会 */
             /*   HOTTA.           2018.10.18  */
             /**********************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&DDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&P@NTYM) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&P@ERR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ABMWPF0) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ABMWPF1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ABMWPF2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&FNAM)  TYPE(*CHAR) LEN(30)
             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO
             CHGVAR     VAR(&ABMWPF0) VALUE('ABMWPF0' *CAT &WS3)
             CHGVAR     VAR(&ABMWPF1) VALUE('ABMWPF1' *CAT &WS3)
             CHGVAR     VAR(&ABMWPF2) VALUE('ABMWPF2' *CAT &WS3)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
 STP10:
         /*品番情報*/
             DLTF       FILE(&WLIB/&ABMWPF0)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABMWPF0) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABMWPF0) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 20) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(ABMWPF0) TOFILE(&WLIB/&ABMWPF0)
             CALL       PGM(ABMRF0)

         /*工程情報*/
             DLTF       FILE(&WLIB/&ABMWPF1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABMWPF1) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABMWPF1) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 20) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(ABMWPF0) TOFILE(&WLIB/&ABMWPF0)
             OVRDBF     FILE(ABMWPF1) TOFILE(&WLIB/&ABMWPF1)
             CALL       PGM(ABMRF1)  /*製品*/
             CALL       PGM(ABMRF5)  /*構成品*/

       /*----------*/
       /*箱色情報*/
       /*----------*/
             DLTF       FILE(&WLIB/&ABMWPF2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABMWPF2) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABMWPF2) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 20) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(ABMWPF1) TOFILE(&WLIB/&ABMWPF1)
             OVRDBF     FILE(ABMWPF2) TOFILE(&WLIB/&ABMWPF2)
             CALL       PGM(ABMRF2)

         /*箱色別実績*/
             CALL       PGM(ABMRF3)

         /*画面*/
             OVRDBF     FILE(ABMWPF2) TOFILE(&WLIB/&ABMWPF2)
             CALL       PGM(ABMRFC)

 #END:
 END:        ENDPGM
