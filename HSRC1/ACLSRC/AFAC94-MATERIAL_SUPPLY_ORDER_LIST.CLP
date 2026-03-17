             PGM
             /** AB#C94 *******************************/
             /*  MATERIAL SUPPLY ORDER LIST           */
             /*     K.KASHIWAGI       2000.12.05      */
             /*     TCH    TCH50      03/11/05        */
             /******************************* AB#C90 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             OVRPRTF    FILE(QPRINT) DEVTYPE(*SCS) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1)

             CLRPFM     FILE(HWFILE1/AFP94)

             CALL       PGM(AFAR94) PARM(&USER)
             DLTOVR     FILE(*ALL)
 END:        ENDPGM
