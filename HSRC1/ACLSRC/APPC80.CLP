             PGM
             SBMJOB     CMD(CALL PGM(APPC81) PARM('11')) +
                          JOB(APPC8111) LOG(*JOBD *JOBD *SECLVL) +
                          LOGOUTPUT(*JOBEND)

             GOTO       CMDLBL(@END)

             SBMJOB     CMD(CALL PGM(APPC81) PARM('12')) +
                          JOB(APPC8112) LOG(*JOBD *JOBD *SECLVL) +
                          LOGOUTPUT(*JOBEND)
             SBMJOB     CMD(CALL PGM(APPC81) PARM('13')) +
                          JOB(APPC8113) LOG(*JOBD *JOBD *SECLVL) +
                          LOGOUTPUT(*JOBEND)
             SBMJOB     CMD(CALL PGM(APPC81) PARM('14')) +
                          JOB(APPC8114) LOG(*JOBD *JOBD *SECLVL) +
                          LOGOUTPUT(*JOBEND)
             SBMJOB     CMD(CALL PGM(APPC81) PARM('15')) +
                          JOB(APPC8115) LOG(*JOBD *JOBD *SECLVL) +
                          LOGOUTPUT(*JOBEND)
             SBMJOB     CMD(CALL PGM(APPC81) PARM('16')) +
                          JOB(APPC8116) LOG(*JOBD *JOBD *SECLVL) +
                          LOGOUTPUT(*JOBEND)
             SBMJOB     CMD(CALL PGM(APPC81) PARM('17')) +
                          JOB(APPC8117) LOG(*JOBD *JOBD *SECLVL) +
                          LOGOUTPUT(*JOBEND)
             SBMJOB     CMD(CALL PGM(APPC81) PARM('18')) +
                          JOB(APPC8118) LOG(*JOBD *JOBD *SECLVL) +
                          LOGOUTPUT(*JOBEND)
             SBMJOB     CMD(CALL PGM(APPC81) PARM('19')) +
                          JOB(APPC8119) LOG(*JOBD *JOBD *SECLVL) +
                          LOGOUTPUT(*JOBEND)
@END:
             ENDPGM
