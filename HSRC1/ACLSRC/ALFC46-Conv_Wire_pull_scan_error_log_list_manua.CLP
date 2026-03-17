 PGM
/** ALFC46 ************************************************/
/*  CONVEYANCE WIRE PULL SCAN ERROR LOG LIST              */
/*                                                        */
/*  LEC   3/13/18 CREATE(COPY FROM ALFC03)                */
/**********************************************************/

             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)   TYPE(*CHAR) LEN(6)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             CALL       PGM(ALFR46)

 ENDPGM
