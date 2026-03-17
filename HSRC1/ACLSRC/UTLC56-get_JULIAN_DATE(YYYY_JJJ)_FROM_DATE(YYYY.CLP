             PGM        PARM(&DAT8 &JUL7)
             /** UTLC56 ****************************************/
             /*  GET JULIAN DATE(YYYY+JJJ) FROM YYYYMMDD       */
             /*  J.WATANABE 2022.11.14                         */
             /* ------------------------------------------     */
             /*  CALLING SEQ.                                  */
             /*                    CALL 'UTLC56 '              */
             /*                    PARM           $DAT8   8    */
             /*                    PARM           $JUL7   7    */
             /*   IN  $DAT8   8A FROM DATE (YYYYMMDD)          */
             /*                  (BLANK=TODAY)                 */
             /*   OUT $JUL7   7A CONVERT TO JUL (YYYY+JUL3)    */
             /**************************************************/

             DCL        VAR(&DAT8 ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&JUL7 ) TYPE(*CHAR) LEN(7)
             DCL        VAR(&FMT  ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DAT10) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TRUE ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN  ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&DAT10) VALUE(&DAT8 )

             CALL       PGM(UTLR01) PARM(&DAT10 &TRUE &RTN)

             CHGVAR     VAR(&DAT8 ) VALUE(&TRUE )
             CHGVAR     VAR(&FMT  ) VALUE('*LONGJUL')

             CVTDAT     DATE(&DAT8) TOVAR(&JUL7) FROMFMT(*YYMD) +
                          TOFMT(&FMT) TOSEP(*NONE)

             ENDPGM
