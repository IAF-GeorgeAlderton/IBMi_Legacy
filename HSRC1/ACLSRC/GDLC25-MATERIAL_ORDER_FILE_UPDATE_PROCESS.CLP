             PGM
             /** GDLC25 *****************************/
             /*  MATERIAL ORDER FILE UPDATE PROCESS */
             /*               A.MAMIYA  2000.12.09  */
             /*               N.HYOTO   2001.03.19  */
             /* TCHK1 01/25/08 CHG PRINTER          */
             /***************************** GDLC25 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&P1)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&P2)    TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGVAR     VAR(&P1)    VALUE('1')
             CHGVAR     VAR(&P2)    VALUE(' ')
             CALL       PGM(GDLR99) PARM(&P1 &P2)

             IF         (&P2 *EQ '1') DO
             SNDPGMMSG  MSG('THIS PROGRAM IS OPENED ON OTHER  +
                          COMPUTER.PLEASE MAKE SURE THAT THIS +
                          PROGRAM IS CLOSED ON ALL OTHER +
                          COMPUTERS.') TOMSGQ(&WSID)
             GOTO END
             ENDDO

/*                                                                   */
/*           IF         (&P2 *EQ '2') DO                             */
/*           SNDPGMMSG  MSG('MATERIAL ORDER HAS BEEN PROCESSED FOR + */
/*                        TODAY.PLEASE TRY THIS PROCESS TOMORROW. +  */
/*                        ') TOMSGQ(&WSID)                           */
/*           GOTO END                                                */
/*           ENDDO                                                   */

             IF         (&P2 *EQ '3') DO
             SNDPGMMSG  MSG('IT HAS HAPPENED SYSTEMS ERROR. PLEASE +
                          CONTACT SYSTEMS PERSON.') TOMSGQ(&WSID)
             GOTO END
             ENDDO

             DLTF       FILE(GDLWP25)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/GDLWP25) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(1000 500 5) +
                          LVLCHK(*NO) AUT(*ALL)
             CALL       PGM(GDLR25) PARM(&USER)

             RTVMBRD    FILE(&WLIB/GDLWP25) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL(@END))
             DLTF       FILE(GDLWP26)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/GDLWP26) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(1000 500 5) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/GDLWP25)) +
                          OUTFILE(&WLIB/GDLWP26) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(GDLS25) +
                          OPTION(*NOPRT)

/* TCHK1 */  OVRPRTF    FILE(QPRINT) DEVTYPE(*AFPDS) PAGESIZE(66 80) +
                          LPI(6) RPLUNPRT(*YES) OUTQ(LANPRT03) +
                          FORMTYPE(K6S1)

             CALL       PGM(GDLR26) PARM(&USER)

             DLTOVR     FILE(QPRINT)

 @END:
             CHGVAR     VAR(&P1)    VALUE('2')
             CHGVAR     VAR(&P2)    VALUE(' ')
             CALL       PGM(GDLR99) PARM(&P1 &P2)

 END:
             ENDPGM
