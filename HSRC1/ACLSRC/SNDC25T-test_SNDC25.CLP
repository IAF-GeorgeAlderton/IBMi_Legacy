             PGM
             /** SNDC25T *********************************************/
             /*  CALL SNDC25                                         */
             /*  J.W  2025.10.28                                     */
             /********************************************************/
             DCL        VAR(&PD  ) TYPE(*CHAR) LEN(1)

             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) HOLD(*YES)
             OVRDBF     FILE(AB#PL6U) TOFILE(TFILE1/AB#PL6U)
             OVRDBF     FILE(AB#PP6U) TOFILE(TFILE1/AB#PP6U)

             CALL       PGM(AB#RG61) PARM((&PD))

             IF         (&PD *EQ '1') THEN(DO)
             CALL SNDC25
             ENDDO

             ENDPGM
