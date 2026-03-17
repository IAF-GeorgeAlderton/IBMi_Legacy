             PGM
             /** ADHC40 ***************************/
             /* TRANSMIT OF HEAT TREATMENT RECORD */
             /* CREATE DATE  2000.09.27  A.MAMIYA */
             /*************************** ADHC40 **/
             DCLF       FILE(ADHPW40)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0) VALUE(0)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)

             CALL       PGM(ALBC00) PARM(&USER &WLIB)

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(ADHPW401)

             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(END))
             IF         (&IN05 *EQ '0') GOTO STP1

             CHGVAR     VAR(&IN99) VALUE('0')
             CHGVAR     VAR(&ERR) VALUE(*BLANK)


/*           STRPCO     PCTA(*NO)                                 */
/*           MONMSG     MSGID(CPF0000)                            */
/*           STRPCCMD   PCCMD('"PCSFT5.EXE" IAFR.TFR') PAUSE(*NO) */

             CHGVAR     VAR(&REC) VALUE(0)
             RTVMBRD    FILE(ADHWP40) NBRCURRCD(&REC)

             IF         COND(&REC *EQ 0) THEN(DO)
             CHGVAR     VAR(&ERR) +
                          VALUE('TRANSMITTING OF DATA IS FAILED')
             CHGVAR     VAR(&IN99) VALUE('1')
             GOTO       CMDLBL(STP1)
             ENDDO

             CALL       PGM(ADHR40) PARM(&USER)

 END:        DLTOVR     FILE(*ALL)
             DLTF       FILE(ADHWP40)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/ADHWP40) RCDLEN(300) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             ENDPGM
