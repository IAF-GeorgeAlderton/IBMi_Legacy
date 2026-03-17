             /** UTLC02 ******************************************/
             /*  UTILITY - GET WEEK# FROM DATE                   */
             /*--------------------------------------------------*/
             /*  CALLING SEQ.                                    */
             /*                    CALL 'UTLC02'                 */
             /*                    PARM           $DATE   8      */
             /*                    PARM           $DAY    1      */
             /*                    PARM           $WEEK#  1      */
             /*                    PARM           $RTN    1      */
             /*   IN  $DATE :  8A DATE (YYYYMMDD)                */
             /*   OUT $DAY  :  1A DAY OF THE WEEK (1=MONDAY)     */
             /*       $WEEK#:  1A WEEK#                          */
             /*       $RTN  :  1A RETURN FLAG (BLANK=OK, 1=ERROR)*/
             /****************************************************/
             PGM        PARM(&DATE &DAY &WEEK# &RTN)

             DCL        VAR(&DATE ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&DAY  ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WEEK#) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTN  ) TYPE(*CHAR) LEN(1)

             CALL       PGM(UTLR02) PARM(&DATE &DAY &WEEK# &RTN)

 END:        ENDPGM
