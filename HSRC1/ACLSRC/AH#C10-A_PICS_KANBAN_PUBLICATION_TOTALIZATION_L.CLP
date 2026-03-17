             PGM
             /*** AH#C10 *************************************/
             /* A-PICS KANBAN PUBLICATION TOTALIZATION LIST  */
             /* SECTION CODE / DATE APPOINTMENT              */
             /*            H.ITO             87.12.11        */
             /*                                              */
             /* TCHK1 11/28/06 CHG OVRPRTF                   */
             /************************************* AH#C10 ***/
             DCLF       FILE(AH#PW11)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PUS) TYPE(*CHAR) LEN(10)
       /*    DCL        VAR(&WY) TYPE(*CHAR) LEN(4)                */
       /*    DCL        VAR(&WM) TYPE(*CHAR) LEN(2)                */
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(9)
             RTVJOBA    JOB(&WSID) USER(&PUS)
             CHGJOB     RUNPTY(40)

    /*       CALL       PGM(KZZR00) PARM(&WSID &PRT &TYPE &PRTG)     */
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(AH#PW111)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         COND(&PBMON *EQ '    ') THEN(DO)
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('SECTION CODE IS NOT INPUT.')
             GOTO STP1
             ENDDO

     /*      IF         COND((&PBMON *NE '8974') *AND (&PBMON *NE +
                          '8990') *AND (&PBMON *NE '8982') *AND +
                          (&PBMON *NE '9032') *AND (&PBMON *NE +
                          '9040') *AND (&PBMON *NE '9245') *AND +
                          (&PBMON *NE '9253') *AND (&PBMON *NE +
                          '9431') *AND (&PBMON *NE '9024')) THEN(DO) */
             IF         COND(&PBMON *NE '0111') THEN(DO)
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('SECTION CODES ARE 0111')
             GOTO STP1
             ENDDO

             IF         COND(&PYYMM *EQ '      ') THEN(DO)
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('REVERSING DATE IS NOT INPUT')
             GOTO STP1
             ENDDO

             IF         (&IN05 *EQ '0') GOTO STP1

       /*    CHGVAR VAR(&WY) VALUE(%SST(&PYYMM 1 4))          */
       /*    CHGVAR VAR(&WM) VALUE(%SST(&PYYMM 5 2))          */

       /*    IF         COND(&PBMON *EQ '9024') THEN(DO)      */
       /*    CALL       PGM(AH#C63) PARM(&PBMON &WY &WM)      */
       /*    GOTO       CMDLBL(END)                           */
       /*    ENDDO                                            */

       /*    IF         COND(&PBMON *EQ '9431') THEN(DO)             */

       /*    DLTF       FILE(AH#WP70)                                */
       /*    MONMSG     MSGID(CPF3261 CPF2105)                       */
       /*    CRTPF      FILE(HWFILE/AH#WP70) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)                                  */

       /*    OVRPRTF    FILE(QPRINT) PAGESIZE(66 132) LPI(6) +
                          OVRFLW(55) RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(K6H1)                             */
       /*    CALL       PGM(AH#R70) PARM(&PBMON &WY &WM &PUS)        */
       /*    DLTOVR     FILE(*ALL)                                   */
       /*    ENDDO                                                   */

             CHGVAR     VAR(&FILE1) VALUE('AH#WP11' *CAT &WS)
             CHGVAR     VAR(&FILE2) VALUE('AH#WP10' *CAT &WS)

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             OVRDBF     FILE(AH#WP11) TOFILE(&FILE1)
             CALL       PGM(AH#R11) PARM(&PBMON &PYYMM)

             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE2) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/&FILE1)) +
                          OUTFILE(HWFILE1/&FILE2) SRCFILE(FMTSRC) +
                          SRCMBR(AH#S10) OPTION(*NOPRT)
             DLTF       FILE(&FILE1)

/* TCHK1 S */
/* TCHK1     OVRPRTF    FILE(AH#PR10) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          198) LPI(6) CPI(15) OVRFLW(60) +
                          RPLUNPRT(*YES) OUTQ(QPRINTB) +
                          FORMTYPE(K6H1) MAXRCDS(*NOMAX) */

            OVRPRTF     FILE(AH#PR10) PAGESIZE(*N 198) CPI(15) +
                          COPIES(01) OUTQ(QPRINT)              +
                          OVRFLW(60) FORMTYPE(K6H1)
/* TCHK1 E */
             OVRDBF     FILE(AH#WP10) TOFILE(&FILE2)
             CALL       PGM(AH#R10) PARM(&PBMON &PYYMM &PUS)
             DLTF       FILE(&FILE2)
             DLTOVR     FILE(*ALL)

 END:        CHGJOB     RUNPTY(20)

             ENDPGM
