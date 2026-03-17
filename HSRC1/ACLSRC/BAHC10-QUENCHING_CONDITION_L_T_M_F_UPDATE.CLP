             PGM
             /** BAHC10 **********************************/
             /* QUENCHING CONDITION L / T M/F UPDATE */
             /*         A-IDOTA 1995.04.07               */
             /********************************** BAHC10 **/
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WS) USER(&US)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
 STP1:
             CALL       PGM(BAHR10) PARM(&US)
 END:        ENDPGM
