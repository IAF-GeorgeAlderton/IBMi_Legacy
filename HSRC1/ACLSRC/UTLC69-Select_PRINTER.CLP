             PGM        PARM(&FILE &TEXT)

             DCL        VAR(&FILE) TYPE(*CHAR) LEN(08)
             DCL        VAR(&TEXT) TYPE(*CHAR) LEN(40)
             DCL        VAR(&RTN ) TYPE(*CHAR) LEN(01)
             DCL        VAR(&OUTQ) TYPE(*CHAR) LEN(10)

/*  SET PRINTER FILE */
             IF         COND(&FILE *EQ ' ') THEN(DO)
             CHGVAR     VAR(&FILE) VALUE('QPRINT  ')
             ENDDO

/*  SELECT PRINTER */
             CALL       PGM(UTLR69) PARM(&OUTQ &RTN )
             IF         COND(&RTN  *EQ '*') THEN(DO)
             CHGVAR     VAR(&OUTQ) VALUE('EPRINT1')
             ENDDO

/*  SET PRINTER TO OUTQ */
             OVRPRTF    FILE(&FILE) OUTQ(&OUTQ)
             CHGVAR     VAR(&TEXT) VALUE('OVRPRTF FILE(' *CAT &FILE +
                          *CAT ') OUTQ(' *CAT &OUTQ *CAT ')')

 ENDP:       ENDPGM
