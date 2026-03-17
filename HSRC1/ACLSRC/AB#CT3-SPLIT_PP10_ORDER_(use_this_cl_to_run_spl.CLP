             /** AB#CT3 ****************************************/
             /*  SPLIT PP10 ORDER BY PALETTE (OVER 60 BOXES)   */
             /*  (USE THIS CL TO RUN SPLIT AGAIN)              */
             /*  J.WATANABE  2024.10.28                        */
             /**************************************************/
             PGM

             DCL        VAR(&RTN )  TYPE(*CHAR) LEN(1)

             OVRPRTF    FILE(QPRINT) USRDTA('SPLIT60')

             CALL       PGM(AB#RT3) PARM(&RTN )

             ENDPGM
