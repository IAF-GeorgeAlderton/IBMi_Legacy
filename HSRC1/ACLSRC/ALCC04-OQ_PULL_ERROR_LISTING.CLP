 PGM
/** ALCC04 ************************************************/
/*  OQ PULL SCAN ERROR LOG LIST                           */
/*  COPIED ALCC03                                         */
/**********************************************************/

             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)   TYPE(*CHAR) LEN(6)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)


             CALL       PGM(ALCR031)

             DLTOVR     FILE(*ALL)

 ENDPGM
