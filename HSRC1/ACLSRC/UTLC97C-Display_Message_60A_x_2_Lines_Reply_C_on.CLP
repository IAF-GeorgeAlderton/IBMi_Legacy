             PGM        PARM(&LIN1 &LIN2)
             /*= UTLC97C ===================================================*/
             /*  PROGRAM    : DISPLAY MESSAGE - 60A X 2 LINES AND ANSWER C  */
             /*  WRITTEN    : 2024/04/25   BY JW                            */
             /*=============================================================*/

             DCLF       FILE(UTLPW97C)
             DCL        VAR(&LIN1) TYPE(*CHAR) LEN(60)
             DCL        VAR(&LIN2) TYPE(*CHAR) LEN(60)

             CHGVAR     VAR(&XLIN1) VALUE(&LIN1)
             CHGVAR     VAR(&XLIN2) VALUE(&LIN2)
             CHGVAR     VAR(&XANS ) VALUE('C')

             SNDRCVF    RCDFMT(DSP01)

             ENDPGM
