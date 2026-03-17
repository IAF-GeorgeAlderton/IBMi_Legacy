             PGM
             /** IZAC65S2 **************************************/
             /*  PRINT WIRE SAMPLE TAGS                        */
             /*    LEC                      2025.11.18         */
             /**************************************************/

             DCL        VAR(&DPT) TYPE(*CHAR) LEN(3) VALUE('QD')
             DCL        VAR(&PID) TYPE(*CHAR) LEN(3)
             DCL        VAR(&OUTQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(1)

             CALL       PGM(UTLR692) PARM((&DPT) (&PID) (&OUTQ) (&RTN))
             IF         COND(&RTN *EQ '*') THEN(GOTO CMDLBL(#END))

             ADDLIBLE   LIB(TLABARCODE)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(IZAR465S2) PARM((&OUTQ))

             RMVLIBLE   LIB(TLABARCODE)
             MONMSG     MSGID(CPF0000)

 #END:       ENDPGM
