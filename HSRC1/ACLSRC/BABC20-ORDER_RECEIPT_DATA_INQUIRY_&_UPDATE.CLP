             PGM
             /** BABC20 *********************************/
             /* ...ORDER RECEIPT DATA INQUIRY & UPDATE ... */
             /* I-HASADA                   84.07.10     */
             /********************************* BABC20 **/
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WS) USER(&US)

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

             CHKOBJ     OBJ(HWFILE1/BABNP20) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTPF      FILE(HWFILE1/BABNP20) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(100) LVLCHK(*NO) +
                          AUT(*ALL)
             ENDDO

             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) OUTQ(&PRT) +
                          FORMTYPE(K6H1)
             CALL       PGM(BABR20) PARM(&US &WS)
             DLTOVR     FILE(QPRINT)

             ENDPGM
