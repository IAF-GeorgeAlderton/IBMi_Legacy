 PGM
/** ALCC03 ************************************************/
/*  CONVEYANCE PULL 3-POINT SCAN ERROR LOG LIST  HAND     */
/*                                                        */
/* TCHK1 06/29/09 CREATE                                  */
/**********************************************************/

             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)   TYPE(*CHAR) LEN(6)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)


             CALL       PGM(ALCR03)

             DLTOVR     FILE(*ALL)

 ENDPGM
