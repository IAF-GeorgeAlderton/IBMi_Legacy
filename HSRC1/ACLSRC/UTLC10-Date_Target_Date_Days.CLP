             /** UTLC10 ***********************************************/
             /*  UTILITY - *DATE* TARGET = DATE + DAYS                */
             /*-------------------------------------------------------*/
             /*  CALLING SEQ.                                         */
             /*                    CALL 'UTLC10'                      */
             /*                    PARM           $DT8    8           */
             /*                    PARM           $SIGN   1           */
             /*                    PARM           $DAYS   4           */
             /*                    PARM           $IAF    1           */
             /*                    PARM           $TGT8   8           */
             /*                    PARM           $RTN    1           */
             /*   IN  $DT8  :  8A DATE (YYYYMMDD)                     */
             /*       $SIGN :  1A + OR -                              */
             /*       $DAYS :  4A DAYS                                */
             /*       $IAF  :  1A N:REGULAR CALENDAR, Y=IAF CALENADER */
             /*   OUT $TGT8 :  8A TARGET                              */
             /*       $RTN  :  1A RETURN FLAG (BLANK=OK, 1=ERROR)     */
             /*********************************************************/
             PGM        PARM(&DATE &SIGN &DAYS &IAF &TGT8 &RTN)

             DCL        VAR(&DATE ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SIGN ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DAYS ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&IAF  ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TGT8 ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN  ) TYPE(*CHAR) LEN(1)

             CALL       PGM(UTLR10) PARM(&DATE &SIGN &DAYS &IAF &TGT8 &RTN)

 END:        ENDPGM
