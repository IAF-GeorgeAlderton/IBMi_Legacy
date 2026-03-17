             PGM
             /*** AFFC15 ************************************/
             /*   UPLOAD TTS.CSV FROM IFS DATA              */
             /*   LEC         2023.02.07                    */
             /***********************************************/
             DCL        VAR(&OK)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&REC)  TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&EFFDAT)  TYPE(*DEC)  LEN(8 0)
             DCL        VAR(&UPFLG)   TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&OK) VALUE('Y')

        /*********************************************************/
        /* clear workfiles...                                    */
        /*********************************************************/
             CLRPFM     FILE(AFFWP15)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(AFFWP16)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(AFFWP18)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(AFFWP19)
             MONMSG     MSGID(CPF0000)

STP1:   /*********************************************************/
        /* upload TTS.csv --> AS400 AFFWP15                      */
        /*********************************************************/
             CPYFRMIMPF +
                          FROMSTMF('QNTC/IAF-AS400-FILE/AS400-TRANS/P+
                          C/Upload/TTS.csv') +
                          TOFILE(AFFWP15) MBROPT(*REPLACE) +
                          FROMCCSID(*FILE) RCDDLM(*CRLF) +
                          STRDLM(*DBLQUOTE) DATFMT(*USA) +
                          TIMFMT(*USA) ERRRCDOPT(*REPLACE)
             MONMSG     MSGID(CPF2817) EXEC(GOTO CMDLBL(@ERR1))

STP2:   /* Check if 0 record or not */
             CHGVAR     VAR(&REC) VALUE(0)
             RTVMBRD    FILE(AFFWP15) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             GOTO CMDLBL(@ERR1)
             ENDDO

        /*********************************************************/
        /* get effective date and check for valid headers...     */
        /*********************************************************/
             CALL       PGM(AFFR15D) PARM(&EFFDAT &UPFLG)

             IF         COND(&UPFLG = 'Y') THEN(DO)
        /*********************************************************/
        /* process uploaded truck schedule csv file...           */
        /*********************************************************/

/*  create workfiles from csv...*/
                        CALL       PGM(AFFR15) PARM(&EFFDAT)

/*  update toyota route/bin schedule file...*/
                        CALL       PGM(AFFR16) PARM(&EFFDAT)

/*  update toyota canada bin schedule file...*/
                        CALL       PGM(AFFR18) PARM(&EFFDAT)

/*  update toyota delv/route/dock schedule...*/
                        CALL       PGM(AFFR19) PARM(&EFFDAT)

/*  update orders received before eff date & ship date after eff date*/
                        CALL       PGM(AFFR15U) PARM(&EFFDAT)

                        ENDDO

             GOTO CMDLBL(@EXIT)

@ERR1:
             CALL       PGM(QUILNGTX) PARM('CHECK TTS.CSV. FILE +
                          NOT READY OR FILE IS OPENED.' +
                          X'00000046' ' ' ' ' X'00000000')
             CHGVAR     VAR(&OK) VALUE('N')
             GOTO CMDLBL(@EXIT)

@EXIT:
             ENDPGM
