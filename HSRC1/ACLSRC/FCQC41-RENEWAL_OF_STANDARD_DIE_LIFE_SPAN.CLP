             PGM
             /** FCQC41 *********************************/
             /*     ..RENEWAL OF STANDARD DIE LIFE SPAN */
             /*       MSK.KUNIEDA         98.05.25      */
             /********************************* FCQC41 **/
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WS) USER(&US)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

             CALL       PGM(FCQR41) PARM(&US)

             ENDPGM
