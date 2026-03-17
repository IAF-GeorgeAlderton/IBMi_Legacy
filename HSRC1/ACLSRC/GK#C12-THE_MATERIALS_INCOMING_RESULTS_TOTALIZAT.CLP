             PGM
             /** GK#C12 ********************/
             /*   THE MATERIALS INCOMING RESULTS TOTALIZATION   */
             /* I-HASADA 94.09.10 */
             /******************** GK#C12 **/
             DCLF       FILE(GK#PW12)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE3) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE4) TYPE(*CHAR) LEN(9)
             RTVJOBA    JOB(&WS) USER(&USER)
             CHGJOB     SWS(00000000)
             CHGVAR     VAR(&WSID) VALUE(%SST(&WS 1 2))
          /* ADDLIBLE   LIB(DDM70) */

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

 STP1:       SNDRCVF    DEV(&WS) RCDFMT(GK#PW121)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN04) VALUE('0')
             CHGVAR     VAR(&IN06) VALUE('0')
             CHGVAR     VAR(&IN07) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&@YY *EQ '    ') DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('APPOINTED DATE(YEAR) IS NOT INPUT.')
             GOTO STP1
             ENDDO

             IF         (&@MM *EQ '  ') DO
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('APPOINTED DATE(MONTH) IS NOT INPUT.')
             GOTO STP1
             ENDDO

             IF         (&@UKER *EQ '    ') DO
             CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('RECEIVING FACTORY IS NOT INPUT.')
             GOTO STP1
             ENDDO

             IF         (&@SIRE *EQ '    ') DO
             CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('SUPPLIER IS NOT INPUT.')
             GOTO STP1
             ENDDO

             IF         ((&@UKER *EQ '9999') *AND (&@SIRE *NE +
                          '9999')) DO
             CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THIS APPOINTMENT IS NOT COMPLETED.')
             GOTO STP1
             ENDDO

             IF         (&@KUBN *EQ ' ') DO
             CHGVAR     VAR(&IN07) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('MATERIALS INSTRUCTION IS NOT INPUT.')
             GOTO STP1
             ENDDO

             IF         ((&@KUBN *NE 'A') *AND (&@KUBN *NE 'B') *AND +
                          (&@KUBN *NE 'C')) DO
             CHGVAR     VAR(&IN07) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('MATERIALS INSTRUCTION IS NOT RIGHT.')
             GOTO STP1
             ENDDO

             IF         (&IN05 *EQ '0') GOTO STP1

             CHGVAR     VAR(&FILE1) VALUE('GK#WP141' *CAT &WSID)
             CHGVAR     VAR(&FILE2) VALUE('GK#WP142' *CAT &WSID)
             CHGVAR     VAR(&FILE3) VALUE('GK#WP12'  *CAT &WSID)
             CHGVAR     VAR(&FILE4) VALUE('GK#WP13'  *CAT &WSID)

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(30000 5000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE2) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(30000 5000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(GK#WP141) TOFILE(&FILE1)
             OVRDBF     FILE(GK#WP142) TOFILE(&FILE2)
             CALL       PGM(GK#R14) PARM(&@YY &@MM &@UKER &@SIRE +
                          &@KUBN)
             DLTOVR     FILE(*ALL)

             /*----------------*/
             /*    COMPLETION MATERIALS   */
             /*----------------*/
             IF         (%SWITCH(1XXXXXXX)) DO

             DLTF       FILE(&FILE3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE3) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(30000 5000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE3) SRCFILE(FMTSRC) +
                          SRCMBR(GK#S14) OPTION(*NOPRT)
             DLTF       FILE(&FILE1)

             OVRPRTF    FILE(GK#PR12) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) RPLUNPRT(*YES) OUTQ(LANPRT02) +
                          FORMTYPE(K6S1)
             OVRDBF     FILE(GK#WP12) TOFILE(&FILE3)
             CALL       PGM(GK#R12) PARM(&@MM)
             DLTF       FILE(&FILE3)
             DLTOVR     FILE(*ALL)

             ENDDO
             ELSE       DO

             DLTF       FILE(&FILE1)

             ENDDO

             /*--------------*/
             /*    MATERIAL   */
             /*--------------*/
             IF         (%SWITCH(X1XXXXXX)) DO

             DLTF       FILE(&FILE4)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE4) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(30000 5000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/&FILE2)) +
                          OUTFILE(HWFILE1/&FILE4) SRCFILE(FMTSRC) +
                          SRCMBR(GK#S14) OPTION(*NOPRT)
             DLTF       FILE(&FILE2)

             OVRPRTF    FILE(GK#PR13) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          80) LPI(6) RPLUNPRT(*YES) OUTQ(LANPRT02) +
                          FORMTYPE(K6S1)
             OVRDBF     FILE(GK#WP13) TOFILE(&FILE4)
             CALL       PGM(GK#R13) PARM(&@MM)
             DLTF       FILE(&FILE4)
             DLTOVR     FILE(*ALL)

             ENDDO
             ELSE       DO

             DLTF       FILE(&FILE2)

             ENDDO

 /* END:        RMVLIBLE   LIB(DDM70) */

 END:        ENDPGM
