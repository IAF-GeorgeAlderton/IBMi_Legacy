             PGM        PARM(&SERL &OUTQ)

             /** AM#CLB02  *********************/
             /* PRINT SERVICE PART BAG LABELS  */
             /*   LEC.             2020.01.29  */
             /**********************************/

             DCL        VAR(&SERL) TYPE(*CHAR) LEN(18)
             DCL        VAR(&OUTQ) TYPE(*CHAR) LEN(10)

             CALL       PGM(AM#RLBL02) PARM(&SERL &OUTQ)

             ENDPGM
