             PGM
             /** AFBC85 ************************************/
             /* ORDER CANCELATION                          */
             /*  LOCAL PARTS PROCUREMENT SYSTEM>           */
             /*                                            */
             /************************************ AFBC8C **/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&WKCD)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&END)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             RTVJOBA    JOB(&WSID)  USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)

             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CALL       PGM(AFBR8W) PARM(&WKCD &END)

             IF         COND(&END *EQ ' ') THEN(DO)
             CALL       PGM(AFBR85) PARM(&USER &WKCD)
             ENDDO

             ENDPGM
