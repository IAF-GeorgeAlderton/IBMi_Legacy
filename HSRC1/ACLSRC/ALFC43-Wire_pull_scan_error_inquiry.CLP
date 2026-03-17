 PGM
/** ALFC43 ************************************************/
/*  CONVEYANCE WIRE PULL SCAN ERROR INQUIRY               */
/*                                                        */
/*  LEC   3/19/18                                         */
/**********************************************************/

             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)   TYPE(*CHAR) LEN(6)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             CALL       PGM(ALFR43)

 ENDPGM
