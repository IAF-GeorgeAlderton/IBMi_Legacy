             PGM
             /** GDLC40 ***********************/
             /*  MATERIAL ORDER VALIOUS LIST  */
             /*          K.YASUDA  2000.08.21 */
             /*********************** GDLC40 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PNO) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             DLTF       FILE(&WLIB/GDLWP4A)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/GDLWP4A) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(10000 5000 5) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(GDLR40) PARM(&PNO)

             IF         COND(%SWITCH(1XXXXXXX)) THEN(DO)
             GOTO       END
             ENDDO

             IF         COND((&PNO *EQ '1') *OR (&PNO *EQ '2')) +
                          THEN(DO)

             DLTF       FILE(&WLIB/GDLWP4B)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/GDLWP4B) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(10000 5000 5) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/GDLWP4A)) +
                          OUTFILE(&WLIB/GDLWP4B) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(GDLS40) +
                          OPTION(*NOPRT)
             DLTF       FILE(&WLIB/GDLWP4A)
             MONMSG     MSGID(CPF3261 CPF2105)
             ENDDO

             OVRPRTF    FILE(QPRINT) DEVTYPE(*SCS) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1)

             IF         COND(&PNO *EQ '1') THEN(DO)
             CALL       PGM(GDLR41) PARM(&USER)
             ENDDO

             IF         COND(&PNO *EQ '2') THEN(DO)
             CALL       PGM(GDLR42) PARM(&USER)
             ENDDO

             DLTF       FILE(&WLIB/GDLWP4B)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTOVR     FILE(*ALL)
 END:        ENDPGM
