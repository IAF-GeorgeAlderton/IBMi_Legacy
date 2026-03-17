             PGM        PARM(&FILE &TEXT &RTN)
     /** UTLC69B *********************************************/
     /*  UTILITY- SELECT PRINTER OPTION WITH DOWNLOAD        */
     /*  JW       2024.01.04                                 */
     /********************************************************/

             DCL        VAR(&FILE) TYPE(*CHAR) LEN(08)
             DCL        VAR(&TEXT) TYPE(*CHAR) LEN(40)
             DCL        VAR(&RTN ) TYPE(*CHAR) LEN(01)
             DCL        VAR(&OUTQ) TYPE(*CHAR) LEN(10)

/*  SET PRINTER FILE */
             IF         COND(&FILE *EQ ' ') THEN(DO)
             CHGVAR     VAR(&FILE) VALUE('QPRINT  ')
             ENDDO

/*  SELECT PRINTER */
             CALL       PGM(UTLR69B) PARM(&OUTQ &RTN )
             IF         COND(&RTN  *EQ '*') THEN(DO)
             CHGVAR     VAR(&OUTQ) VALUE('EPRINT1')
             ENDDO

/*  SET PRINTER TO OUTQ */
             IF         COND(&RTN  *NE 'X') THEN(DO)
             OVRPRTF    FILE(&FILE) OUTQ(&OUTQ)
             CHGVAR     VAR(&TEXT) VALUE('OVRPRTF FILE(' *CAT &FILE +
                          *CAT ') OUTQ(' *CAT &OUTQ *CAT ')')
             ENDDO

 ENDP:       ENDPGM
