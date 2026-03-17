             PGM
             /** EJKC00 ********************************/
             /* SUBMIT JOBS FOR B2B SERVER (FOR IPL)   */
             /*    **ORIGINAL IS JK100C FROM ASJ**     */
             /*  T.SAKAKI            2016.10.11        */
             /*  ADD JOB TO QGPL/@QSTRUP (AFTER IPL)   */
             /*  -----------------------------------   */
             /*  JW1    2017.11.06 CHG JOBQ TO JOBQ7   */
             /*  JW2    2017.11.12 CHG BACK JOBQ TO JOBQ6 */
             /*  JW3    2023.06.14 ADD IAFC10          */
             /************************ EJKC00 **********/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OBJL) TYPE(*CHAR) LEN(10)

             RTVJOBA    USER(&USER)

             CHGVAR     VAR(&OBJL) VALUE('HOBJ1     ')
             IF         COND(&USER *EQ 'TEST') THEN(DO)
             CHGVAR     VAR(&OBJL) VALUE('TOBJ1     ')
             ENDDO

        /*--------------------------------------------*/
        /*  DELETE OLD DATA AND REORGANIZE            */
        /*--------------------------------------------*/
             CALL       PGM(EJKR20)
             RGZPFM     FILE(EJKPP01)
             MONMSG     MSGID(CPF0000)
             RGZPFM     FILE(EJKPP40)
             MONMSG     MSGID(CPF0000)
             RGZPFM     FILE(EJKPP50)
             MONMSG     MSGID(CPF0000)
             RGZPFM     FILE(EJKPP55)
             MONMSG     MSGID(CPF0000)
             RGZPFM     FILE(EJRPP01)
             MONMSG     MSGID(CPF0000)

        /*--------------------------------------------*/
        /*  SUBMIT B2B_R                              */
        /*--------------------------------------------*/
             DLTDTAARA  DTAARA(&OBJL/AJCC10D1)
             MONMSG     MSGID(CPF2105)
             DLTDTAARA  DTAARA(&OBJL/EJKC01RUN)
             MONMSG     MSGID(CPF2105)
             DLTDTAARA  DTAARA(&OBJL/EJKC01ACT)
             MONMSG     MSGID(CPF2105)
             SBMJOB     CMD(CALL PGM(EJKC01)) JOB(B2B_R) +
                          JOBD(QBATCH4) JOBQ(JOBQ6) USER(B2BUSER) +
                          RTGDTA(*JOBD) INLLIBL(*JOBD)

          /* CHG JOBQ TO JOBQ7 (JW1)                                */
          /* SBMJOB     CMD(CALL PGM(EJKC01)) JOB(B2B_R) +          */
          /*              JOBD(QBATCH4) JOBQ(JOBQ7) USER(B2BUSER) + */
          /*              RTGDTA(*JOBD) INLLIBL(*JOBD)              */

        /*--------------------------------------------*/
        /*  SUBMIT B2B_S                              */
        /*--------------------------------------------*/
             DLTDTAARA  DTAARA(&OBJL/EJKC50RUN)
             MONMSG     MSGID(CPF2105)
             DLTDTAARA  DTAARA(&OBJL/EJKC50ACT)
             MONMSG     MSGID(CPF2105)

             CRTPF      FILE(WEEKDLT/EJSEP01) RCDLEN(84)
             MONMSG     MSGID(CPF0000)

             SBMJOB     CMD(CALL PGM(EJKC50)) JOB(B2B_S) +
                          JOBD(QBATCH) JOBQ(JOBQ6) USER(B2BUSER) +
                          RTGDTA(*JOBD) INLLIBL(*JOBD)

          /* CHG JOBQ TO JOBQ7 (JW1)                               */
          /* SBMJOB     CMD(CALL PGM(EJKC50)) JOB(B2B_S) +         */
          /*              JOBD(QBATCH) JOBQ(JOBQ7) USER(B2BUSER) + */
          /*              RTGDTA(*JOBD) INLLIBL(*JOBD)             */

        /*--------------------------------------------*/
        /*  SUBMIT B2B_E                              */
        /*--------------------------------------------*/
             SBMJOB     CMD(CALL PGM(EJKC30)) JOB(B2B_E) +
                          JOBD(QBATCH) JOBQ(JOBQ6) USER(B2BUSER) +
                          RTGDTA(*JOBD) INLLIBL(*JOBD)

          /* CHG JOBQ TO JOBQ7 (JW1)                               */
          /* SBMJOB     CMD(CALL PGM(EJKC30)) JOB(B2B_E) +         */
          /*              JOBD(QBATCH) JOBQ(JOBQ7) USER(B2BUSER) + */
          /*              RTGDTA(*JOBD) INLLIBL(*JOBD)             */

        /* JW3 ---------------------------------------*/
        /*  SUBMIT IAFC10 IN QBIAF                    */
        /*--------------------------------------------*/
             SBMJOB     CMD(CALL PGM(IAFC10)) JOB(IAFC10) +
                          JOBD(QBATCH) JOBQ(IAFQ1) USER(QPGMR) +
                          RTGDTA(*JOBD) INLLIBL(*JOBD)

 #END:       ENDPGM
