             PGM
             /** FINC00 ****************************************/
             /*   ..CHARACTER STRING RETRIEVAL PROGRAM       */
             /*       A.MAMIYA                2001.01.27       */
             /**************************************** FINC00 **/
             DCLF       FILE(FINPW00)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MOJI) TYPE(*CHAR) LEN(50)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&WT) TYPE(*CHAR) LEN(5)
             DCL        VAR(&FILE00) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE03) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)    TYPE(*CHAR) LEN(8)
             RTVJOBA    JOB(&WSID)  USER(&USER)
             CHGJOB     SWS(00000000)
             CHGVAR     VAR(&WT) VALUE(%SST(&WSID 1 5))

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGVAR     VAR(&FILE03) VALUE('FWP03' *CAT &WT)
             DLTF       FILE(&WLIB/&FILE03)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE03) RCDLEN(256)

             CALL       PGM(FINR00) PARM(&MOJI &LIBL)

             IF         COND(%SWITCH(XX1XXXXX)) THEN(GOTO CMDLBL(@END))

             IF         (%SWITCH(1XXXXXXX)) DO

             CHGVAR     VAR(&FILE00) VALUE('FWP00' *CAT &WT)
             DLTF       FILE(&WLIB/&FILE00)
             MONMSG     MSGID(CPF3261 CPF2105)
             DSPOBJD    OBJ(&LIBL/*ALL) OBJTYPE(*FILE) +
                          OUTPUT(*OUTFILE) OUTFILE(&WLIB/&FILE00)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(FINWP00) TOFILE(&WLIB/&FILE00)
             CALL       PGM(FINR01) PARM(&MOJI)
             DLTOVR     FILE(FINWP00)

             DLTF       FILE(&WLIB/&FILE00)
             MONMSG     MSGID(CPF3261 CPF2105)

             ENDDO

             RTVMBRD    FILE(&WLIB/&FILE03) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             SNDBRKMSG  MSG('THERE IS NO MEMBER CORRESPONDING TO +
                          THE RETRIEVAL CHARACTER STRING.') +
                          TOMSGQ(&WSID)
             ENDDO
             IF         COND(&REC *NE 0) THEN(DO)
             OVRPRTF    FILE(QPRINT) OUTQ(&PRTG) HOLD(*YES)
             OVRDBF     FILE(FINWP03) TOFILE(&WLIB/&FILE03)
             CALL       PGM(FINR04)
             DLTOVR     FILE(FINWP03)
             DLTOVR     FILE(QPRINT)
             ENDDO

 @END:
             ENDPGM
