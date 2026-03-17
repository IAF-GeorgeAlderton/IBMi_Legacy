             PGM
             /** MYAC11 *******************************/
             /* PLURA PLANES TURN RATIO MASTER UPDATE */
             /*複数機番比率マスター更新             */
             /*負荷グラフデータ                     */
             /*   I-HASADA               2013/03/11   */
             /******************************* MYAC11 **/
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

    /*--------------*/
    /*  PGM:MYAR11  */
    /*--------------*/
             CALL       PGM(MYAR11) PARM(&USER)

             ENDPGM
