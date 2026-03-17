             PGM
             /** AB#C0O **********************************************/
             /*  864 DATA                                            */
             /*    H.AMANO       AUG/29/03                           */
             /*                                                      */
             /* TCHK1 03/20/06 CHG SNDDST                            */
             /* JW1   06/06/16 CHG SNDDST                            */
             /* JW2   05/16/24 ADD CPYF AB#EP95, AB#EP96             */
             /********************************************** AB#C0O **/
             DCL        VAR(&CNT) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ)
             CALL       PGM(AB#R0O)
             DLTOVR     FILE(QPRINT)

             RTVMBRD    FILE(AB#EP95) NBRCURRCD(&CNT)
             IF         (&CNT *GT 0) THEN(DO)
             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132B) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132B)
             CALL       PGM(AB#RW0)
/* TCHK1 S */
             SNDDST     TYPE(*FILE) +
                          TOINTNET((EDI864Message@iafi.com)) +
                          DSTD('HONDA EDI864 Text Message') +
                          MSG('HONDA EDI864 Text Message has been +
                          processed.  Please check the attached +
                          list. (AB#C0O).') +
                          DOCFILE(HWFILE1/PRT132B) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('HONDA EDI864 Text +
                          Message')
             DLTOVR     FILE(PRT132)
/* TCHK1 E */
/* JW2 SAVE */
       CPYF FROMFILE(HFILE1/AB#EP95) TOFILE(HFILE1/AB#EP95S) MBROPT(*ADD)
       MONMSG     MSGID(CPF0000)
       CPYF FROMFILE(HFILE1/AB#EP96) TOFILE(HFILE1/AB#EP96S) MBROPT(*ADD)
       MONMSG     MSGID(CPF0000)

             ENDDO

             ENDPGM
