             PGM
             /** AIACP5 ****************************************/
             /* SUBMIT APICS SYSTEM FTP COMMUNICATION PGM      */
             /*  CODING:A.INOUE                2004.08.09      */
             /**************************************** AIACP5 **/
             DCLF       FILE(AIAPW50)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID)

             CHKOBJ     OBJ(APICSFTP/AP0111ACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STPAP0111))
             CHGVAR     VAR(&IN03) VALUE('1')
             GOTO       STP2
 STPAP0111:  CHKOBJ     OBJ(APICSFTP/KT0111ACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(STP1))
             CHGVAR     VAR(&IN03) VALUE('1')
             GOTO       STP2
 STP1:       CHGVAR     VAR(&IN02) VALUE('1')

 STP2:       SNDRCVF    DEV(&WSID) RCDFMT(AIAPW501)
             CHGVAR     VAR(&IN99) VALUE('0')
             IF         (&IN01 *EQ '1') GOTO END
             IF         (&IN03 *EQ '1') GOTO STP2
             IF         (&IN05 *EQ '0') GOTO STP2

        /*   CRTDTAARA  DTAARA(AFSFILE/AIACP5ACT) TYPE(*CHAR) +     */
        /*                LEN(10) TEXT('THE COMMUNICATIONS IS BEING +*/
        /*                EXECUTED')                                */

            /** 図面サーバー通信 **/
        /*   SBMJOB     JOB(ZM9999) JOBD(APICSCTL) JOBQ(APICSCTL) +*/
        /*                RTGDTA(*JOBD) RQSDTA('CALL PGM(AIAC51) + */
        /*                PARM(''9999'' ''ZM'')') INLLIBL(*JOBD)   */

            /** かんばん発行機通信**/
            /* ＡＰＩＣＳ 0111 */
             SBMJOB     JOB(AP0111) JOBD(APICSCTL) JOBQ(APICSCTL) +
                          RTGDTA(*JOBD) RQSDTA('CALL PGM(AIAC51) +
                          PARM(''0111'' ''AP'')') INLLIBL(*JOBD)

            /* 工程内かんばん 0111 */
             SBMJOB     JOB(KT0111) JOBD(APICSCTL) JOBQ(APICSCTL) +
                          RTGDTA(*JOBD) RQSDTA('CALL PGM(AIAC71) +
                          PARM(''0111'' ''KT'')') INLLIBL(*JOBD)

             CALL       PGM(VJBC20)

 END:        ENDPGM
