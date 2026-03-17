             PGM
             /** ALDC81 ************************************/
             /* REFERENCE TO OUT-GOING TRACK RECORD        */
             /*       CREATE DATE : 1998.03.25.            */
             /*       CODING      : K.OKACHI               */
             /**********************************************/
             DCLF       FILE(ALDPW81) RCDFMT(ALDPW811)
             DCL        VAR(&US)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)

             DCL        VAR(&IN99) TYPE(*LGL) LEN(1)
             DCL        VAR(&SHIZ)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&QDATE)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&WORK)   TYPE(*CHAR) LEN(8)

  /*   YYYYMMDD  CONVERSION   */
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&QDATE)
             CVTDAT     DATE(&QDATE) TOVAR(&WORK) FROMFMT(*SYSVAL) +
                          TOFMT(*YYMD) TOSEP(*NONE)
             CHGVAR     VAR(&SHIZ) VALUE(&WORK)

             RTVJOBA    JOB(&WSID)   USER(&US)
             CALL       PGM(AGAR00)  PARM(&WSID &PRT &TYPE &PRTG)

STEP1:       SNDRCVF  DEV(&WSID) RCDFMT(ALDPW811)

             CHGVAR   VAR(&IN99) VALUE('0')
             IF       (&IN01 = '1')   GOTO    END

             IF       (&HIZ = '      ') GOTO STEP2
             IF       (&HIZ > %SST(&SHIZ 1 6))  GOTO STEP2
             IF       (&IN05 = '0')   GOTO    STEP1
             GOTO STEP3

STEP2:       CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE INPUT VALUE IS NOT +
                          CORRECT.')
             GOTO       STEP1

STEP3:       SNDPGMMSG  MSG('( G.C ) SET THE BACKUP TAPE IN '  +
                          *CAT &HIZ *CAT  ' < ALDPP30 >') +
                          TOMSGQ(QSYSOPR) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE = 'G') *OR (&KOTAE = 'g')) +
                          THEN(GOTO CMDLBL(STEP4))
             IF         COND((&KOTAE = 'C') *OR (&KOTAE = 'c')) +
                          THEN(GOTO CMDLBL(END))
             GOTO       STEP3

 STEP4:      RSTOBJ     OBJ(ALDWP81) SAVLIB(HWFILE1) DEV(TAP01) +
                          OBJTYPE(*FILE) ENDOPT(*UNLOAD) +
                          RSTLIB(IKOULIB)

             CLRPFM     FILE(HFILE1/ALDPP81)

             CPYF       FROMFILE(IKOULIB/ALDWP81) +
                          TOFILE(HFILE1/ALDPP81) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF2802 CPF2817)

 STEP5:      SNDPGMMSG  MSG('( G )REMOVE THE BACKUP TAPE < +
                          ALDPP30>') TOMSGQ(QSYSOPR) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE = 'G') *OR (&KOTAE = 'g')) +
                          THEN(GOTO CMDLBL(STEP6))
             GOTO       STEP5

 STEP6:      DLTF       FILE(IKOULIB/ALDWP81)
             MONMSG     MSGID(CPF3261 CPF2105)

             CALL ALDR81

             CLRPFM     FILE(HFILE1/ALDPP81)

END:         ENDPGM
