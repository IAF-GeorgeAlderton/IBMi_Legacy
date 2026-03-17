             PGM
             /** GADC11 ********************************************/
             /*  SHIPMENT M/F UPDATE                               */
             /* I-HASADA 97.01.21                                  */
             /* JW1    2018.10.09 ADD GADC15 TO SEND LOG BU MAIL   */
             /******************************************************/

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)
             CALL       PGM(GADR11) PARM(&USER)
 /* JW1 */
             CALL       PGM(GADC15)

             ENDPGM
