             /****************************************************/
             /*  CONCATENATE STRING1 *BCAT  STRING2 --> STRING3  */
             /*--------------------------------------------------*/
             /*  CALLING SEQ.                                    */
             /*                    CALL 'APLC11'                 */
             /*                    PARM           $STR1 128      */
             /*                    PARM           $STR2 128      */
             /*                    PARM           $STR3 128      */
             /*   IN  $STR1: 120A STRING 1                       */
             /*   "   $STR2: 128A STRING 2                       */
             /*   OUT $STR3: 128A STR1 *BCAT STR2 --> STRING 3   */
             /****************************************************/
             PGM        PARM(&STR1 &STR2 &STR3)

             DCL        VAR(&STR1) TYPE(*CHAR) LEN(128)
             DCL        VAR(&STR2) TYPE(*CHAR) LEN(128)
             DCL        VAR(&STR3) TYPE(*CHAR) LEN(128)

             CHGVAR     VAR(&STR3) VALUE(&STR1 *BCAT &STR2)

             ENDPGM
