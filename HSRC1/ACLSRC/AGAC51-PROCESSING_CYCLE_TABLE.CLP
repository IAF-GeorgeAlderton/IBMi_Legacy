             PGM
             /** AGAC51 **************************************/
             /*        PROCESSING CYCLE TABLE                */
             /*                   WRITTEN ==> S.OOTAKE       */
             /*                   UPDATE  ==> 1993/07/09     */
             /************************************** AGAC51 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSNO) USER(&USER)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)

             DLTF       FILE(AGAWP51)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/AGAWP51) RCDLEN(45) +
                          OPTION(*NOLIST) SIZE(9999 100 3) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(AGAR52)
             IF         (%SWITCH(0XXXXXXX)) DO
             GOTO       CMDLBL(END)
             ENDDO

             DLTF       FILE(AGAWP52)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/AGAWP52) RCDLEN(45) +
                          OPTION(*NOLIST) SIZE(9999 100 3) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((HWFILE1/AGAWP51)) +
                          OUTFILE(HWFILE1/AGAWP52) SRCFILE(FMTSRC) +
                          SRCMBR(AGAS51) OPTION(*NOPRT)

             DLTF       FILE(AGAWP51)

             OVRPRTF    FILE(AGAPR51) DEVTYPE(*AFPDS) LPI(6) +
                          OVRFLW(62) RPLUNPRT(*YES) OUTQ(QPRINTA) +
                          FORMTYPE(K6H1)
             CALL       PGM(AGAR51) PARM(&USER)
             DLTF       FILE(AGAWP52)
             DLTOVR     FILE(*ALL)

END:         ENDPGM
