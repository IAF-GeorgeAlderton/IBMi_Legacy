             PGM
             /** AB#C45T ***********************/
             /*  TEST AB#R45                   */
             /*  J.W  2021.10.14               */
             /************************ AB#C40 **/
             OVRPRTF    FILE(QPRINT)  OUTQ(EPRINT1) HOLD(*YES)
             OVRPRTF    FILE(QPRINT2) OUTQ(EPRINT1) HOLD(*YES)

             OVRDBF     FILE(AB#WP452) TOFILE(TWFILE1/AB#WP451)
             OVRDBF     FILE(AB#WP201) TOFILE(TWFILE1/AB#WP201)

             CALL       PGM(AB#R45) PARM('I0777')

             DLTOVR     FILE(*ALL)

             ENDPGM
