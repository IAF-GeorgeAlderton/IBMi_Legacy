             PGM        PARM(&LIN1 &LIN2)
             /*= UTLC96  ===================================================*/
             /*  PROGRAM    : DISPLAY MESSAGE - 60A X 2 LINES  (MSG ONLY)   */
             /*  WRITTEN    : JW  2024/05/28                                */
             /*=============================================================*/

             DCLF       FILE(UTLPW97A)
             DCL        VAR(&LIN1) TYPE(*CHAR) LEN(60)
             DCL        VAR(&LIN2) TYPE(*CHAR) LEN(60)

             CHGVAR     VAR(&XLIN1) VALUE(&LIN1)
             CHGVAR     VAR(&XLIN2) VALUE(&LIN2)

             SNDRCVF    RCDFMT(DSP01)

             ENDPGM
