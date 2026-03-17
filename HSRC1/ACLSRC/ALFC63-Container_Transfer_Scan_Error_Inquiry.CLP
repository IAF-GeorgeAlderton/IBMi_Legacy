 PGM
/** ALFC63 ************************************************/
/*  CONTAINER TRANSFER SCAN ERROR INQUIRY                 */
/*                                                        */
/*  LEC                        2019/12/06                 */
/**********************************************************/

             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)   TYPE(*CHAR) LEN(6)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             CALL       PGM(ALFR63)

 ENDPGM
