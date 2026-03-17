             PGM
             /** RCLC81 *******************************/
             /* ..LIMITATION .TRIAL MFG KANBAN PUBLICATION DATA CHANGE */
             /* I-HASADA                 84.07.21     */
             /******************************* RCLC81 **/
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WS) USER(&US)

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)
             CALL       PGM(RCLR81) PARM(&US)

             ENDPGM
