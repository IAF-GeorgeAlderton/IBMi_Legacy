             PGM
             /** AB#CG6 **********************************************/
             /*  FORD EDI(997) MESSAGE                               */
             /*  J.WATANABE 2025.09.23                               */
             /********************************************************/

             DCL        VAR(&PD)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) HOLD(*YES)
             OVRDBF     FILE(AB#PP6U) TOFILE(HFILE1/AB#PP6U)

 /** PRINT EDI (FORD997) OK IN QPRINT                      **/
      /**    CALL       PGM(AB#RG6 ) PARM((&PD))   **/
             CALL       PGM(AB#RG61) PARM((&PD))

 /** SEND QPRINT BY MAIL                                   **/
             IF         (&PD *EQ '1') THEN(DO)
       /**** CALL SNDC20  ****/
             CALL SNDC25
             ENDDO

             ENDPGM
