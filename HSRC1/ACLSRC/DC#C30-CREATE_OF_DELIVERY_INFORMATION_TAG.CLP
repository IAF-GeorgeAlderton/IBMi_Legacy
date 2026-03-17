             PGM
             /*** DC#C30 ***********************************/
             /* CREATE OF DELIVERY INFORMATION TAG         */
             /*         AUTHOR.         S.OHTAKE.          */
             /*         CREATE DATE.    APR/09/1997        */
             /**********************************************/
             DCLF       FILE(DC#PW30)
             DCL        VAR(&US)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT)     TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&YMD)    TYPE(*DEC)  LEN(8)
             DCL        VAR(&QDATE)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&WORK)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&WYMD)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&FILE01) TYPE(*CHAR) LEN(9)
             DCL        VAR(&WYY)    TYPE(*DEC)  LEN(4)
             DCL        VAR(&WMM)    TYPE(*DEC)  LEN(2)
             DCL        VAR(&WDD)    TYPE(*DEC)  LEN(2)
             DCL        VAR(&HYY)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&HMM)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&HDD)    TYPE(*CHAR) LEN(2)

             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&QDATE)
             CVTDAT     DATE(&QDATE) TOVAR(&WORK) FROMFMT(*SYSVAL) +
                        TOFMT(*YYMD) TOSEP(*NONE)
             CHGVAR     VAR(&YMD)    VALUE(&WORK)
             CALL       PGM(CNVR11)  PARM(&YMD &W1DATE)
             CHGVAR     VAR(&WYMD)   VALUE(&YMD)
             CHGVAR     VAR(&WYY)    VALUE(%SST(&WYMD 1 4))
             CHGVAR     VAR(&WMM)    VALUE(%SST(&WYMD 5 2))
             CHGVAR     VAR(&WDD)    VALUE(%SST(&WYMD 7 2))
             CHGVAR     VAR(&HYY)    VALUE(&WYY)
             CHGVAR     VAR(&HMM)    VALUE(&WMM)
             CHGVAR     VAR(&HDD)    VALUE(&WDD)
             CHGVAR     VAR(&HIZK)   VALUE(&HMM *CAT &HDD *CAT &HYY)

             RTVJOBA    JOB(&WSID)    USER(&US)
             CHGVAR     VAR(&WT)      VALUE(%SST(&WSID 1 2))
             CALL       PGM(AGAR00)   PARM(&WSID &PRT &TYPE &PRTG)

             CHGVAR     VAR(&FILE01)  VALUE('DC#WP11' *CAT &WT)

 STEP1:      SNDRCVF    RCDFMT(DC#PW301)
             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')
             IF         (&IN01 *EQ '1')       GOTO END

             IF         COND(&HIZK *EQ '        ') THEN(DO)
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG)  VALUE('PLEASE INPUT THE DATE.')
             GOTO       STEP1
             ENDDO

             IF         (&IN05 *EQ '0')       GOTO STEP1

             DLTF       FILE(&FILE01)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE01) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(DC#WP11) OPTION(*NOSRC *NOLIST) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(DC#WP11) TOFILE(&FILE01)
             CALL       PGM(DC#R30) PARM(&HIZK)

             OVRPRTF    FILE(DC#PR13) DEVTYPE(*AFPDS) PAGESIZE(22 +
                          80) LPI(6) CPI(10) OVRFLW(21) +
                          RPLUNPRT(*YES '*') OUTQ(QPRINTA) +
                          FORMTYPE(I611)
             CALL       PGM(DC#R13)

             DLTOVR     FILE(DC#WP11)

 END:        ENDPGM
