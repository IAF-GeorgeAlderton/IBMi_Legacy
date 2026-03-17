             PGM        PARM(&MSG1 &MSG2 &MSG3)
             /*= UTLC963 ==============================================*/
             /*  PROGRAM    : DISPLAY MESSAGE - 30A X 3 LINES          */
             /*  WRITTEN    : 2023/06/30   BY JW                       */
             /*========================================================*/

             DCLF       FILE(UTLPW963)
             DCL        VAR(&MSG1) TYPE(*CHAR) LEN(30)
             DCL        VAR(&MSG2) TYPE(*CHAR) LEN(30)
             DCL        VAR(&MSG3) TYPE(*CHAR) LEN(30)

             CHGVAR     VAR(&XLIN1) VALUE(&MSG1)
             CHGVAR     VAR(&XLIN2) VALUE(&MSG2)
             CHGVAR     VAR(&XLIN3) VALUE(&MSG3)

             SNDRCVF    RCDFMT(DSP01)

             ENDPGM
