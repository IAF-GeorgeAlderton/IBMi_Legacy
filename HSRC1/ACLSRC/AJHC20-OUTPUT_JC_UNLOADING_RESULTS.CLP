PGM
             /** AJHC20 **********************************************/
             /* OUTPUT JC UNLOADING RESULTS                          */
             /*      CREATE DATE  :  2013/MAY/23                     */
             /*      AUTHOR.      :  T.SAKASHITA                     */
             /********************************************** AJHC20 **/
/*  JOB TYPE 0 = BATCH, 1 = INTERACTIVE                                    */
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)

             RTVJOBA    TYPE(&JOBTYPE)

             OVRDBF     FILE(INPUT) TOFILE(MEKI_RST09/RESULT)

             DLTF       FILE(QTEMP/OUTPUT)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/OUTPUT) RCDLEN(512)

             CALL       PGM(AJSRZ9)

             IF         COND(&JOBTYPE *EQ '1') THEN(DO)
             EDTDTA     FILE(QTEMP/OUTPUT)
             ENDDO

             OVRDBF     FILE(INPUT) TOFILE(QTEMP/OUTPUT)
             CALL       PGM(AJHR2Y)

ENDPGM
