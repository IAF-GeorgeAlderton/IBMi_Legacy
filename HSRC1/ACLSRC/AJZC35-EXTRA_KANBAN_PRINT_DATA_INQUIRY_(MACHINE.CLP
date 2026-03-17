             PGM
             /** ALDC67 ********************************************/
             /* EXTRA KANBAN PRINT DATA INQUIRY (MACHINE NO)       */
             /*端数統合かんばん発行実績ファイル                  */
             /*  KIRI                            2018.02.19        */
             /******************************************************/
             DCL        VAR(&WSNO)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSNO)

             CALL       AGAR00 PARM(&WSNO &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)

             CALL       PGM(AJZR35)

 END:        ENDPGM
