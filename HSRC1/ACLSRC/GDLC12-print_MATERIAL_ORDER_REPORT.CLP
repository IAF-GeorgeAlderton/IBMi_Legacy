             PGM
             /** GDLC12 *****************************/
             /*  MATERIAL ORDER SHEET PRINT SYSTEM  */
             /*               K.YASUDA  2000.07.11  */
             /* TCHK1 10/03/07 CHG PRINTER CONTROL  */
             /***************************** GDLC12 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

/* TCHK1 */
             OVRPRTF    FILE(GDLPR10) DEVTYPE(*SCS) PAGESIZE(66 80) +
                          LPI(6) OVRFLW(58) RPLUNPRT(*YES) +
                          OUTQ(LANPRT03) FORMTYPE(K6S1)

             CALL       PGM(GDLR12) PARM(&USER)

 END:        ENDPGM
