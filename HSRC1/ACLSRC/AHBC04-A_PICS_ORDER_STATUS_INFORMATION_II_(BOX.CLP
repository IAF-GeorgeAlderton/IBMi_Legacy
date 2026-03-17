             PGM
             /** AHBC02 ****************************************/
             /*  A-PICS ORDER STATUS INFORMATION II (BOX/QTY)  */
             /*                              14.06.23          */
             /*  JW(SRAA) 12/21/2015 (COPIED FROM AHBC04)      */
             /**************************************************/
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSNO) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)

             CALL       PGM(AHBR04) PARM(' ' '     ' '     ' '  ')
 END:
             ENDPGM
