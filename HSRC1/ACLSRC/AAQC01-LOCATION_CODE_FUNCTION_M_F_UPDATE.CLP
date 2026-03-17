             PGM
             /** AAQC01 ********************************/
             /* LOCATION CODE FUNCTION M/F UPDATE */
             /*          H.ITO 86.10.07                */
             /******************************** AAQC01 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
 STP1:       CHGJOB     OUTQ(&PRTG)
             CALL       PGM(AAQR01) PARM(&USER)
 END:        ENDPGM
