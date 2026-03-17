             PGM
             /** ABMCF0 ************************/
             /*副資材                          */
             /*   HOTTA.           2018.09.14  */
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
             DCL        VAR(&ABMWPF4) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ABMWPF6) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ABMWPF8) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ABMWPF9) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ABMWPFB) TYPE(*CHAR) LEN(10)
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
             CHGVAR     VAR(&ABMWPF0) VALUE('ABMWPF0')
             CHGVAR     VAR(&ABMWPF1) VALUE('ABMWPF1')
             CHGVAR     VAR(&ABMWPF2) VALUE('ABMWPF2')
             CHGVAR     VAR(&ABMWPF4) VALUE('ABMWPF4')
             CHGVAR     VAR(&ABMWPF6) VALUE('ABMWPF6')
             CHGVAR     VAR(&ABMWPF8) VALUE('ABMWPF8')
             CHGVAR     VAR(&ABMWPF9) VALUE('ABMWPF9')
             CHGVAR     VAR(&ABMWPFB) VALUE('ABMWPFB')

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

         /*リスト*/
             DLTF       FILE(&ABMWPF4)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABMWPF4) RCDLEN(0256) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)
             OVRDBF     FILE(ABMWPF2) TOFILE(&WLIB/&ABMWPF2)
             OVRDBF     FILE(ABMWPF4) TOFILE(&WLIB/&ABMWPF4)
             CALL       PGM(ABMRF4)
      /*     CALL       PGM(APLC96) PARM('1' &ABMWPF4 &WLIB +
                          &FNAM 'Y' ' ')                         */

       /*------------*/
       /*工程別情報*/
       /*------------*/
             DLTF       FILE(&WLIB/&ABMWPF6)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABMWPF6) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABMWPF6) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 20) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(ABMWPF1) TOFILE(&WLIB/&ABMWPF1)
             OVRDBF     FILE(ABMWPF6) TOFILE(&WLIB/&ABMWPF6)
             CALL       PGM(ABMRF6)

         /*工程別実績*/
             CALL       PGM(ABMRF7)

         /*リスト*/
             DLTF       FILE(&ABMWPF8)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABMWPF8) RCDLEN(0256) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)
             OVRDBF     FILE(ABMWPF6) TOFILE(&WLIB/&ABMWPF6)
             OVRDBF     FILE(ABMWPF8) TOFILE(&WLIB/&ABMWPF8)
             CALL       PGM(ABMRF8)
      /*     CALL       PGM(APLC96) PARM('1' &ABMWPF8 &WLIB +
                          &FNAM 'Y' ' ')                         */
       /*------------*/
       /*型番別情報*/
       /*------------*/
             DLTF       FILE(&WLIB/&ABMWPF9)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABMWPF9) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABMWPF9) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 5000 20) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(ABMWPF1) TOFILE(&WLIB/&ABMWPF1)
             OVRDBF     FILE(ABMWPF9) TOFILE(&WLIB/&ABMWPF9)
             CALL       PGM(ABMRF9)

         /*型番別実績H.ITOより保留 */
      /***   CALL       PGM(ABMRFA)    ***/

         /*リスト*/
             DLTF       FILE(&ABMWPFB)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ABMWPFB) RCDLEN(0256) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)
             OVRDBF     FILE(ABMWPF9) TOFILE(&WLIB/&ABMWPF9)
             OVRDBF     FILE(ABMWPFB) TOFILE(&WLIB/&ABMWPFB)
      /***   CALL       PGM(ABMRFB)    ***/
      /*     CALL       PGM(APLC96) PARM('1' &ABMWPFB &WLIB +
                          &FNAM 'Y' ' ')                         */
 #END:
 END:        ENDPGM
