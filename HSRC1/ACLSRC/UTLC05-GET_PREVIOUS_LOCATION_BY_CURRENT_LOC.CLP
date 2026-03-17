             /** UTLC05 ******************************************/
             /*  UTILITY - GET PREVIOUS LOCATION BY CURRENT LOC  */
             /*--------------------------------------------------*/
             /*  CALLING SEQ.                                    */
             /*                    CALL 'UTLC05'                 */
             /*                    PARM           $LOC    4      */
             /*                    PARM           $SHN1   5      */
             /*                    PARM           $SHN2   5      */
             /*                    PARM           $SHN3   2      */
             /*                    PARM           $PLOC   4      */
             /*                    PARM           $RTN    1      */
             /*   IN  $LOC  :  4A LOCATION2-3                    */
             /*       $SHN1 :  5A IAF PART1                      */
             /*       $SHN2 :  5A IAF PART2                      */
             /*       $SHN3 :  2A IAF PART3                      */
             /*   OUT $PLOC :  4A PREVIOUS2-3                    */
             /*       $RTN  :  1A RETURN CODE (BLANK/*)          */
             /****************************************************/
             PGM        PARM(&LOC &SHN1 &SHN2 &SHN3 &PLOC &RTN)

             DCL        VAR(&LOC  ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&SHN1 ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&SHN2 ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&SHN3 ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PLOC ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&RTN  ) TYPE(*CHAR) LEN(1)

             CALL       PGM(UTLR05) PARM(&LOC &SHN1 &SHN2 &SHN3 &PLOC &RTN)

 END:        ENDPGM
