             /** UTLC03 ******************************************/
             /*  UTILITY - GET UNIT PRICE BY DATE                */
             /*--------------------------------------------------*/
             /*  CALLING SEQ.                                    */
             /*                    CALL 'UTLC03'                 */
             /*                    PARM           $DATE   6      */
             /*                    PARM           $TOKU   4      */
             /*                    PARM           $NONY   4      */
             /*                    PARM           $CPART 20      */
             /*                    PARM           $UP     9      */
             /*                    PARM           $RTN    1      */
             /*   IN  $DATE  :  6A DATE (YYYYMM)                 */
             /*       $TOKU  :  4A CUST#                         */
             /*       $NONY  :  4A DELIVERY#                     */
             /*       $CPART : 20A CUSTMER PART                  */
             /*   OUT $UP    :  9A PRICE 9(5)                    */
             /*       $RTN   :  1A RETURN CODE (BLANK/*)         */
             /****************************************************/
             PGM        PARM(&DATE &TOKU &NONY &CPART &UP &RTN)

             DCL        VAR(&DATE ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&TOKU ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NONY ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&CPART) TYPE(*CHAR) LEN(20)
             DCL        VAR(&UP   ) TYPE(*CHAR) LEN(9)
             DCL        VAR(&RTN  ) TYPE(*CHAR) LEN(1)

             CALL       PGM(UTLR03) PARM(&DATE &TOKU &NONY &CPART &UP &RTN)

 END:        ENDPGM
