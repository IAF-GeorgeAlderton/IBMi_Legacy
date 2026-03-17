             PGM
             /** MYAC02 *******************************/
             /*  NUMBER OF REVOLUTIONS MASTER INQUIRY */
             /* 品番別回転数マスター照会            */
             /* 設備負荷グラフデータ                */
             /*    I-HASADA             2013/03/11    */
             /******************************* MYAC02 **/
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

    /*--------------*/
    /*  PGM:MYAR02  */
    /*--------------*/
             CALL       PGM(MYAR02)

             ENDPGM
