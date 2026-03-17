             PGM
             /*** EAEC30 ***********************************/
             /* ORDER RECEIPT PROD ORDER DATA INPUT                       CL */
             /*         M-OKUDA         1984.07.11         */
             /************************** COPY FROM EAEC30 **/
             DCLF       FILE(DC#PW01)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNO) TYPE(*CHAR) LEN(10)

             DCL        VAR(&FILE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WKY)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&WKM)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&WKD)   TYPE(*CHAR) LEN(2)

             DCL        VAR(&DTA7) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SHIZ6) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SHIZK) TYPE(*CHAR) LEN(8)
             DCL        VAR(&ORDD)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&SHID)  TYPE(*CHAR) LEN(8)

             DCL        (&IN91) TYPE(*LGL) LEN(1)
             DCL        (&IN92) TYPE(*LGL) LEN(1)
             DCL        (&IN93) TYPE(*LGL) LEN(1)
             DCL        (&IN99) TYPE(*LGL) LEN(1)

             DCL        VAR(&WT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PLIST) TYPE(*CHAR) LEN(1)
             DCL        VAR(&USS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PSYS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7) VALUE(QPRINT )
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)

             /*.......DATA ENTRY ................................*/
             RTVNETA    SYSNAME(&PSYS)
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&SHIZ6)
             CHGVAR     VAR(&WKY)    VALUE(%SST(&SHIZ6 1 2))
             CHGVAR     VAR(&WKM)    VALUE(%SST(&SHIZ6 3 2))
             CHGVAR     VAR(&WKD)    VALUE(%SST(&SHIZ6 5 2))
             CHGVAR     VAR(%SST(&SHIZK 1 2))  VALUE(&WKM)
             CHGVAR     VAR(%SST(&SHIZK 3 2))  VALUE(&WKD)
             CHGVAR     VAR(%SST(&SHIZK 5 2))  VALUE('19')
             CHGVAR     VAR(%SST(&SHIZK 7 2))  VALUE(&WKY)
             IF         COND(&WKY < '81') THEN(CHGVAR +
                          VAR(%SST(&SHIZK 5 2)) VALUE('20'))
             CHGVAR     VAR(&ORDDAT) VALUE(&SHIZK)

             CHGJOB     RUNPTY(30) SWS(00000000)
             RTVJOBA    JOB(&WSID) USER(&US) NBR(&JOBNO)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)


             CHGVAR     VAR(&WT) VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&USS) VALUE(%SST(&US 1 2))



 STEP1:      SNDRCVF    RCDFMT(DC#PW011)
             IF         (&IN01 *EQ '1')       GOTO END
             CHGVAR     VAR(&IN99) VALUE('0')
             CHGVAR     VAR(&IN91) VALUE('0')
             CHGVAR     VAR(&IN92) VALUE('0')
             CHGVAR     VAR(&IN93) VALUE('0')
             CHGVAR     VAR(&IN94) VALUE('0')

             CHGVAR     VAR(&IN91) VALUE('1')
             CHGVAR     &ORDD     &ORDDAT
             IF       (&ORDD   < &SHIZK) GOTO STEP0S
             IF       (%SUBSTRING(&ORDD   5 4) < '1981') GOTO STEP7
             IF       (%SUBSTRING(&ORDD   1 2) < '01') GOTO STEP9
             IF       (%SUBSTRING(&ORDD   1 2) > '12') GOTO STEP10
             IF       (%SUBSTRING(&ORDD   3 2) < '01') GOTO STEP11
             IF       (%SUBSTRING(&ORDD   3 2) > '31') GOTO STEP12
             CHGVAR     VAR(&IN91) VALUE('0')

             IF         COND((&INTYPE *NE 'A') *AND (&INTYPE *NE +
                          'B')) THEN(GOTO CMDLBL(STEP32))

             CHGVAR     VAR(&IN93) VALUE('1')
             CHGVAR     VAR(&SHID) VALUE('00000000')
             IF       (&SHIDAT *NE 0 ) DO
             CHGVAR     &SHID     &SHIDAT
             IF       (%SUBSTRING(&SHID   5 4) < '1981') GOTO STEP7
             IF       (%SUBSTRING(&SHID   1 2) < '01') GOTO STEP9
             IF       (%SUBSTRING(&SHID   1 2) > '12') GOTO STEP10
             IF       (%SUBSTRING(&SHID   3 2) < '01') GOTO STEP11
             IF       (%SUBSTRING(&SHID   3 2) > '31') GOTO STEP12
             ENDDO
             CHGVAR     VAR(&IN93) VALUE('0')

             IF         (&PASWRD *EQ '     ') GOTO STEP30
             IF       (%SST(&PASWRD 1 1) *EQ ' ') GOTO STEP30
             IF       (%SST(&PASWRD 2 1) *EQ ' ') GOTO STEP30
             IF       (%SST(&PASWRD 3 1) *EQ ' ') GOTO STEP30
             IF       (%SST(&PASWRD 4 1) *EQ ' ') GOTO STEP30
             IF       (%SST(&PASWRD 5 1) *EQ ' ') GOTO STEP30
             GOTO     STEP13

 /*------------------------------------------------------------*/
 STEP0S:     CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE INPUT DATE IS BEING  PAST +
                                         CHANGE IT ')
             GOTO STEP1

 STEP7:      CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('INPUT THE DATE SMALLER THAN 81')
             GOTO STEP1

 STEP9:      CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE MONTH OF INPUT DATE IS +
                                         SMALLER THAN 01.CHANGE IT')
             GOTO       STEP1

 STEP10:     CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE MONTH OF INPUT DATE IS BIGGER +
                                         THAN 12.CHANGE IT')
             GOTO       STEP1

 STEP11:     CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE DAY OF INPUT DATE IS +
                                         SMALLER THAN 01.CHANGE IT')
             GOTO       STEP1

 STEP12:     CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE DAY OF INPUT DATE IS BIGGER +
                                         THAN 31.CHANGE IT')
             GOTO       STEP1

 /*------------------------------------------------------------*/
 STEP30:     CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&IN94) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('PERSON IN CHARGE CODE IS NOT +
                                         INPUT JUSTLY.INPUT IT')
             GOTO       STEP1

 STEP31:     CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&IN94) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('PERSON IN CHARGE CODE IS INPUT WITH +
                                         ONLY NUMBER.INPUT IT')
             GOTO       STEP1

 /*------------------------------------------------------------*/
 STEP32:     CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&IN92) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE INPUT DATA INSTRUCTION IS WRONG+
                        (INST+PROD ODR=T,INST=S)')
             GOTO       STEP1

 /*------------------------------------------------------------*/
 STEP13:

             CHGVAR     VAR(%SUBSTRING(&DTA7 1 2)) VALUE('JY')
             CHGVAR     VAR(%SUBSTRING(&DTA7 3 5)) VALUE(&PASWRD)

             CHKOBJ     OBJ(&DTA7) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STEP21))
 STEP22:     SNDPGMMSG  MSG('(G)IT IS NOT IMPOSSIBLE TO INPUT ORDER RECEIPT +
                          BY 2 TV SETS') TOMSGQ(&WSID) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         (&KOTAE *EQ 'G') GOTO END
             GOTO       STEP22

 STEP21:     CRTDTAARA  DTAARA(AOYAMA/&DTA7) TYPE(*CHAR) LEN(4) +
                     TEXT('ORDER RECEIPT INPUT TWICE HANDLING PREVENTED CHECK')



 STEP14:

             CHGVAR     VAR(&FILE1) VALUE('DC#W' *CAT &PASWRD *CAT '1')
             CHGVAR     VAR(&FILE2) VALUE('DC#W' *CAT &PASWRD *CAT '2')

             CHKOBJ     OBJ(&FILE1) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO STEP14A)
             DLTF       FILE(AOYAMA/&FILE1)
 STEP14A:
             CHKOBJ     OBJ(&FILE2) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO STEP14B)
             DLTF       FILE(AOYAMA/&FILE2)
 STEP14B:

             CRTDUPOBJ  OBJ(DC#WP10) FROMLIB(AOYAMA) OBJTYPE(*FILE) +
                          TOLIB(AOYAMA) NEWOBJ(&FILE1)
             CRTDUPOBJ  OBJ(DC#WP11) FROMLIB(AOYAMA) OBJTYPE(*FILE) +
                          TOLIB(AOYAMA) NEWOBJ(&FILE2)
             OVRDBF     FILE(DC#WP10) TOFILE(AOYAMA/&FILE1)
             OVRDBF     FILE(DC#WP11) TOFILE(AOYAMA/&FILE2)


             CALL PGM(DC#R10) PARM(&ORDD &PASWRD)

             SNDF       RCDFMT(DC#PW012)
             CALL PGM(DC#R11) PARM(&US &SHID)
             CALL PGM(DC#R12) PARM(&US &SHID)

             CALL PGM(DC#R13)

             DLTOVR     FILE(DC#WP10)
             DLTOVR     FILE(DC#WP11)
             DLTF       (AOYAMA/&FILE1)
             DLTDTAARA  DTAARA(&DTA7)
             /*.......END .......................................*/

 END:        CHGJOB     RUNPTY(20)

             ENDPGM
