             PGM
             /*** DC#C40 ***********************************/
             /* DELIVERY INFORMATION / SUBJECT PARTS TAG   */
             /*          REPUBLICATION (WORKSTATION)       */
             /*         AUTHOR.         S.OHTAKE.          */
             /*         CREATE DATE.    APR/10/1997        */
             /**********************************************/
             DCLF       FILE(DC#PW40)
             DCL        VAR(&US)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&YMD)    TYPE(*DEC)  LEN(8)
             DCL        VAR(&QDATE)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&WORK)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&FILE1)  TYPE(*CHAR) LEN(10)
             DCL        (&IN02)      TYPE(*LGL)  LEN(1)
             DCL        (&IN99)      TYPE(*LGL)  LEN(1)

             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&QDATE)
             CVTDAT     DATE(&QDATE) TOVAR(&WORK) FROMFMT(*SYSVAL) +
                        TOFMT(*YYMD) TOSEP(*NONE)
             CHGVAR     VAR(&YMD)    VALUE(&WORK)
             CALL       PGM(CNVR11)  PARM(&YMD &W1DATE)

             RTVJOBA    JOB(&WSID)  USER(&US)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

 STEP1:      SNDRCVF    RCDFMT(DC#PW401)
             IF         (&IN01 *EQ '1')       GOTO END
             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         COND(&WRKSTATN *EQ '  ') THEN(DO)
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('PLEASE INPUT THE +
                          WORKSTATION NO.')
             GOTO       STEP1
             ENDDO

             CHGVAR     VAR(&FILE1) VALUE('DC#WP11' *CAT &WRKSTATN)

             CHKOBJ     OBJ(HWFILE1/&FILE1) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(ERRTAG))
             GOTO JUMP

 ERRTAG:     CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THERE IS NO DATA INPUT FROM +
                          THIS WORKSTATION NO.')
             GOTO       STEP1

 JUMP:       IF         (&IN05 *EQ '0')       GOTO STEP1
             OVRDBF     FILE(DC#WP11) TOFILE(HWFILE1/&FILE1)

             OVRPRTF    FILE(DC#PR13) DEVTYPE(*AFPDS) PAGESIZE(22 80 +
                          *ROWCOL) LPI(6) CPI(10) OVRFLW(21) +
                          RPLUNPRT(*YES '*') OUTQ(QPRINTA) +
                          FORMTYPE(I611) IGCDTA(*NO)
             CALL       PGM(DC#R13)

             DLTOVR     FILE(DC#WP11)

 END:        ENDPGM
