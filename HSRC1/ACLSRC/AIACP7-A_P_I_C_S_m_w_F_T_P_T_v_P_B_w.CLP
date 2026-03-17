             PGM
             /** AIACP7 ****************************************/
             /*  ..ＡＰＩＣＳシステムＦＴＰ通信プログラム投入*/
             /*  CODING:A.MAMIYA               2004.09.01      */
             /**************************************** AIACP7 **/
             DCLF       FILE(AIAPW51)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&HIZK) TYPE(*CHAR) LEN(6)
             DCL        VAR(&HIZ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&TIM) TYPE(*CHAR) LEN(6)
             RTVJOBA    JOB(&WSID)
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&HIZK)
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&TIM)
             CHGVAR     VAR(&HIZ) VALUE('20' *CAT &HIZK)

             CHGVAR     VAR(&IHIZ) VALUE(&HIZ)
             CHGVAR     VAR(&ITIM) VALUE(&TIM)


             CHKOBJ     OBJ(APICSFTP/AP0111ACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STPAP0111))
             CHGVAR     VAR(&IN03) VALUE('1')
             GOTO       STP2
 STPAP0111:  CHKOBJ     OBJ(APICSFTP/KT0111ACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STP1))
             CHGVAR     VAR(&IN03) VALUE('1')
             GOTO       STP2
 STP1:       CHGVAR     VAR(&IN02) VALUE('1')
 STP2:
             SNDRCVF    DEV(&WSID) RCDFMT(AIAPW511)
             CHGVAR     VAR(&IN10) VALUE('0')
             CHGVAR     VAR(&IN11) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')
             IF         (&IN01 *EQ '1') GOTO END
             IF         (&IHIZ *EQ '        ') DO
                 CHGVAR     VAR(&IN99) VALUE('1')
                 CHGVAR     VAR(&IN10) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE END DATE IS NOT INPUT')
                 GOTO       STP2
             ENDDO
             IF         (&ITIM *EQ '      ') DO
                 CHGVAR     VAR(&IN99) VALUE('1')
                 CHGVAR     VAR(&IN11) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('TIME IS NOT INPUT')
                 GOTO       STP2
             ENDDO
             IF         (&IHIZ *LT &HIZ) GOTO STP3
             IF         (%SST(&IHIZ 5 2) *LT '01') GOTO STP3
             IF         (%SST(&IHIZ 5 2) *GT '12') GOTO STP3
             IF         (%SST(&IHIZ 7 2) *LT '01') GOTO STP3
             IF         (%SST(&IHIZ 7 2) *GT '31') GOTO STP3

             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&TIM)
             IF         (&IHIZ *EQ &HIZ) DO
                 IF         (&ITIM *LT &TIM) GOTO STP4
             ENDDO
             IF         (%SST(&ITIM 1 2) *LT '00') GOTO STP4
             IF         (%SST(&ITIM 1 2) *GT '23') GOTO STP4
             IF         (%SST(&ITIM 3 2) *LT '00') GOTO STP4
             IF         (%SST(&ITIM 3 2) *GT '59') GOTO STP4
             IF         (%SST(&ITIM 5 2) *LT '00') GOTO STP4
             IF         (%SST(&ITIM 5 2) *GT '59') GOTO STP4

             IF         (&IN03 *EQ '1') GOTO STP2
             IF         (&IN05 *EQ '0') GOTO STP2
             GOTO EXEC
 STP3:
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&IN10) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('THE END DATE IS NOT CORRECT')
             GOTO       STP2
 STP4:
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&IN11) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('TIME IS NOT CORRECT')
             GOTO       STP2
 EXEC:
         /*  CRTDTAARA  DTAARA(AFSFILE/AIACP5ACT) TYPE(*CHAR) +     */
         /*               LEN(10) TEXT('THE COMMUNICATION IS BEING +*/
         /*               EXECUTED')                                */

            /** 図面サーバー通信 **/
         /*  SBMJOB     CMD(CALL PGM(AIAC52) PARM('9999' 'ZM' &IHIZ +*/
         /*               &ITIM)) JOB(ZM9999) JOBD(APICSCTL) +       */
         /*               JOBQ(APICSCTL) RTGDTA(*JOBD) INLLIBL(*JOBD)*/
            /** かんばん発行機通信**/
            /* ＡＰＩＣＳ 0111 */
             SBMJOB     CMD(CALL PGM(AIAC52) PARM('0111' 'AP' &IHIZ +
                          &ITIM)) JOB(AP0111) JOBD(APICSCTL) +
                          JOBQ(APICSCTL) RTGDTA(*JOBD) INLLIBL(*JOBD)

            /* 工程内かんばん 0111 */
             SBMJOB     CMD(CALL PGM(AIAC72) PARM('0111' 'KT' &IHIZ +
                          &ITIM)) JOB(KT0111) JOBD(APICSCTL) +
                          JOBQ(APICSCTL) RTGDTA(*JOBD) INLLIBL(*JOBD)

 END:        ENDPGM
