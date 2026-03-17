             PGM
             /** AJEC08 ****************************************/
             /*  MENU M/F CANCELLED BY MENU UNIT               */
             /* I-HASADA                        87.07.26       */
             /**************************************** AJEC08 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSNO) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)
             CALL       PGM(AJER08) PARM(&USER)

             ENDPGM
