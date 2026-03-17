             /** UTLC01 ******************************************/
             /*  UTILITY - CHECK DATE WITH CALENDAR MASTER       */
             /*--------------------------------------------------*/
             /*  CALLING SEQ.                                    */
             /*                    CALL 'UTLC01'                 */
             /*                    PARM           $SRC   10      */
             /*                    PARM           $TRUE   8      */
             /*                    PARM           $RTN    1      */
             /*   IN  $SRC : 10A DATE (MM/DD/YYYY, YYYYMMDD)     */
             /*   OUT $TRUE:  8A FIXED DATE (YYMMDD)             */
             /*       $RTN :  1A RETURN FLAG (BLANK=OK, 1=ERROR) */
             /****************************************************/
             PGM        PARM(&SRC &TRUE &RTN)

             DCL        VAR(&SRC ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TRUE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN ) TYPE(*CHAR) LEN(1)

             CALL       PGM(UTLR01) PARM(&SRC &TRUE &RTN)

 END:        ENDPGM
