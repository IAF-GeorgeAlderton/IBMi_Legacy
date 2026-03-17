             PGM
/** AB#C0645O *********************************************/
/*  (TEST) FIRM UPLOAD FOR TAKUMI(0645)                   */
/**********************************************************/
             DCL        VAR(&PSIRE)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB )  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PID  )  TYPE(*CHAR) LEN(1)
             DCL        VAR(&SR   )  TYPE(*CHAR) LEN(2)

             CHGVAR     VAR(&PSIRE) VALUE('0645')
             CHGVAR     VAR(&WLIB ) VALUE('TWFILE1 ')

/* TAKUMI OHIO ****************************************************/
             IF         COND(&PSIRE *EQ '0645') THEN(DO)
             CHGVAR     VAR(&SR) VALUE('TA')
             CHKOBJ     OBJ(TWFILE1/TAKUMI) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(@SKP1))

             CLRPFM     FILE(TWFILE1/AB#WTAK)

             OVRDBF     FILE(TAKUMI) TOFILE(TWFILE1/TAKUMI)
             OVRDBF     FILE(AB#WTAK) TOFILE(TWFILE1/AB#WTAK)

             CALL       PGM(A#R0645O) PARM(&PID)
             ENDDO
/* TAKUMI OHIO END ************************************************/

  @SKP1:
             ENDPGM
