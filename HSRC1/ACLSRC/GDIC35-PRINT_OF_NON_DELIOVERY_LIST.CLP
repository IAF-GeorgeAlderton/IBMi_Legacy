             PGM
             /** GDIC35 ***********************/
             /*  PRINT OF NON-DELIOVERY LIST  */
             /*       K.YASUDA    2000.11.07  */
             /*       A.MAMIYA    2000.11.11  */
             /*********************** GDIC35 **/
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PNO) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSID) USER(&US)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&US &WLIB)
             CHGJOB     SWS(00000000)

             DLTF       FILE(&WLIB/GDIWP35)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/GDIWP35) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(*NOMAX) +
                          LVLCHK(*NO) AUT(*ALL)
             CALL       PGM(GDIR35) PARM(&PNO)


             IF         COND(%SWITCH(1XXXXXXX)) THEN(DO)
             GOTO       END
             ENDDO

             DLTF       FILE(&WLIB/GDIWP36)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/GDIWP36) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(*NOMAX) +
                          LVLCHK(*NO) AUT(*ALL)

             IF         COND((&PNO *EQ '1') *OR (&PNO *EQ '2')) +
                          THEN(DO)
             FMTDTA     INFILE((&WLIB/GDIWP35)) +
                          OUTFILE(&WLIB/GDIWP36) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(GDIS35) +
                          OPTION(*NOPRT)
             ENDDO
             IF         COND((&PNO *EQ '3') *OR (&PNO *EQ '4')) +
                          THEN(DO)
             FMTDTA     INFILE((&WLIB/GDIWP35)) +
                          OUTFILE(&WLIB/GDIWP36) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(GDIS36) +
                          OPTION(*NOPRT)
             ENDDO

             OVRPRTF    FILE(QPRINT) DEVTYPE(*SCS) PAGESIZE(*N 158) +
                          LPI(6) CPI(12) RPLUNPRT(*YES) OUTQ(&PRTG) +
                          FORMTYPE(K6H1)

             /*  NON-DELIVERY LIST  */
             IF         COND(&PNO *EQ '1') THEN(DO)
             CALL       PGM(GDIR36) PARM(&US)
             ENDDO

             /*  ORDER HISTORY LIST  */
             IF         COND(&PNO *EQ '2') THEN(DO)
             CALL       PGM(GDIR37) PARM(&US)
             ENDDO

             /*  NON-DELIVERY LIST  */
             IF         COND(&PNO *EQ '3') THEN(DO)
             CALL       PGM(GDIR38) PARM(&US)
             ENDDO

             /*  ORDER HISTORY LIST  */
             IF         COND(&PNO *EQ '4') THEN(DO)
             CALL       PGM(GDIR39) PARM(&US)
             ENDDO

 END:        DLTF       FILE(&WLIB/GDIWP36)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(&WLIB/GDIWP35)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTOVR     FILE(*ALL)
             ENDPGM
