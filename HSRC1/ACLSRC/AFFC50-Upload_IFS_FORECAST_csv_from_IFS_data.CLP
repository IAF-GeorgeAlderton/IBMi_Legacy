             PGM
             /*** AFFC50 ************************************/
             /*   UPLOAD IFS.FORECAST.CSV FROM IFS DATA     */
             /*   JW (SRA)    2023.03.09                    */
             /***********************************************/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&UPFLG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NONY ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PFLG ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&KEN )  TYPE(*DEC ) LEN(10 0)
             DCL        VAR(&NBR )  TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTN1)  TYPE(*CHAR) LEN(1)

/* CHECK OTHER USER IS USING  ======================================*/
             CALL       PGM(CHKC45) PARM('AFFC50' 'AFFC50' 'Y' 'CHK' &RTN1)
             IF         COND(&RTN1 *NE ' ') THEN(GOTO @ENDP )
/* =================================================================*/

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             DLTF       FILE(QTEMP/AFFWP50)
             MONMSG     MSGID(CPF2105)

             DLTF       FILE(QTEMP/AFFWP51)
             MONMSG     MSGID(CPF2105)

             CHKOBJ     OBJ(&WLIB/AFFWP50) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDUPOBJ  OBJ(AFFWP50) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             ENDDO

             CHKOBJ     OBJ(&WLIB/AFFWP51) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDUPOBJ  OBJ(AFFWP51) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             ENDDO

             OVRDBF     FILE(AFFWP50) TOFILE(QTEMP/AFFWP50)
             OVRDBF     FILE(AFFWP51) TOFILE(QTEMP/AFFWP51)
             CALL       PGM(AFFR50) PARM(&UPFLG &NONY)

/* SKIP TO ENDP WHEN NO DATA TO UPLOAD */
             IF         COND(&UPFLG *NE 'Y') THEN(GOTO CMDLBL(@ENDP2))

  /* ======= UPLOAD TO FORECAST  =========*/
             /* SAVE AFFWP50 TO AFFWP50S */
             CALL       PGM(AFFR53)

             CALL       PGM(AFFC52) PARM(&NONY)

             IF         (%SWITCH(0XXXXXXX)) DO
             CALL       PGM(QUILNGTX) PARM('!! ORDERES HAVE NOT BEEN +
                          PROCESSED !!' +
                          X'00000046' ' ' ' ' X'00000000')
             GOTO CMDLBL(@ENDP2)
             ENDDO

 @ENDP2:
             CALL       PGM(CHKC45) PARM('AFFC50' 'AFFC50' 'N' '' '')

 @ENDP:      DLTOVR     FILE(*ALL)
             ENDPGM
