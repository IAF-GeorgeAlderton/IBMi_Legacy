             PGM
             /** AFACAA **************************************/
             /* DATA MAKING AT PRODUCTION INST NEXT WEEK FIRST DAY 8 OCLOCK */
             /* I-HASADA                      89.08.03       */
             /************************************** AFACAA **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OUTQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CTIME) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MTIME) TYPE(*CHAR) LEN(4)
             DCL        VAR(&DAY) TYPE(*CHAR) LEN(8)
             DCL        VAR(&HH) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MM) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FL0111) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FL9431) TYPE(*CHAR) LEN(9)
             DCL        VAR(&PB0111) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PI0111) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PB9431) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PI9431) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(60)
             DCL        VAR(&RPY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PSW1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PSW2) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CNT) TYPE(*DEC) LEN(2) VALUE(0)
             DCL        VAR(&PMSG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&YMD) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PHZKB) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PCONT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTER) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHKOBJ     OBJ(TFILE1/AFAACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STPX))
 STPY:       SNDPGMMSG  MSG('( G ) +
                          A-PICS 1 PRODUCTION INSTRUCTION DATA MAKING +
                          PROGRAM IS ACTIVE.') TOMSGQ(&WSID) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTE)
             IF         COND((&KOTE *NE 'G') *AND (&KOTE *NE 'g')) +
                          THEN(GOTO CMDLBL(STPY))
             GOTO       SEND

 STPX:       CRTDTAARA  DTAARA(TFILE1/AFAACT) TYPE(*CHAR) LEN(10) +
                          TEXT('A-PICS 1 PRODUCTION INSTRUCTION +
                          DATA MAKING') AUT(*ALL)

             IF         (&TYPE = 'K') CHGVAR VAR(&OUTQ) VALUE(&PRT)
             ELSE       CHGVAR VAR(&OUTQ) VALUE(&PRTG)

             CHGVAR     VAR(&CTIME) VALUE('0800')
             CHGVAR     VAR(&PSW1) VALUE(' ')
             CHGVAR     VAR(&PSW2) VALUE(' ')

             CALL       PGM(AFARAA) PARM(&YMD)
             IF         (%SWITCH(0XXXXXXX)) RETURN

 SX1:        SNDPGMMSG  MSG('( Y.N ) DATE IS ' *CAT &YMD *CAT ' +
                          . IS IT OK ? +
                          ... Y-YES N-NO ...') +
                          TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTE)
             IF         COND((&KOTE *EQ 'Y') *OR (&KOTE *EQ 'y')) +
                          THEN(GOTO CMDLBL(SX2))
             IF         COND((&KOTE *EQ 'N') *OR (&KOTE *EQ 'n')) +
                          THEN(GOTO CMDLBL(END))
             GOTO       SX1

 SX2:        CHGJOB     OUTQ(&OUTQ) DATE(&YMD)

 @0A:        CHGJOB     SWS(00000000)

             CHGVAR     VAR(&MTIME) VALUE('    ')

             /*--------------------------------------*/
             /*  NOT TRANSMITTED DATA CHECK FOR EACH FACTORY  */
             /*--------------------------------------*/
             CALL       PGM(AFAR18) PARM(&CTIME &MTIME)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDUSRMSG  +
                          MSG('ERROR AT PGM(AFAR18) +
                          < RETRY-R +
                          CANCEL-C >') VALUES('R' 'C') +
                          MSGTYPE(*INQ) TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF         COND((&RPY *EQ 'R') *OR (&RPY *EQ 'r')) +
                          THEN(GOTO CMDLBL(@0A))
             RETURN
             ENDDO

             IF         COND(%SWITCH(1XXXXXXX)) THEN(DO)
             CHGVAR     VAR(&HH) VALUE(%SST(&MTIME 1 2))
             CHGVAR     VAR(&MM) VALUE(%SST(&MTIME 3 2))
             CHGVAR     VAR(&MSG) VALUE('( G )' *BCAT &HH *CAT ':' +
                          *CAT &MM *CAT +
                          'THERE ARE NOT TRAMSMITTED DATA.')
 STEP02:     SNDPGMMSG  MSG(&MSG) TOMSGQ(QSYSOPR) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTE)
             IF         COND((&KOTE *NE 'G') *AND (&KOTE *NE 'g')) +
                          THEN(GOTO CMDLBL(STEP02))
             RETURN
             ENDDO

 @00:        CHGJOB     SWS(00000000)
             OVRPRTF    FILE(AFAPR10) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
             CALL       PGM(AFAR10) PARM(&CTIME)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDUSRMSG  +
                          MSG('ERROR AT PGM(AFAR10) +
                          < RETRY-R +
                          CANCEL-C >') VALUES('R' 'C') +
                          MSGTYPE(*INQ) TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF         COND((&RPY *EQ 'R') *OR (&RPY *EQ 'r')) +
                          THEN(GOTO CMDLBL(@00))
             RETURN
             ENDDO

             IF         COND(%SWITCH(1XXXXXXX)) THEN(DO)
             SNDPGMMSG  +
                          MSG('PLEASE HAND YESTURDAY''S NON-TRANSMITTED +
                          LIST OF LEVELED FIXED ORDERING ACCUMMULATION +
                          FILE TO BOSS AT PRODUCTION ENGINEERING +
                          SECTION.') TOMSGQ(QSYSOPR)
             ENDDO
             DLTOVR     FILE(AFAPR10)

 @01:        CHGJOB     SWS(00000000)

             CHGVAR     VAR(&DAY) VALUE('        ')
             CHGVAR     VAR(&PB0111) VALUE('    ')
             CHGVAR     VAR(&PI0111) VALUE('  ')
             CHGVAR     VAR(&PB9431) VALUE('    ')
             CHGVAR     VAR(&PI9431) VALUE('  ')

             /*--------------------------------------------------*/
             /* SETTING FOR TRANSMISSION DATA MAKING BIN.*/
             /* EFFECTIVE EXCEPT UNWORKING NIGHT ATTENDANCE    */
             /*--------------------------------------------------*/
             CALL       PGM(AFAR11) PARM(&CTIME &PB0111 &PI0111 +
                          &PB9431 &PI9431 &DAY)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDUSRMSG  +
                          MSG('ERROR AT PGM(AFAR11) +
                          < RETRY-R +
                          CANCEL-C >') VALUES('R' 'C') +
                          MSGTYPE(*INQ) TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF         COND((&RPY *EQ 'R') *OR (&RPY *EQ 'r')) +
                          THEN(GOTO CMDLBL(@01))
             RETURN
             ENDDO

             /*--------------------------------------------*/
             /*   A-PICS TRANSMISSION POINT JUDGMENT M/F UPDATE   */
             /* .. ACAWP11 (WORK ) --> ACAPP11 (M/F ) */
             /*--------------------------------------------*/
 @01YY:      CALL       PGM(ACAR14)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDUSRMSG  +
                          MSG('ERROR AT PGM(ACAR14) +
                          < RETRY-R +
                          CANCEL-C >') VALUES('R' 'C') +
                          MSGTYPE(*INQ) TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF         COND((&RPY *EQ 'R') *OR (&RPY *EQ 'r')) +
                          THEN(GOTO CMDLBL(@01YY))
             RETURN
             ENDDO

             /*------------------------------------------*/
             /* LEVELLED PRODUCTION DECISION ORDERING ACCUMULATION FILE UPDATE*/
             /* .. AGAWP31 (WORK ) --> AGAPP31 (M/F ) */
             /*------------------------------------------*/
 @01XX:      CALL       PGM(AGAR32) PARM(&DAY)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDUSRMSG  +
                          MSG('ERROR AT PGM(AGAR32) +
                          < RETRY-R +
                          CANCEL-C >') VALUES('R' 'C') +
                          MSGTYPE(*INQ) TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF         COND((&RPY *EQ 'R') *OR (&RPY *EQ 'r')) +
                          THEN(GOTO CMDLBL(@01XX))
             RETURN
             ENDDO

 @XTP1:      CALL       PGM(AFAR22) PARM(&PB0111 &PI0111 &PB9431 +
                          &PI9431)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDUSRMSG  +
                          MSG('ERROR AT PGM(AFAR22) +
                          < RETRY-R +
                          CANCEL-C >') VALUES('R' 'C') +
                          MSGTYPE(*INQ) TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF         COND((&RPY *EQ 'R') *OR (&RPY *EQ 'r')) +
                          THEN(GOTO CMDLBL(@XTP1))
             RETURN
             ENDDO

             /*--------------------------------------------------*/
             /* A-PICS PLAN PUBLICATION PRODUCTION INSTRUCTION DATA CREATE */
             /*MINUS NUMBER OF BOXES / PLUS NUMBER OF BOXES    */
             /*--------------------------------------------------*/
             IF         (&CTIME *EQ '0800') DO
             CALL       PGM(BTAR22) PARM(&USER)
             ENDDO

             /*------------------------------------------------------*/
             /*WHEN THERE IS NOT TRANSMISSION SECTION IN APPOINTMENT,+
                                              SET THE FOLLOWING TIME */
             /*------------------------------------------------------*/
             CHGVAR     VAR(&PSW1) VALUE('*')
             CHGVAR     VAR(&PHZKB) VALUE('*')
             CALL       PGM(ADACJ1) PARM(&WSID &CTIME &PHZKB) /* +
                          FROM AU TO BIN DIVISION */
             IF         COND(%SWITCH(X1111XXX)) THEN(GOTO END)

             /*------------------------------------------------*/
             /*   A-PICS PLAN PUBLICATION PRODUCTION INSTRUCTION DATA CREATE */
             /*------------------------------------------------*/
             IF         (&CTIME *EQ '0800') DO
             CALL       PGM(BTAC20)
             ENDDO

             CHKOBJ     OBJ(AFAWP12) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(TWFILE1/AFAWP12) RCDLEN(250) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          AUT(*ALL))

             /*------------------------------------*/
             /*   LEVELLED PRODUCTION DECISION ORDERING ACCUMULATION FILE   */
             /*   BESIDES KUMAMOTO FACTORY.     */
             /*------------------------------------*/
 @03XX:      CLRPFM     FILE(AFAWP12)

             IF         COND(&PB0111 *EQ '    ') THEN(DO)
             ENDDO
             ELSE       DO

             CALL       PGM(AFAR12) PARM(&PB0111 &PI0111 &DAY)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDUSRMSG  +
                          MSG('ERROR AT PGM(AFAR12) +
                          < RETRY-R +
                          CANCEL-C >') VALUES('R' 'C') +
                          MSGTYPE(*INQ) TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF         COND((&RPY *EQ 'R') *OR (&RPY *EQ 'r')) +
                          THEN(GOTO CMDLBL(@03XX))
             RETURN
             ENDDO

             /*--------------------------*/
             /*  UNWORKING NIGHT  ATTENDANCE   DATA */
             /*   BESIDES KUMAMOTO FACTORY. */
             /*--------------------------*/
 $03XX:      CHGVAR     VAR(&PRTER) VALUE(' ')
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
             CALL       PGM(AFAR32) PARM(&DAY &PB0111 &PI0111 &PRTER)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDUSRMSG  +
                          MSG('ERROR AT PGM(AFAR32) +
                          < RETRY-R +
                          CANCEL-C >') VALUES('R' 'C') +
                          MSGTYPE(*INQ) TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF         COND((&RPY *EQ 'R') *OR (&RPY *EQ 'r')) +
                          THEN(GOTO CMDLBL($03XX))
             RETURN
             ENDDO

             IF         (&PRTER *NE ' ') DO
             SNDPGMMSG  +
                          MSG('PLEASE HAND A-PICS TEMPORARY KANBAN DATA +
                          ERROR LIST TO BOSS AT PRODUCTION ENGINEERING +
                          SECTION.') TOMSGQ(QSYSOPR)
             ENDDO

             DLTOVR     FILE(QPRINT)
             ENDDO

             /*----------------------*/
             /*   ONLY KUMAMOTO FACTORY   */
             /*----------------------*/
             IF         (&PB9431 *NE '    ') DO

             CHKOBJ     OBJ(AFAWP33) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(TWFILE1/AFAWP33) RCDLEN(250) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          AUT(*ALL))

             /*--------------------------*/
             /*     UNWORKING NIGHT ATTENDANCE    DATA   */
             /*   ONLY KUMAMOTO FACTORY. */
             /*--------------------------*/
 $04XX:      CHGVAR     VAR(&PRTER) VALUE(' ')
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
             CLRPFM     FILE(AFAWP33)
             CALL       PGM(AFAR33) PARM(&DAY &PB9431 &PI9431 &PRTER)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDUSRMSG  +
                          MSG('ERROR AT PGM(AFAR33) +
                          < RETRY-R +
                          CANCEL-C >') VALUES('R' 'C') +
                          MSGTYPE(*INQ) TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF         COND((&RPY *EQ 'R') *OR (&RPY *EQ 'r')) +
                          THEN(GOTO CMDLBL($04XX))
             RETURN
             ENDDO

             IF         (&PRTER *NE ' ') DO
             SNDPGMMSG  +
                          MSG('PLEASE HAND A-PICS TEMPORARY KANBAN DATA +
                          ERROR LIST TO BOSS AT PRODUCTION ENGINEERING +
                          SECTION.') TOMSGQ(QSYSOPR)
             ENDDO
             DLTOVR     FILE(QPRINT)

             CHKOBJ     OBJ(AFAWP34) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(TWFILE1/AFAWP34) RCDLEN(250) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          AUT(*ALL))

             /*------------------------------------*/
             /*   LEVELLED PRODUCTION DECISION ORDERING ACCUMULATION FILE   */
             /* UNWORKING NIGHT  ATTENDANCE DATA */
             /*   ONLY KUMAMOTO FACTORY.       */
             /*------------------------------------*/
 $05XX:      CLRPFM     FILE(AFAWP34)
             CLRPFM     FILE(AFANP34)

             CHGVAR     VAR(&PCONT) VALUE(' ')
             CALL       PGM(AFAR34) PARM(&DAY &PB9431 &PI9431 &PCONT)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDUSRMSG  +
                          MSG('ERROR AT PGM(AFAR34) +
                          < RETRY-R +
                          CANCEL-C >') VALUES('R' 'C') +
                          MSGTYPE(*INQ) TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF         COND((&RPY *EQ 'R') *OR (&RPY *EQ 'r')) +
                          THEN(GOTO CMDLBL($05XX))
             RETURN
             ENDDO

             /*----------------------------------------*/
             /*    A-PICS UNWORKING NIGHT ATTENDANCE DATA   */
             /*   CONTAINER DATA  OF KUMAMOTO FACTORY DELETE.*/
             /*----------------------------------------*/
 $05XX1:     IF         (&PCONT *NE ' ') DO
             CALL       PGM(AFAR29) PARM(&PCONT)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDUSRMSG  +
                          MSG('ERROR AT PGM(AFAR29) +
                          < RETRY-R +
                          CANCEL-C >') VALUES('R' 'C') +
                          MSGTYPE(*INQ) TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF         COND((&RPY *EQ 'R') *OR (&RPY *EQ 'r')) +
                          THEN(GOTO CMDLBL($05XX1))
             RETURN
             ENDDO
             ENDDO

             CHKOBJ     OBJ(AFAWP35) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(TWFILE1/AFAWP35) RCDLEN(250) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          AUT(*ALL))
             CLRPFM     FILE(AFAWP35)

             FMTDTA     INFILE((AFAWP34)) OUTFILE(AFAWP35) +
                          SRCFILE(FMTSRC) SRCMBR(AFAS35) OPTION(*NOPRT)

             /*--------------------------------------------*/
             /* LEVELLED PRODUCTION FIXED ORDERING ACCUMULATION DATA +
                                    NUMBER OF SHEETS TOTAL */
             /*--A-PICS-- ONLY KUMAMOTO FACTORY          */
             /*--------------------------------------------*/
 $051X:      CALL       PGM(AFAR35)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDUSRMSG  +
                          MSG('ERROR AT PGM(AFAR35) +
                          < RETRY-R +
                          CANCEL-C >') VALUES('R' 'C') +
                          MSGTYPE(*INQ) TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF         COND((&RPY *EQ 'R') *OR (&RPY *EQ 'r')) +
                          THEN(GOTO CMDLBL($051X))
             RETURN
             ENDDO
             ENDDO

             CHKOBJ     OBJ(AFAWP13) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(TWFILE1/AFAWP13) RCDLEN(250) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          AUT(*ALL))
             CLRPFM     FILE(AFAWP13)

             FMTDTA     INFILE((AFAWP12)) OUTFILE(AFAWP13) +
                          SRCFILE(FMTSRC) SRCMBR(AFAS12) OPTION(*NOPRT)

             CHKOBJ     OBJ(AFAWP14) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(TWFILE1/AFAWP14) RCDLEN(250) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          AUT(*ALL))

@05XX:       CLRPFM     FILE(AFAWP14)
             CHGVAR     VAR(&PMSG) VALUE(' ')
             OVRPRTF    FILE(ATAPR95) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
             CALL       PGM(AFAR13) PARM(&PMSG &USER)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDUSRMSG  +
                          MSG('ERROR AT PGM(AFAR13) +
                          < RETRY-R +
                          CANCEL-C >') VALUES('R' 'C') +
                          MSGTYPE(*INQ) TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF         COND((&RPY *EQ 'R') *OR (&RPY *EQ 'r')) +
                          THEN(GOTO CMDLBL(@05XX))
             RETURN
             ENDDO

             IF         (&PMSG *EQ '*') DO
             SNDPGMMSG  +
                          MSG('IT IS LOOPED DELIVERY DATE CALCULATION +
                          FOR PRODUCT INSTRUCTION DATA. PLEASE HAND +
                          DELIVERY DATE CALCULATION IMPOSSIBLE DETAILS +
                          LIST TO BOSS AT PRODUCTION ENGINEERING SECTION.') +
                          TOMSGQ(QSYSOPR)
             ENDDO
             DLTOVR     FILE(ATAPR95)

             /*----------------------------------------*/
             /* OUTF1  -> IAF FACTORY                 */
             /* OUTF2  -> KUMAMOTO FACTORY            */
             /*----------------------------------------*/
             CHGVAR     VAR(&FL0111) VALUE('         ')
             CHGVAR     VAR(&FL9431) VALUE('         ')

             /*----------------------------------*/
             /*.NO PURCHASING(0111) */
             /*----------------------------------*/
             IF         (&PB0111 *EQ '    ') DO

             CHKOBJ     OBJ(AAA011199) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(TFILE1/AAA011199) RCDLEN(256) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          AUT(*ALL))
             CLRPFM     FILE(AAA011199)
             OVRDBF     FILE(OUTF1) TOFILE(AAA011199)
             ENDDO

             /*--------------------------------------*/
             /* NO KUMAMOTO FACTORY(9431)*/
             /*--------------------------------------*/
             IF         (&PB9431 *EQ '    ') DO

             CHKOBJ     OBJ(AAA943199) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(TFILE1/AAA943199) RCDLEN(256) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          AUT(*ALL))
             CLRPFM     FILE(AAA943199)
             OVRDBF     FILE(OUTF2) TOFILE(AAA943199)
             ENDDO

             /*------------------*/
             /*   IAF FACTORY   */
             /*------------------*/
             IF         (&PB0111 *NE '    ') DO

             CHGVAR     VAR(&FL0111) VALUE('AAA0111' *TCAT &PI0111)
             CHKOBJ     OBJ(&FL0111) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(TFILE1/&FL0111) RCDLEN(256) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          AUT(*ALL))
             CLRPFM     FILE(&FL0111)
             OVRDBF     FILE(OUTF1) TOFILE(&FL0111)
             ENDDO

             /*------------------*/
             /*   KUMAMOTO FACTORY   */
             /*------------------*/
             IF         (&PB9431 *NE '    ') DO

             CHGVAR     VAR(&FL9431) VALUE('AAA9431' *TCAT &PI9431)
             CHKOBJ     OBJ(&FL9431) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(TFILE1/&FL9431) RCDLEN(256) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          AUT(*ALL))
             CLRPFM     FILE(&FL9431)
             OVRDBF     FILE(OUTF2) TOFILE(&FL9431)
             ENDDO

             /*------------------*/
             /*   IAF FACTORY   */
             /*------------------*/
             IF         (&PB0111 *NE '    ') DO

             CHKOBJ     OBJ(AFAWP15) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(TWFILE1/AFAWP15) RCDLEN(250) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          AUT(*ALL))

             CHKOBJ     OBJ(AFAWP01111) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(TWFILE1/AFAWP01111) RCDLEN(250) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          AUT(*ALL))

             CHKOBJ     OBJ(AFAWP01112) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(TWFILE1/AFAWP01112) RCDLEN(250) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          AUT(*ALL))

             CHKOBJ     OBJ(AFAWP01113) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(TWFILE1/AFAWP01113) RCDLEN(250) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          AUT(*ALL))

             CHKOBJ     OBJ(AFAWP01114) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(TWFILE1/AFAWP01114) RCDLEN(250) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          AUT(*ALL))

             CHKOBJ     OBJ(AFAWP01115) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(TWFILE1/AFAWP01115) RCDLEN(250) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          AUT(*ALL))

             CLRPFM     FILE(AFAWP15)
             CLRPFM     FILE(AFAWP01111)
             CLRPFM     FILE(AFAWP01112)
             CLRPFM     FILE(AFAWP01113)
             CLRPFM     FILE(AFAWP01114)
             CLRPFM     FILE(AFAWP01115)

             FMTDTA     INFILE((AFAWP14)) OUTFILE(AFAWP01111) +
                          SRCFILE(FMTSRC) SRCMBR(AFASIA) OPTION(*NOPRT)

             FMTDTA     INFILE((AFAWP01111)) OUTFILE(AFAWP01112) +
                          SRCFILE(FMTSRC) SRCMBR(AFASIB) OPTION(*NOPRT)

             FMTDTA     INFILE((AFAWP01111)) OUTFILE(AFAWP01113) +
                          SRCFILE(FMTSRC) SRCMBR(AFASIC) OPTION(*NOPRT)

             FMTDTA     INFILE((AFAWP01111)) OUTFILE(AFAWP01114) +
                          SRCFILE(FMTSRC) SRCMBR(AFASID) OPTION(*NOPRT)

             FMTDTA     INFILE((AFAWP01111)) OUTFILE(AFAWP01115) +
                          SRCFILE(FMTSRC) SRCMBR(AFASIE) OPTION(*NOPRT)

             CPYF       FROMFILE(AFAWP01112) TOFILE(AFAWP15) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)

             CPYF       FROMFILE(AFAWP01113) TOFILE(AFAWP15) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)

             CPYF       FROMFILE(AFAWP01114) TOFILE(AFAWP15) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)

             CPYF       FROMFILE(AFAWP01115) TOFILE(AFAWP15) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)

             CHGVAR     VAR(&CNT) VALUE(0)
             CALL       PGM(AFAR17) PARM(&CNT)
             IF         COND(&CNT = 0) THEN(GOTO CMDLBL(@0602))

 @0601XX:    CALL       PGM(AFAR14)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDUSRMSG  +
                          MSG('ERROR PGM(AFAR14) HANDLING +
                          IAF(0111) DATA. +
                          < RETRY-R +
                          CANCEL-C >') VALUES('R' 'C') +
                          MSGTYPE(*INQ) TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF         COND((&RPY *EQ 'R') *OR (&RPY *EQ 'r')) +
                          THEN(GOTO CMDLBL(@0601XX))
             RETURN
             ENDDO
             ENDDO

             /*------------------*/
             /*   KUMAMOTO FACTORY   */
             /*------------------*/
 @0602:      IF         (&PB9431 *NE '    ') DO

             CHKOBJ     OBJ(AFAWP15) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(TWFILE1/AFAWP15) RCDLEN(250) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          AUT(*ALL))
             CHKOBJ     OBJ(AFAWP94311) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(TWFILE1/AFAWP94311) RCDLEN(250) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          AUT(*ALL))
             CHKOBJ     OBJ(AFAWP94312) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(TWFILE1/AFAWP94312) RCDLEN(250) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          AUT(*ALL))

             CLRPFM     FILE(AFAWP15)
             CLRPFM     FILE(AFAWP94311)
             CLRPFM     FILE(AFAWP94312)

             FMTDTA     INFILE((AFAWP14)) OUTFILE(AFAWP94311) +
                          SRCFILE(FMTSRC) SRCMBR(AFASMA) OPTION(*NOPRT)
             FMTDTA     INFILE((AFAWP14)) OUTFILE(AFAWP94312) +
                          SRCFILE(FMTSRC) SRCMBR(AFASMB) OPTION(*NOPRT)

             CPYF       FROMFILE(AFAWP94312) TOFILE(AFAWP94311) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)

             FMTDTA     INFILE((AFAWP94311)) OUTFILE(AFAWP15) +
                          SRCFILE(FMTSRC) SRCMBR(AFAS28) OPTION(*NOPRT)

             CHGVAR     VAR(&CNT) VALUE(0)
             CALL       PGM(AFAR17) PARM(&CNT)
             IF         COND(&CNT = 0) THEN(GOTO CMDLBL(@07))

 @0602XX:    CALL       PGM(AFAR14)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDUSRMSG  +
                          MSG('ERROR PGM(AFAR14) HANDLING +
                          KUMAMOTO(9431) DATA. +
                          < RETRY-R +
                          CANCEL-C >') VALUES('R' 'C') +
                          MSGTYPE(*INQ) TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF         COND((&RPY *EQ 'R') *OR (&RPY *EQ 'r')) +
                          THEN(GOTO CMDLBL(@0602XX))
             RETURN
             ENDDO
             ENDDO

 @07:        CALL       PGM(AFAR15) PARM(&PB0111 &PI0111 &PB9431 +
                          &PI9431)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDUSRMSG  +
                          MSG('ERROR AT PGM(AFAR15) +
                          < RETRY-R +
                          CANCEL-C >') VALUES('R' 'C') +
                          MSGTYPE(*INQ) TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF         COND((&RPY *EQ 'R') *OR (&RPY *EQ 'r')) +
                          THEN(GOTO CMDLBL(@07))
             RETURN
             ENDDO

             /*----------------------------------------------*/
             /* SETUP FILE UPDATE WITH ARRS FIXED ORDERING FILE */
             /*----------------------------------------------*/
 @08:        CALL       PGM(OBFR10)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDUSRMSG  MSG('ERROR AT PGM(OBFR10), +
                          CONTACT YOU TO HAYAKAWA. ...+
                          ERROR IGNORED--EXECUTION ') MSGTYPE(*INFO) +
                          TOMSGQ(QSYSOPR)
             ENDDO

             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000)

             /*------------------------------------------*/
             /*REORGANIZATION OF ACCUMULATION FILE FOR  ..A-PICS ORDERING   */
             /*------------------------------------------*/
             IF         (&CTIME *EQ '0800') DO

             CLRPFM     FILE(AU#NP16)
             CALL       PGM(AFAR16)

             CLRPFM     FILE(AU#PP11)
             CPYF       FROMFILE(AU#NP16) TOFILE(AU#PP11) +
                          MBROPT(*REPLACE) FMTOPT(*MAP)
             MONMSG     MSGID(CPF2909 CPF2817)
             ENDDO

             SNDPGMMSG  +
                          MSG('PRODUCTION INSTRUCTION DATA CREATED +
                          .') TOMSGQ(QSYSOPR)

 END:        DLTDTAARA  DTAARA(TFILE1/AFAACT)

             SIGNOFF

 SEND:       ENDPGM
