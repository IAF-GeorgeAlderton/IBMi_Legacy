             PGM        PARM(&JUL7 &DAT8)
             /** UTLC56B ***************************************/
             /*  GET YYYYMMDD FROM JULIAN DATE(YYYY+JJJ)       */
             /*  J.WATANABE 2022.11.16                         */
             /* ------------------------------------------     */
             /*  CALLING SEQ.                                  */
             /*                    CALL 'UTLC56B'              */
             /*                    PARM           $JUL7   7    */
             /*                    PARM           $DAT8   8    */
             /*   IN  $JUL7   7A JULIAN(YYYY+JJJ)              */
             /*   OUT $DAT8   8A DATE (YYYYMMDD)               */
             /**************************************************/

             DCL        VAR(&DAT8 ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&JUL7 ) TYPE(*CHAR) LEN(7)

             CVTDAT     DATE(&JUL7) TOVAR(&DAT8) FROMFMT(*LONGJUL) +
                          TOFMT(*YYMD) TOSEP(*NONE)

             ENDPGM
