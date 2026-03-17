             PGM
             /** MYAC00 **********************/
             /*  FACILITIES LOAD GRAPH MENU  */
             /* 設備負荷グラフメニュー     */
             /*   I-HASADA      2013/03/11   */
             /********************** MYAC00 **/
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

    /*--------------*/
    /*  PGM:MYAR00  */
    /*--------------*/
             CALL       PGM(MYAR00)

             ENDPGM
