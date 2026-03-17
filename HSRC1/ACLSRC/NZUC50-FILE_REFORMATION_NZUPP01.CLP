             PGM        PARM(&WFILE &WLIBR &WNUKI &WSKRE &WSKHI)
             /** NZUC50 ************************************/
             /* FILE REFORMATION - NZUPP01             */
             /*        A.HOTTA             2014.04.23      */
             /*  JW1: J-WATANABE             2016.06.02    */
             /**********************************************/
             DCLF       FILE(NZUPW50) RCDFMT(NZUPW501)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&IN99) TYPE(*LGL) LEN(1)
             DCL        VAR(&IN91) TYPE(*LGL) LEN(1)
             DCL        VAR(&IN01) TYPE(*LGL) LEN(1)
             DCL        VAR(&HYMD) TYPE(*CHAR) LEN(8)
             DCL        VAR(&HY) TYPE(*CHAR) LEN(4)
             DCL        VAR(&HM) TYPE(*CHAR) LEN(2)
             DCL        VAR(&HD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WFILE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&WLIBR) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WNUKI) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WSKRE) TYPE(*CHAR) LEN(3)
             DCL        VAR(&WSKHI) TYPE(*CHAR) LEN(3)
             DCL        VAR(&WKTIM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WSTIM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WRECD) TYPE(*CHAR) LEN(9)
             DCL        VAR(&WKENS) TYPE(*CHAR) LEN(9)

             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&LIBL)   TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSNO) USER(&USER)
             RTVJOBA    DATE(&DATE)
             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)

           /*--JW1---------------------------------------*/
           /*    CHECK ENVIRONMENT                        */
           /*--------------------------------------------*/
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

           /*--JW1---------------------------------------*/
           /*    ACTIVE CHECK                            */
           /*--------------------------------------------*/
             CHKOBJ     OBJ(&WLIB/NZUC50ACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(VTP1))

 VTP2:       SNDPGMMSG  MSG('( G ) OTHER MASTER FILES ARE BEING +
                          REORGANIZED. PLEASE WAIT FOR A WHILE. ') +
                          TOMSGQ(&WSNO) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE *NE 'G') *AND (&KOTAE *NE 'g')) +
                          THEN(GOTO CMDLBL(VTP2))
             GOTO       SEND

 VTP1:       CRTDTAARA  DTAARA(&WLIB/NZUC50ACT) TYPE(*CHAR) LEN(10) +
                          AUT(*ALL)

 STEP02:     CHGJOB     OUTQ(&PRTG)
             CHGVAR     VAR(%SST(&@YMDB 1 8)) VALUE(&WNUKI)
             CHGVAR     VAR(%SST(&@YMDB 9 2)) VALUE('99')
             CHGVAR     VAR(&@DATE) VALUE(&DATE)

 ERR:        SNDRCVF    RCDFMT(NZUPW501)
             CHGVAR     VAR(&IN99) VALUE('0')
             CHGVAR     VAR(&@ERR) VALUE('                            -
                                ')

             IF (&IN01 *EQ '1') GOTO ENDMA

             CHGVAR     VAR(&HYMD) VALUE(%SST(&@YMDB 1 8))
             CHGVAR     VAR(&HY)   VALUE(%SST(&@YMDB 1 4))
             CHGVAR     VAR(&HM)   VALUE(%SST(&@YMDB 5 2))
             CHGVAR     VAR(&HD)   VALUE(%SST(&@YMDB 7 2))

             IF  (&@YMDB  *EQ '          ') DO
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&@ERR) VALUE('THE DATE IS NOT INPUT.')
             GOTO ERR
             ENDDO

             IF  (&@YMDB  *EQ '0000000000') DO
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&@ERR) VALUE('THE DATE IS NOT INPUT.')
             GOTO ERR
             ENDDO

             IF  (&@YMDB  *EQ '9999999999') DO
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&@ERR) VALUE('THE INPUT VALUE IN NOT +
                          CORRECT')
             GOTO ERR
             ENDDO

     /**************************/
     /*  日付チエック        */
     /**************************/
     /*  01   */
           IF (&HM   *EQ '01')  DO
             IF (&HD  *LT '01') DO
                CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&@ERR) VALUE('LOGICAL ERROR AT DATE')
                GOTO ERR
             ENDDO
             IF (&HD  *GT '31') DO
                CHGVAR     VAR(&IN99) VALUE('1')
                CHGVAR   VAR(&@ERR) VALUE('LOGICAL ERROR AT DATE')
                GOTO ERR
             ENDDO
           ENDDO

     /*  02   */
           IF (&HM   *EQ '02')  DO
             IF (&HD  *LT '01') DO
                CHGVAR     VAR(&IN99) VALUE('1')
                CHGVAR   VAR(&@ERR) VALUE('LOGICAL ERROR AT DATE')
                GOTO ERR
             ENDDO
             IF (&HY *EQ '88') GOTO UROU
             IF (&HY *EQ '92') GOTO UROU
             IF (&HY *EQ '96') GOTO UROU
                IF (&HD  *GT '28') DO
                   CHGVAR     VAR(&IN99) VALUE('1')
                   CHGVAR   VAR(&@ERR) VALUE('LOGICAL ERROR AT DATE')
                   GOTO ERR
                   GOTO PAS
                 ENDDO

 UROU:          IF (&HD  *GT '29') DO
                   CHGVAR     VAR(&IN99) VALUE('1')
                   CHGVAR   VAR(&@ERR) VALUE('LOGICAL ERROR AT DATE')
                   GOTO ERR
                 ENDDO
           ENDDO

     /*  03   */
           IF (&HM   *EQ '03')  DO
             IF (&HD  *LT '01') DO
                CHGVAR     VAR(&IN99) VALUE('1')
                CHGVAR   VAR(&@ERR) VALUE('LOGICAL ERROR AT DATE')
                GOTO ERR
             ENDDO
             IF (&HD  *GT '31') DO
                CHGVAR     VAR(&IN99) VALUE('1')
                CHGVAR   VAR(&@ERR) VALUE('LOGICAL ERROR AT DATE')
                GOTO ERR
             ENDDO
           ENDDO

     /*  04   */
           IF (&HM   *EQ '04')  DO
             IF (&HD  *LT '01') DO
                CHGVAR     VAR(&IN99) VALUE('1')
                CHGVAR   VAR(&@ERR) VALUE('LOGICAL ERROR AT DATE')
                GOTO ERR
             ENDDO
             IF (&HD  *GT '30') DO
                CHGVAR     VAR(&IN99) VALUE('1')
                CHGVAR   VAR(&@ERR) VALUE('LOGICAL ERROR AT DATE')
                GOTO ERR
             ENDDO
           ENDDO

     /*  05   */
           IF (&HM   *EQ '05')  DO
             IF (&HD  *LT '01') DO
                CHGVAR     VAR(&IN99) VALUE('1')
                CHGVAR   VAR(&@ERR) VALUE('LOGICAL ERROR AT DATE')
                GOTO ERR
             ENDDO
             IF (&HD  *GT '31') DO
                CHGVAR     VAR(&IN99) VALUE('1')
                CHGVAR   VAR(&@ERR) VALUE('LOGICAL ERROR AT DATE')
                GOTO ERR
             ENDDO
           ENDDO

     /*  06   */
           IF (&HM   *EQ '06')  DO
             IF (&HD  *LT '01') DO
                CHGVAR     VAR(&IN99) VALUE('1')
                CHGVAR   VAR(&@ERR) VALUE('LOGICAL ERROR AT DATE')
                GOTO ERR
             ENDDO
             IF (&HD  *GT '30') DO
                CHGVAR     VAR(&IN99) VALUE('1')
                CHGVAR   VAR(&@ERR) VALUE('LOGICAL ERROR AT DATE')
                GOTO ERR
             ENDDO
           ENDDO

     /*  07   */
           IF (&HM   *EQ '07')  DO
             IF (&HD  *LT '01') DO
                CHGVAR     VAR(&IN99) VALUE('1')
                CHGVAR   VAR(&@ERR) VALUE('LOGICAL ERROR AT DATE')
                GOTO ERR
             ENDDO
             IF (&HD  *GT '31') DO
                CHGVAR     VAR(&IN99) VALUE('1')
                CHGVAR   VAR(&@ERR) VALUE('LOGICAL ERROR AT DATE')
                GOTO ERR
             ENDDO
           ENDDO

     /*  08   */
           IF (&HM   *EQ '08')  DO
             IF (&HD  *LT '01') DO
                CHGVAR     VAR(&IN99) VALUE('1')
                CHGVAR   VAR(&@ERR) VALUE('LOGICAL ERROR AT DATE')
                GOTO ERR
             ENDDO
             IF (&HD  *GT '31') DO
                CHGVAR     VAR(&IN99) VALUE('1')
                CHGVAR   VAR(&@ERR) VALUE('LOGICAL ERROR AT DATE')
                GOTO ERR
             ENDDO
           ENDDO

     /*  09   */
           IF (&HM   *EQ '09')  DO
             IF (&HD  *LT '01') DO
                CHGVAR     VAR(&IN99) VALUE('1')
                CHGVAR   VAR(&@ERR) VALUE('LOGICAL ERROR AT DATE')
                GOTO ERR
             ENDDO
             IF (&HD  *GT '30') DO
                CHGVAR     VAR(&IN99) VALUE('1')
                CHGVAR   VAR(&@ERR) VALUE('LOGICAL ERROR AT DATE')
                GOTO ERR
             ENDDO
           ENDDO

     /*  10   */
           IF (&HM   *EQ '10')  DO
             IF (&HD  *LT '01') DO
                CHGVAR     VAR(&IN99) VALUE('1')
                CHGVAR   VAR(&@ERR) VALUE('LOGICAL ERROR AT DATE')
                GOTO ERR
             ENDDO
             IF (&HD  *GT '31') DO
                CHGVAR     VAR(&IN99) VALUE('1')
                CHGVAR   VAR(&@ERR) VALUE('LOGICAL ERROR AT DATE')
                GOTO ERR
             ENDDO
           ENDDO

     /*  11   */
           IF (&HM   *EQ '11')  DO
             IF (&HD  *LT '01') DO
                CHGVAR     VAR(&IN99) VALUE('1')
                CHGVAR   VAR(&@ERR) VALUE('LOGICAL ERROR AT DATE')
                GOTO ERR
             ENDDO
             IF (&HD  *GT '30') DO
                CHGVAR     VAR(&IN99) VALUE('1')
                CHGVAR   VAR(&@ERR) VALUE('LOGICAL ERROR AT DATE')
                GOTO ERR
             ENDDO
           ENDDO

     /*  12   */
           IF (&HM   *EQ '12')  DO
             IF (&HD  *LT '01') DO
                CHGVAR     VAR(&IN99) VALUE('1')
                CHGVAR   VAR(&@ERR) VALUE('LOGICAL ERROR AT DATE')
                GOTO ERR
             ENDDO
             IF (&HD  *GT '31') DO
                CHGVAR     VAR(&IN99) VALUE('1')
                CHGVAR   VAR(&@ERR) VALUE('LOGICAL ERROR AT DATE')
                GOTO ERR
             ENDDO
           ENDDO

 PAS:  IF (&HM   *LT '01')  DO
                CHGVAR     VAR(&IN99) VALUE('1')
                CHGVAR   VAR(&@ERR) VALUE('LOGICAL ERROR AT DATE')
                GOTO ERR
       ENDDO

       IF (&HM   *GT '12')  DO
                CHGVAR     VAR(&IN99) VALUE('1')
                CHGVAR   VAR(&@ERR) VALUE('LOGICAL ERROR AT DATE')
                GOTO ERR
       ENDDO

       IF (&IN05 *EQ '1') DO
           CHGVAR     VAR(&IN91) VALUE('1')
           SNDF       RCDFMT(NZUPW501)
           GOTO VP2
           ENDDO
       GOTO ERR

 VP2:        RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&WKTIM)
         /*JW1 GOTO       @EX */

         /*--JW1-----------------------------*/
         /* 灝▴橕鯫�　　　　　　　　　　　*/
         /*----------------------------------*/
             CALL       PGM(VJBC12) PARM(&LIBL)

         /*--JW1-----------------------------*/
         /* �硠�橑胗�����　　　　　*/
         /*----------------------------------*/
             CRTDUPOBJ  OBJ(NZUPP01) FROMLIB(&PLIB) OBJTYPE(*FILE) +
                          TOLIB(&LIBL)
             MONMSG     MSGID(CPF2130)

             OVRDBF     FILE(NZUPP01B) TOFILE(&LIBL/NZUPP01)
 @EX:
             CALL       PGM(NZUR50) PARM(&@YMDB &WRECD &WKENS)

             RGZPFM     FILE(NZUPP01)
             MONMSG     MSGID(CPF2981)

             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&WSTIM)
             CHGVAR     VAR(&WNUKI) VALUE(%SST(&@YMDB 1 8))

             CALL       PGM(VJBR14) PARM(&WFILE &WNUKI &WKTIM &WSTIM +
                          &WRECD &WKENS)

 ENDMA:      CHGJOB     OUTQ(&PRT)
             DLTOVR *ALL

 END:        DLTDTAARA  DTAARA(&WLIB/NZUC50ACT)

 SEND:       ENDPGM
