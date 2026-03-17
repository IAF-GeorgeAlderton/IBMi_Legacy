             PGM
             /** NSUC69 ************************/
             /* INVENTORY COUNTONG ACCUMULATION FILE INQUIRY */
             /* A.IDOTA 1990.01.28 */
             /************************ NSUC69 **/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CALL       PGM(NSUR69)

 END:        ENDPGM
