/* RESET CUMULATIVE QTY FROM AUGUST 1ST                      */
/* THIS PROGRAM SHOULD RUN BEFORE STARTING JOB ON AUGUST 1ST */
/* EVERY YEAR                                                */
/*-----------------------------------------------------------*/
             PGM
             DCLF       FILE(AB#PWFY)
             SNDRCVF    RCDFMT(DSP01)
@STRT:
             IF         COND(&IN03 *EQ '1') THEN(GOTO CMDLBL(@END))
             IF         COND(&IN23 *EQ '0') THEN(GOTO CMDLBL(@STRT))

             CPYF       FROMFILE(HFILE1/ABFAP01) +
                          TOFILE(HWFILE1/ABFAP01BK) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
             OVRDBF     FILE(ABFAP01) TOFILE(HFILE1/ABFAP01)
             CALL       PGM(HOBJ1/AB#RFY)

@END:
             ENDPGM
