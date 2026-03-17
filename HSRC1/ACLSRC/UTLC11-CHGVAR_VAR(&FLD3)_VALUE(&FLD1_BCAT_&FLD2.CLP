/** UTLC11 ******************************************/
/*  UTILITY - MERGE FLD1 AND FLD2 TO FLD3           */
/*  (SORT SPECIAL)                                  */
/*  JW   2020.04.17                                 */
/*--------------------------------------------------*/
/*  CALLING SEQ.                                    */
/*                    CALL 'UTLC11'                 */
/*                    PARM           $FLD1 128      */
/*                    PARM           $FLD2 128      */
/*                    PARM           $FLD3 128      */
/*   IN  $FLD1: 128A FIELD1                         */
/*       $FLD2: 128A FIELD3                         */
/*   OUT $FLD3: 128A FIELD1 + FIELD2                */
/****************************************************/
PGM          PARM(&FLD1 &FLD2 &FLD3)

             DCL        VAR(&FLD1)  TYPE(*CHAR) LEN(128)
             DCL        VAR(&FLD1A) TYPE(*CHAR) LEN(128)
             DCL        VAR(&FLD2)  TYPE(*CHAR) LEN(128)
             DCL        VAR(&FLD3)  TYPE(*CHAR) LEN(128)

             DCL        VAR(&LTR1) TYPE(*CHAR) LEN(3)
             DCL        VAR(&LTR2) TYPE(*CHAR) LEN(3)
             DCL        VAR(&LTR3) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LTR4) TYPE(*CHAR) LEN(128) VALUE(' ')
             CHGVAR     VAR(&FLD1A) VALUE(&FLD1)
/* SRT ADJ 1 */
             CHGVAR     VAR(&LTR1) VALUE(%SST(&FLD1 1 3))
             CHGVAR     VAR(&LTR2) VALUE(%SST(&FLD2 1 3))
             IF         COND((&LTR1 = 'SRT') *AND (&LTR2 = 'SRT')) THEN(DO)
             CHGVAR     VAR(&FLD1A) VALUE(' ')
             ENDDO

             CHGVAR     VAR(&FLD3) VALUE(&FLD1A *BCAT &FLD2)
/* SRT ADJ 2 */
             CHGVAR     VAR(&LTR3) VALUE(%SST(&FLD3 1 1))
             IF         COND(&LTR3 = ' ') THEN(DO)
             CHGVAR     VAR(&LTR4) VALUE(%SST(&FLD3 2 127))
             CHGVAR     VAR(&FLD3) VALUE(&LTR4)
             ENDDO
ENDPGM
