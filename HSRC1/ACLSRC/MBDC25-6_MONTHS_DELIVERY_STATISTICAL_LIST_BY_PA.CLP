             PGM
             /*** MBDC25 ******************************************/
             /*  6  MONTHS DELIVERY STATISTICAL LIST BY PART NUMBER */
             /****************************************** MBDC25 ***/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MM) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MCEDP01) TYPE(*CHAR) LEN(8)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)

             RTVDTAARA  DTAARA(MCEDP01) RTNVAR(&MCEDP01)
             CHGVAR     VAR(&MM) VALUE(%SST(&MCEDP01 5 2))

             RTVJOBA    JOB(&WSID)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGVAR     VAR(&WS) VALUE(%SUBSTRING(&WSID 1 2))
             CHGVAR     VAR(&FILE1) VALUE('MBDWP25' *CAT &WS)

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(MBDWP25) +
                          OPTION(*NOLIST *NOSRC) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(MBDWP25) TOFILE(&FILE1)
             CALL       PGM(MBDR25)
             IF         (%SWITCH(0XXXXXXX)) DO
             GOTO       END
             ENDDO

             OVRPRTF    FILE(QPRINT) TOFILE(*FILE) DEVTYPE(&PDEVT) +
                          PAGESIZE(66 132) LPI(6) OVRFLW(62) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          COPIES(1) IGCDTA(&PIGCD)
             CALL       PGM(MBDR26) PARM(&MM)
             DLTOVR     FILE(QPRINT)

 END:        ENDPGM
