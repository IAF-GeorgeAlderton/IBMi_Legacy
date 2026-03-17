             PGM
             /** GCAC30 ******************************/
             /*   DIE UNIT PRICE M/F UPDATE.AN (ESTIMATION)   */
             /* I-HASADA              93.03.09       */
             /****************************** GCAC30 **/
             DCL        VAR(&WS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&KB) TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9)
             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG) SWS(00000000)

             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&KB) VALUE('1')
             CHGVAR     VAR(&FILE1) VALUE('GCAWP30' *CAT &WS)

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE/&FILE1) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(1000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(GCAWP30) TOFILE(&FILE1)
             CALL       PGM(GCAR30) PARM(&USER)
             DLTOVR     FILE(GCAWP30)

             IF         (%SWITCH(0XXXXXXX)) DO
             DLTF       FILE(&FILE1)
             GOTO       END
             ENDDO

             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1)
             OVRDBF     FILE(GCAWP30) TOFILE(&FILE1)
             CALL       PGM(GCAR33) PARM(&USER &KB)
             DLTF       FILE(&FILE1)
             DLTOVR     FILE(*ALL)

 END:        ENDPGM
