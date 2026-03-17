             PGM
             /*** OAAC35 ***************************************/
             /*   BIN(RG)ﾃｰnﾞ  A NAME uﾇjｰ  UPDATA             */
             /*       <OUT GOING ORDER BUSINESS>               */
             /*         H.ITO            90.10.09              */
             /*************************************** OAAC35 ***/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)

             CALL       PGM(OAAR35) PARM(&USER)

 @END:       ENDPGM
