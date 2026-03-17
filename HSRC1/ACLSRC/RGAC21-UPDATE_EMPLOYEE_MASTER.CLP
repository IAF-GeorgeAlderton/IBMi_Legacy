             PGM
             /** RGAC21 *****************************/
             /* UPDATE EMPLOYEE MASTER              */
             /*   Y.MAEDA            2017.10.04     */
             /****************************TU001C*****/
             DCL        VAR(&PYM) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR)  TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USR)

             CALL       PGM(RGAR21) PARM(&USR)

             ENDPGM
