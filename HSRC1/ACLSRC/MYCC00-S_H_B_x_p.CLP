             PGM
             /** MYCC00 *********************/
             /* 設備負荷グラフメニュー    */
             /*  I-HASADA       2017/12/21  */
             /********************* MYCC00 **/
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

    /*--------------*/
    /*  PGM:MYCR00  */
    /*--------------*/
             CALL       PGM(MYCR00)

             ENDPGM
