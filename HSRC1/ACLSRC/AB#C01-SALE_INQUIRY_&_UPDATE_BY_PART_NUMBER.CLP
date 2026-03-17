             PGM
             /** AB#C01 ****************************/
             /*   SALE   INQUIRY & UPDATE BY PART NUMBER  */
             /* I-HASADA              89.03.29     */
             /**************************** AB#C01 **/
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PSHZ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PEHZ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PHZ) TYPE(*CHAR) LEN(80)
             DCL        VAR(&PSHIN) TYPE(*CHAR) LEN(12)
             DCL        VAR(&PYN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FIL1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL2) TYPE(*CHAR) LEN(9)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WSID) USER(&US)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&FIL1) VALUE('AB#WP02' *CAT &WS)
             CHGVAR     VAR(&FIL2) VALUE('AB#WP03' *CAT &WS)

             DLTF       FILE(&FIL1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FIL1) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AB#WP02) TEXT('SALES INQUIRY BY  +
                          PART NUMBER WORKFILE') OPTION(*NOLIST +
                          *NOSRC) SIZE(*NOMAX) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&FIL2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FIL2) RCDLEN(200) +
                          TEXT('SALES INQUIRY WORKFILE BY PART NUMBER') +
                          OPTION(*NOLIST *NOSRC) SIZE(*NOMAX) +
                          LVLCHK(*NO) AUT(*ALL)

 STP1:       CHGJOB     OUTQ(&PRTG)
             CHGJOB     SWS(00000000)

             CALL       PGM(AB#R01) PARM(&PSHZ &PEHZ &PHZ)
             IF         (%SWITCH(1XXXXXXX)) DO
             GOTO       END
             ENDDO

 STP2:       CHGJOB     OUTQ(&PRTG)
             CHGJOB     SWS(00000000)

             CLRPFM     FILE(&FIL1)

             OVRDBF     FILE(AB#WP02) TOFILE(&FIL1)
             CALL       PGM(AB#R02) PARM(&PSHZ &PEHZ &PSHIN &PYN)
             IF         (%SWITCH(1XXXXXXX)) DO
             GOTO       END
             ENDDO

             IF         (%SWITCH(XX1XXXXX)) GOTO STP1

             CLRPFM     FILE(&FIL2)

             OVRDBF     FILE(AB#WP03) TOFILE(&FIL2)
             CALL       PGM(AB#R03) PARM(&PHZ)

             CHGJOB     OUTQ(&PRTG)
             CHGJOB     SWS(00000000)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
             CALL       PGM(AB#R04) PARM(&US &PSHZ &PEHZ &PHZ &PSHIN)

             IF         (&PYN *EQ 'Y') DO
             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD)
             CALL       PGM(AB#R05) PARM(&US &PHZ &PSHIN)
             ENDDO

             IF         (%SWITCH(0XXXXXXX)) GOTO STP2

 END:        DLTOVR     FILE(*ALL)

             DLTF       FILE(&FIL1)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(&FIL2)
             MONMSG     MSGID(CPF3261 CPF2105)

 SEND:       ENDPGM
