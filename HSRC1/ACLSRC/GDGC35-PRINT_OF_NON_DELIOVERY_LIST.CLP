             PGM
             /** GDGC35 ***********************/
             /*  PRINT OF NON-DELIOVERY LIST  */
             /*       K.YASUDA    2000.11.01  */
             /*       A.MAMIYA    2000.11.11  */
             /*********************** GDGC35 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PNO) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)
             CHGJOB     SWS(00000000)

             DLTF       FILE(&WLIB/GDGWP35)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/GDGWP35) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(10000 5000 5) +
                          LVLCHK(*NO) AUT(*ALL)
             CALL       PGM(GDGR35) PARM(&PNO)


             IF         COND(%SWITCH(1XXXXXXX)) THEN(DO)
             GOTO       END
             ENDDO

             DLTF       FILE(&WLIB/GDGWP36)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/GDGWP36) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(10000 5000 5) +
                          LVLCHK(*NO) AUT(*ALL)

             IF         COND((&PNO *EQ '1') *OR (&PNO *EQ '2')) +
                          THEN(DO)
             FMTDTA     INFILE((&WLIB/GDGWP35)) +
                          OUTFILE(&WLIB/GDGWP36) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(GDGS35) +
                          OPTION(*NOPRT)
             ENDDO
             IF         COND((&PNO *EQ '3') *OR (&PNO *EQ '4')) +
                          THEN(DO)
             FMTDTA     INFILE((&WLIB/GDGWP35)) +
                          OUTFILE(&WLIB/GDGWP36) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(GDGS36) +
                          OPTION(*NOPRT)
             ENDDO

             OVRPRTF    FILE(QPRINT) DEVTYPE(*SCS) PAGESIZE(*N 158) +
                          LPI(6) CPI(12) RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(K6H1)

             IF         COND(&PNO *EQ '1') THEN(DO)
             CALL       PGM(GDGR36) PARM(&USER)
             ENDDO

             IF         COND(&PNO *EQ '2') THEN(DO)
             CALL       PGM(GDGR37) PARM(&USER)
             ENDDO

             IF         COND(&PNO *EQ '3') THEN(DO)
             CALL       PGM(GDGR38) PARM(&USER)
             ENDDO

             IF         COND(&PNO *EQ '4') THEN(DO)
             CALL       PGM(GDGR39) PARM(&USER)
             ENDDO

 END:      /*DLTF       FILE(&WLIB/GDGWP36)*/
           /*MONMSG     MSGID(CPF3261 CPF2105)*/
             DLTF       FILE(&WLIB/GDGWP35)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTOVR     FILE(*ALL)
             ENDPGM
