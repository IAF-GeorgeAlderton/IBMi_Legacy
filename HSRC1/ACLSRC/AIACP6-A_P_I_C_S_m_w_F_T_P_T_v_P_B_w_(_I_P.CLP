             PGM
             /** AIACP6 **********************************************/
             /*ＡＰＩＣＳシステムＦＴＰ通信プログラム投入（ＩＰＬ）*/
             /*        CODING:A.MAMIYA               2004.08.29      */
             /*  ADD JOB TO QGPL/@QSTRUP (AFTER IPL)                 */
             /********************************************** AIACP6 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CHK)  TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSID)

             DLTDTAARA  DTAARA(APICSFTP/AP0111ACT)
             MONMSG     MSGID(CPF2105)
             DLTDTAARA  DTAARA(APICSFTP/KT0111ACT)
             MONMSG     MSGID(CPF2105)

             CHGVAR     VAR(&CHK) VALUE('0')
             CALL       PGM(AIAR56) PARM(&CHK)

             CHGVAR     VAR(&CHK) VALUE('1')

             IF         (&CHK *EQ '0') GOTO END

         /*  CRTDTAARA  DTAARA(AFSFILE/AIACP5ACT) TYPE(*CHAR) +    */
         /*               LEN(10) TEXT('THE COMMUNICATION IS BEING +*/
         /*               EXECUTED.')                              */

            /** 図面サーバー通信 **/
         /*  SBMJOB     JOB(ZM9999) JOBD(APICSCTL) JOBQ(APICSCTL) +*/
         /*               RTGDTA(*JOBD) RQSDTA('CALL PGM(AIAC51) + */
         /*               PARM(''9999'' ''ZM'')') INLLIBL(*JOBD)   */

            /** かんばん発行機通信**/
            /* ＡＰＩＣＳ 0111 */
             SBMJOB     JOB(AP0111) JOBD(APICSCTL) JOBQ(APICSCTL) +
                          RTGDTA(*JOBD) RQSDTA('CALL PGM(AIAC51) +
                          PARM(''0111'' ''AP'')') INLLIBL(*JOBD)

            /* 工程内かんばん 0111 */
             SBMJOB     JOB(KT0111) JOBD(APICSCTL) JOBQ(APICSCTL) +
                          RTGDTA(*JOBD) RQSDTA('CALL PGM(AIAC71) +
                          PARM(''0111'' ''KT'')') INLLIBL(*JOBD)

            /* 指示かんばん 0111 */
             SBMJOB     JOB(SJ0111) JOBD(APICSCTL) JOBQ(APICSCTL) +
                          RTGDTA(*JOBD) RQSDTA('CALL PGM(AIAC81) +
                          PARM(''0111'' ''SJ'')') INLLIBL(*JOBD)

 END:        ENDPGM
