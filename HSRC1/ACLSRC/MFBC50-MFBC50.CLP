             PGM
             /*- MFBC50 ------------------------------------*/
             /* INPUT OF  WORK DAILY BULLETIN DATA          */
             /*         << PC TO AS400 >>                   */
             /* CODING:K.OKACHI    2002.06.11               */
             /*------------------------------------ MFBC50 -*/
             DCLF       FILE(MFBPW50)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)

             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0) VALUE(0)


             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGVAR     VAR(&IN99) VALUE('0')
 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(MFBPW501)
             IF         (&IN01 *EQ '1') GOTO @END
             IF         (&IN05 *EQ '0') GOTO STP1

             CHKOBJ     OBJ(&WLIB/MFBWP50) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(&WLIB/MFBWP50) RCDLEN(512) +
                          TEXT('WORK DALIY DATA (THIS FILE DO NOT +
                          DELETE)') OPTION(*NOLIST) AUT(*ALL))
             RTVMBRD    FILE(&WLIB/MFBWP50) NBRCURRCD(&REC)
             IF (&REC *NE 0) DO
                 CLRPFM     FILE(MFBPP50)
                 MONMSG     MSGID(CPF0000)
                 CPYFRMIMPF FROMFILE(&WLIB/MFBWP50) TOFILE(MFBPP50)
                 CALL MFBR50
                 CLRPFM     FILE(&WLIB/MFBWP50)
                 MONMSG     MSGID(CPF0000)
             ENDDO
             ELSE DO
             CHGVAR     VAR(&IN99) VALUE('1')
             GOTO       STP1
             ENDDO

@END:
             ENDPGM
