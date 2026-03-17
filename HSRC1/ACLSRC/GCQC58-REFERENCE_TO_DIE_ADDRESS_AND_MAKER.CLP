             PGM
             /*** GCAC58 ******************************/
             /*  REFERENCE TO DIE ADDRESS AND MAKER */
             /*     MSK.KUNIEDA    02.19.1999         */
             /****************************** GCQR58 ***/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSNO) USER(&USER)
             CHGJOB     SWS(00000000)

             CALL       AGAR00 PARM(&WSNO &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)

             CALL       PGM(GCQR58)

             ENDPGM
