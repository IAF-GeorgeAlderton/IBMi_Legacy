             PGM
             /** MYAC12 ********************************/
             /* PLURA PLANES TURN RATIO MASTER INQUIRY */
             /*複数機番比率マスター照会              */
             /*負荷グラフデータ                      */
             /*   I-HASADA                2013/03/11   */
             /******************************** MYAC12 **/
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

    /*--------------*/
    /*  PGM:MYAR12  */
    /*--------------*/
             CALL       PGM(MYAR12)

             ENDPGM
