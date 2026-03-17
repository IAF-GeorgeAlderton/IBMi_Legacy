             PGM
             /** AB#C0S **********************************************/
             /*  SUNMIT AB#C0S#  (TEST)                              */
             /*  JW   2025.10.21                                     */
             /********************************************************/

             CPYF       FROMFILE(TFILE1/AB#EP66) +
                          TOFILE(HFILE1/AB#EP66Q) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF0000)

             SBMJOB     CMD(CALL PGM(AB#C0S#)) JOB(AB#C0S#) +
                          JOBD(QBATCH) JOBQ(JOBQ7) USER(AS400) +
                          RTGDTA(*JOBD) INLLIBL(*JOBD) LOG(4 00 +
                          *SECLVL) LOGCLPGM(*YES)

             ENDPGM
