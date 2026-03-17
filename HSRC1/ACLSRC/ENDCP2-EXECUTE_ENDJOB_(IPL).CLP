             PGM
             /** ENDCP2 ******************************************/
             /*  PROGRAM NAME : ENDJOB 実行プログラム（ＩＰＬ）*/
             /*  PROGRAM ID   : ENDCP2                           */
             /*  CREATE DATE  : 2004.08.30                       */
             /*  AUTHOR       : A.MAMIYA                         */
             /*  ADD JOB TO QGPL/@QSTRUP (AFTER IPL)             */
             /****************************************** ENDCP2 **/
             CPYF       FROMFILE(HFILE1/ENDPP01) +
                          TOFILE(HFILE1/ENDPP01_BK) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(ENDPP01)
             MONMSG     MSGID(CPF0000)
             DLTDTAARA  DTAARA(HFILE1/ENDCP1ACT)
             MONMSG     MSGID(CPF2105)
 @STEP1:
             CRTDTAARA  DTAARA(HFILE1/ENDCP1ACT) TYPE(*CHAR) +
                          LEN(10) TEXT('ＥＮＤＪＯＢ実行中')

             SBMJOB     CMD(CALL PGM(ENDC10)) JOB(ENDJOB) +
                          JOBD(QBATCH4) JOBQ(JOBQ4) RTGDTA(*JOBD) +
                          INLLIBL(*JOBD)
 @END:
             ENDPGM
