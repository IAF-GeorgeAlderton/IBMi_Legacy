             PGM
             /** MCEC70 ***************************/
             /* COMPONENT ACTUAL USED  TOTALIZATION LIST CREATE */
             /* A-IDOTA            1981.10.10     */
             /*************************** MCEC70 **/
             DCLF       FILE(MCEPW70) RCDFMT(MCEPW701)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(60)
             DCL        VAR(&IN99) TYPE(*LGL) LEN(1)
             DCL        VAR(&HIZU) TYPE(*CHAR) LEN(6)
             DCL        VAR(&KBN) TYPE(*CHAR) LEN(3)
             RTVJOBA    JOB(&WSID)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

 STEP1:      SNDRCVF    DEV(&WSID) RCDFMT(MCEPW701)
             IF         (&IN01 = '1') GOTO END
             CHGVAR     VAR(&IN99) VALUE('0')
             IF       COND((&HIZU < '198109')) THEN(CHGVAR VAR(&IN99) +
                          VALUE('1'))
             IF       COND(&HIZU < '198109') THEN(CHGVAR VAR(&MSG) +
                          VALUE('INPUT DATE IS SMALL,INPUT IT'))
             IF       (&HIZU < '198109') GOTO STEP1

             IF       COND(&KBN = '   ') THEN(CHGVAR VAR(&IN99) +
                          VALUE('1'))
             IF       COND(&KBN = '   ') THEN(CHGVAR VAR(&MSG) +
                          VALUE('INPUT MACHINE NO.'))
             IF       COND(&KBN = '   ') THEN(GOTO CMDLBL(STEP1))

 STEP2:      DLTF       FILE(MCEWP70)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(MCEWP71)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTPF      FILE(HWFILE1/MCEWP70) RCDLEN(50) +
                          OPTION(*NOLIST) SIZE(20000 3000)
             CALL       PGM(MCER70) PARM(&HIZU &KBN)

             IF         COND(%SWITCH(0XXXXXXX)) THEN(DO)
             DLTF       FILE(MCEWP70)
             GOTO       CMDLBL(END)
             ENDDO

             CRTPF      FILE(HWFILE1/MCEWP71) RCDLEN(50) +
                          OPTION(*NOLIST) SIZE(20000 3000)
             FMTDTA     INFILE((HWFILE1/MCEWP70)) +
                          OUTFILE(HWFILE1/MCEWP71) SRCFILE(FMTSRC) +
                          SRCMBR(MCES33) OPTION(*NOPRT)

             CLRPFM     FILE(MCENP70)
             CALL       PGM(MCER71) PARM(&HIZU)
             DLTF       FILE(MCEWP70)
             DLTF       FILE(MCEWP71)

             CALL       PGM(MCER72) PARM(&HIZU &KBN)

 END:        ENDPGM
