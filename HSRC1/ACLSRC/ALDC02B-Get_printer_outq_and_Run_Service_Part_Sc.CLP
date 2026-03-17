             PGM        PARM(&WKCD &USR)
             /** ALDC02B *********************************/
             /* SERVICE PART SCAN PGM                    */
             /* LEC                01/29/2020            */
             /********************************************/

             DCL        VAR(&WKCD)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&USR)  TYPE(*CHAR) LEN(20)
             DCL        VAR(&DPT) TYPE(*CHAR) LEN(3) VALUE('SH')
             DCL        VAR(&PID)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&OUTQ)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)

  /*  call pgm to get outq for label printing...                       */
             CALL       PGM(UTLR692) PARM(&DPT &PID &OUTQ &RTN)

  /*  if user hit F1 to end program....                                */
             IF         COND(&RTN = '*') THEN(GOTO CMDLBL(#END))

             ADDLIBLE   LIB(TLABARCODE)
             MONMSG     MSGID(CPF0000)

  /*  call regular service part scan pgm, passing the outq for print...*/
             CALL       PGM(ALDR2S) PARM(&WKCD &USR &OUTQ)

             RMVLIBLE   LIB(TLABARCODE)
             MONMSG     MSGID(CPF0000)

 #END:

             ENDPGM
