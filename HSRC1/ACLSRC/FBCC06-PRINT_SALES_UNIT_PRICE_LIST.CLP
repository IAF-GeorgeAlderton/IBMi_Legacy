             PGM
             /** FBCC06 ************************************/
             /* ..SALES UNIT PRICE MASTER LIST..           */
             /*   MSK KUNIEDA       2000.03.31             */
             /*  JW1  2018.10.19 ADD PRINTER SELECTION     */
             /**********************************************/

             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FIL1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL2) TYPE(*CHAR) LEN(9)

/*JW1*/      DCL        VAR(&PTR ) TYPE(*CHAR) LEN(1)
/*JW1*/      DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
/*JW1*/      DCL        VAR(&WLIB) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&FIL1) VALUE(FBCWP06 *CAT &WS)
             CHGVAR     VAR(&FIL2) VALUE(FBCWP07 *CAT &WS)

             DLTF       FILE(&WLIB/&FIL1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FIL1) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(30000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(FBCWP06) TOFILE(&WLIB/&FIL1)
             CALL       PGM(FBCR06) PARM(&PTR)
             DLTOVR     FILE(FBCWP06)

             IF         (%SWITCH(0XXXXXXX)) DO
             DLTF       FILE(&WLIB/&FIL1)
             GOTO       END
             ENDDO

             DLTF       FILE(&WLIB/&FIL2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FIL2) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(30000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/&FIL1)) +
                          OUTFILE(&WLIB/&FIL2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(FBCS07) +
                          OPTION(*NOPRT)
             DLTF       FILE(&WLIB/&FIL1)
 /*JW1 SET OUTQ */
             IF COND(&PTR = '1') THEN(CHGVAR VAR(&PRTG) VALUE('LANPRT50'))
             IF COND(&PTR = '2') THEN(CHGVAR VAR(&PRTG) VALUE('LANPRT03'))

             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1)

             OVRDBF     FILE(FBCWP07) TOFILE(&WLIB/&FIL2)

             CALL       PGM(FBCR07)
             DLTF       FILE(&WLIB/&FIL2)
             DLTOVR     FILE(*ALL)

 END:        ENDPGM
