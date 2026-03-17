             PGM
             /** RGAC00 ***************************/
             /* ..PRINTER POWER SUPPLY STRPRTWTR.. */
             /* ..DEV OUTQ MSGQ                   */
             /* I-HASADA 91.05.23 */
             /*************************** RGAC00 **/
             DCL        VAR(&PWS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEV) TYPE(*CHAR) LEN(2)
             DCL        VAR(&POUTQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PSYS) TYPE(*CHAR) LEN(8)
             RTVNETA    SYSNAME(&PSYS)
             RTVJOBA    JOB(&PWS)

             IF         (&PSYS *EQ 'IAF     ') DO

             STRPRTWTR  DEV(P1) OUTQ(QGPL/QPRINT) MSGQ(DSP01)
             MONMSG     MSGID(CPF3310 CPF3396 CPF3347 CPF3363 CPF0000)

             CALL       PGM(AJER06) PARM(&PWS &PDEV &POUTQ)

             IF         (&PDEV *EQ '  ') GOTO END

             STRPRTWTR  DEV(&PDEV) OUTQ(&POUTQ) MSGQ(&PWS)
             MONMSG     MSGID(CPF3310 CPF3396 CPF3347 CPF3363 CPF0000)

             ENDDO

 END:        ENDPGM
