             PGM        PARM(&LIN1 &LIN2)
             /*= UTLC96  ==============================================*/
             /*  PROGRAM    : DISPLAY MESSAGE - 30A X 2 LINES          */
             /*  WRITTEN    : 2023/06/28   BY JW                       */
             /*========================================================*/

             DCLF       FILE(UTLPW96 )
             DCL        VAR(&LIN1) TYPE(*CHAR) LEN(30)
             DCL        VAR(&LIN2) TYPE(*CHAR) LEN(30)

             CHGVAR     VAR(&XLIN1) VALUE(&LIN1)
             CHGVAR     VAR(&XLIN2) VALUE(&LIN2)

             SNDRCVF    RCDFMT(DSP01)

             ENDPGM
