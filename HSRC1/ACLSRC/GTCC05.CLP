             PGM
/*** GTCC05 ************************************************/
/* PT PLAN PUBLICATION MANAGEMENT SYSTEM                   */
/*                                                         */
/* TCHK  10/04/12 CREATE(COPY FROM BTAC05)                 */
/***********************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CALL       PGM(GTCR05) PARM(&USER)

             ENDPGM
