             PGM
             /** ABAC3L *************************/
             /*  FORD DISUSE PARTS INFORMATION    */
             /*                                 */
             /*                                 */
             /************************* ABAC3L **/
             DCL        VAR(&USR)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&END) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSID) USER(&USR) NBR(&NBR)
             OVRPRTF    FILE(QPRINT2) OUTQ(FORECAST) SAVE(*YES)
             DLTF       FILE(QTEMP/PRT132)
             MONMSG     MSGID(CPF0000)
             CRTPF      FILE(QTEMP/PRT132) RCDLEN(132)

             CALL       PGM(ABAR3L) PARM(&END)
             IF         COND(&END *EQ '1') THEN(GOTO CMDLBL(@END))

             CPYSPLF    FILE(QPRINT2) TOFILE(QTEMP/PRT132) +
                          JOB(&NBR/&USR/&WSID) SPLNBR(*LAST)

             OVRDBF     FILE(PRT132) TOFILE(QTEMP/PRT132)
             CALL       PGM(AB#RW0)
             DLTOVR     FILE(PRT132)

             SNDDST     TYPE(*FILE) TOINTNET((kaz.watanabe@iafi.com) +
                          (Stephanie.Brothers@iafi.com)) DSTD('FORD +
                          FORECAST <disuse information>') +
                          MSG('Attached please check the list of +
                          disused parts information. (ABAC3L)') +
                          DOCFILE(QTEMP/PRT132) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('FORD disused parts +
                          information')
    /*       SNDDST     TYPE(*FILE) +                                   */
    /*                    TOINTNET((kaz.watanabe@iafi.com)) +           */
    /*                    DSTD('FORD FORECAST <disuse +                 */
    /*                    information>') MSG('Attached please check +   */
    /*                    the list of disused parts information.') +    */
    /*                    DOCFILE(QTEMP/PRT132) DOCTYPE(*FFT) +         */
    /*                    SNDFMT(*NOTE) DOCD('FORD disused parts +      */
    /*                    information')                                 */
             DLTOVR     FILE(*ALL)
  @END:

             ENDPGM
