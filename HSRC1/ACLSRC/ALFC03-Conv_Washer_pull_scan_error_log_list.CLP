 PGM
/** ALFC03 ************************************************/
/*  CONVEYANCE WASHER PULL SCAN ERROR LOG LIST  HAND      */
/*                                                        */
/* TCHK1 10/21/10 CREATE(COPY FROM ALCC03)                */
/**********************************************************/

             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)   TYPE(*CHAR) LEN(6)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)


             CALL       PGM(ALFR03)

             DLTOVR     FILE(*ALL)

 ENDPGM
