             PGM        PARM(&PHIZ &PHZ1 &PHZ2 &PMM1 &PMM2 &PMM3 +
                          &PCD1 &PCD2 &PCD3 &PCD4)
             /** ABBC23 ********************************/
             /* THE SETTING NUMBER ABNORMALLY INCREASE & DECREASE CHECK LIST */
             /* I-HASADA                   94.10.13    */
             /******************************** ABBC23 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PHIZ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PHZ1) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PHZ2) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PMM1) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PMM2) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PMM3) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PCD1) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PCD2) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PCD3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PCD4) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PDT1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDT2) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDT3) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             DLTF       FILE(ABBWP231)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ABBWP231) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             DLTF       FILE(ABBWP232)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ABBWP232) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             DLTF       FILE(ABBWP233)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ABBWP233) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                          AUT(*ALL)

             CALL       PGM(ABBR23) PARM(&PDT1 &PDT2 &PDT3 &PCD2 +
                          &PCD3 &PCD4)

             /*------------------------------------------------*/
             /* PRODUCT DEMAND FORECAST NUMBER OVER 30 % INCREASE*/
             /*                     FROM N MONTH  TO N+2 MONTH */
             /*------------------------------------------------*/
             IF         (&PDT1 *EQ '*') DO

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(88 +
                          132) LPI(8) OVRFLW(82) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) +
                          MAXRCDS(*NOMAX) IGCDTA(&PIGCD)

             OVRDBF     FILE(ABBWP24) TOFILE(ABBWP231)
             CALL       PGM(ABBR24) PARM('1' &PHIZ &PHZ1 &PHZ2 &PMM1 +
                          &PMM2 &PMM3 &PCD1 &PCD2 &PCD3 &PCD4)
             DLTF       FILE(ABBWP231)
             DLTOVR     FILE(*ALL)

             ENDDO

             /*------------------------------------------------*/
             /* PRODUCT DEMAND FORECAST NUMBER LESS 30 % DECREASE */
             /*                     FROM N MONTH  TO N+2 MONTH */
             /*------------------------------------------------*/
             IF         (&PDT2 *EQ '*') DO

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(88 +
                          132) LPI(8) OVRFLW(82) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) +
                          MAXRCDS(*NOMAX) IGCDTA(&PIGCD)

             OVRDBF     FILE(ABBWP24) TOFILE(ABBWP232)
             CALL       PGM(ABBR24) PARM('2' &PHIZ &PHZ1 &PHZ2 &PMM1 +
                          &PMM2 &PMM3 &PCD1 &PCD2 &PCD3 &PCD4)
             DLTF       FILE(ABBWP232)
             DLTOVR     FILE(*ALL)

             ENDDO

             /*------------------------------------*/
             /*   ACTUAL NUMBER IS OVER 50 % INCREASE OF N MONTH   */
             /*------------------------------------*/
             IF         (&PDT3 *EQ '*') DO

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(88 +
                          132) LPI(8) OVRFLW(82) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) +
                          MAXRCDS(*NOMAX) IGCDTA(&PIGCD)

             OVRDBF     FILE(ABBWP24) TOFILE(ABBWP233)
             CALL       PGM(ABBR24) PARM('3' &PHIZ &PHZ1 &PHZ2 &PMM1 +
                          &PMM2 &PMM3 &PCD1 &PCD2 &PCD3 &PCD4)
             DLTF       FILE(ABBWP233)
             DLTOVR     FILE(*ALL)

             ENDDO

             ENDPGM
