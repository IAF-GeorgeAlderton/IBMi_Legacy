             PGM
             /*** AARC50 ************************************/
             /* INQUIRY OF CHUBU PLATING UNIT PRICE M/F  AARC50 */
             /*         Y.TANOUE         92.07.21           */
             /****************************** AARC50 *********/
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSNO)
             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)
             CALL       PGM(AARR50)
             CHGJOB     OUTQ(&PRT)
             ENDPGM
