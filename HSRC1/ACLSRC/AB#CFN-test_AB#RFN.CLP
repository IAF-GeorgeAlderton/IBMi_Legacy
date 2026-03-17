             PGM
             /** AB#CFN  *********************************/
             /*  TEST AB#RFN                             */
             /********************************************/
             DCL        VAR(&PD) TYPE(*CHAR) LEN(1) VALUE(' ')

             OVRPRTF    FILE(QPRINT) OUTQ(WATAOUTQ)

             CALL       PGM(TOBJ1/AB#RFN) PARM(&PD)

             ENDPGM
