             PGM
             /** AHBC02 ************************************/
             /*                              14.06.23      */
             /*  A-PICS ORDER STATUS INFORMATION           */
             /**********************************************/
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSNO) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)

             OVRDBF     FILE(AHBPW02) TOFILE(TOBJ1/AHBPW02)
             CALL       PGM(TOBJ1/AHBR02) PARM(' ' ' ' ' ' ' ')
 END:
             ENDPGM
