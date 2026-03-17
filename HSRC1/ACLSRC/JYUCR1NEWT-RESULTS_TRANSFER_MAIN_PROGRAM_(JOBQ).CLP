             PGM

             DCL        VAR(&SUBLIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RSTFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ANS) TYPE(*CHAR) LEN(1)
/* JW1 */
             /*---------------------------*/
             /* TOYOTA WEB DATA (ADD ON)  */
             /*---------------------------*/
             CHGVAR     VAR(&SUBLIBL) VALUE('EDI_RST02 ')
             CHGVAR     VAR(&RSTFILE) VALUE('RESULT    ')
             CHGVAR     VAR(&ANS) VALUE(' ')
             CALL       PGM(JYUCR2) PARM(&SUBLIBL &RSTFILE &ANS)
             OVRDBF     FILE(INPUT) TOFILE(&SUBLIBL/&RSTFILE)

             IF         COND(&ANS *EQ '0') THEN(DO)
             CPYF       FROMFILE(&SUBLIBL/&RSTFILE) +
                          TOFILE(&SUBLIBL/RESULTTEST) MBROPT(*ADD) +
                          CRTFILE(*YES) FMTOPT(*NOCHK)
             CALL       PGM(JYUC1B)
             ENDDO
             DLTOVR     FILE(*ALL)

#END:        ENDPGM
