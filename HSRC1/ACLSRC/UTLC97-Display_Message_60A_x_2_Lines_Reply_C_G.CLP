             PGM        PARM(&LIN1 &LIN2 &ANS)
             /*= UTLC96  ===================================================*/
             /*  PROGRAM    : DISPLAY MESSAGE - 60A X 2 LINES AND ANSWER    */
             /*  WRITTEN    : 2023/09/01   BY JW                            */
             /*=============================================================*/

             DCLF       FILE(UTLPW97 )
             DCL        VAR(&LIN1) TYPE(*CHAR) LEN(60)
             DCL        VAR(&LIN2) TYPE(*CHAR) LEN(60)
             DCL        VAR(&ANS)  TYPE(*CHAR) LEN(1) VALUE(' ')

             CHGVAR     VAR(&XLIN1) VALUE(&LIN1)
             CHGVAR     VAR(&XLIN2) VALUE(&LIN2)
             CHGVAR     VAR(&XANS ) VALUE('C')

             SNDRCVF    RCDFMT(DSP01)

             CHGVAR     VAR(&ANS  ) VALUE(&XANS)

             ENDPGM
