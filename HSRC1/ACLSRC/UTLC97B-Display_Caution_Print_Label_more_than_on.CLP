             PGM        PARM(&SERL &ANS)
             /*= UTLC97B ===================================================*/
             /*  PROGRAM    : DISPLAY CAUTION - PRINT LABEL MORE THAN ONCE  */
             /*  WRITTEN    : 2025/01/21   BY JW                            */
             /* ----------------------------------------                    */
             /*  CALLING SEQ.                                               */
             /*                    CALL 'UTLC97B'                           */
             /*                    PARM           $SERL   9                 */
             /*                    PARM           $ANS    1                 */
             /*   IN  $SERL:  9A PACKING LIST#                              */
             /*   OUT $ANS :  1A (P: PRINT, C: CANCEL)                      */
             /*=============================================================*/
             DCLF       FILE(UTLPW97B)
             DCL        VAR(&SERL) TYPE(*CHAR) LEN(9)
             DCL        VAR(&STT)  TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&ANS)  TYPE(*CHAR) LEN(1) VALUE(' ')

/* IF &SERL = BLANK, PRINT LABEL */
             IF         COND(&SERL *EQ ' ') THEN(DO)
             CHGVAR     VAR(&XANS ) VALUE('P')
             GOTO       ENDP
             ENDDO

/* IF &SERL NOT = BLANK, CHECK IF IT HAS BEEN PRINTED BEFORE */
             IF         COND(&SERL *NE ' ') THEN(DO)
             CALL       PGM(UEXR55A) PARM(&SERL &STT)
             IF         COND(&STT *EQ 'N') THEN(DO)
             CHGVAR     VAR(&XANS ) VALUE('P')
             GOTO       ENDP
             ENDDO
             ENDDO

             CHGVAR     VAR(&XANS ) VALUE('C')
DSP01:
             SNDRCVF    RCDFMT(DSP01)

             IF         COND((&XANS *NE 'C') *AND (&XANS *NE 'P')) THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('Enter C or P !')
             GOTO       DSP01
             ENDDO
ENDP:
             CHGVAR     VAR(&ANS  ) VALUE(&XANS)

             ENDPGM
