             PGM
             /** MYAC01 *******************************/
             /*  NUMBER OF REVOLUTIONS MASTER UPDATE  */
             /* 品番別回転数マスター更新            */
             /* 設備負荷グラフデータ                */
             /*    I-HASADA             2013/03/11    */
             /******************************* MYAC01 **/
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

    /*--------------*/
    /*  PGM:MYAR01  */
    /*--------------*/
             CALL       PGM(MYAR01) PARM(&USER)

             ENDPGM
