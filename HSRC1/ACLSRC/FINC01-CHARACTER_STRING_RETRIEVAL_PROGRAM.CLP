             PGM        PARM(&LIBL &FILE &CODE)
             /** FINC01 ****************************************/
             /*   ..CHARACTER STRING RETRIEVAL PROGRAM         */
             /*       A.MAMIYA                2001.01.29       */
             /**************************************** FINC01 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&WT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FILE01) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)    TYPE(*CHAR) LEN(8)
             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WT) VALUE(%SST(&WSID 1 5))

             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGVAR     VAR(&FILE01) VALUE('FWP01' *CAT &WT)
             DLTF       FILE(&WLIB/&FILE01)
             MONMSG     MSGID(CPF3261 CPF2105)
             DSPFD      FILE(&LIBL/&FILE) TYPE(*ATR) +
                          OUTPUT(*OUTFILE) FILEATR(*PF) +
                          OUTFILE(&WLIB/&FILE01)
             MONMSG     MSGID(CPF0000)

             CHKOBJ     OBJ(&WLIB/&FILE01) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(END))

             RTVMBRD    FILE(&WLIB/&FILE01) NBRCURRCD(&REC)
             IF         COND(&REC *NE 0) THEN(DO)
             OVRDBF     FILE(FINWP01) TOFILE(&WLIB/&FILE01)
             CALL       PGM(FINR02) PARM(&CODE)
             DLTOVR     FILE(FINWP01)
             ENDDO

             DLTF       FILE(&WLIB/&FILE01)
             MONMSG     MSGID(CPF3261 CPF2105)

 END:        ENDPGM
