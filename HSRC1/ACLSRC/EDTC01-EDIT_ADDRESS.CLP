             PGM        PARM(&NAM &AD1 &AD2 &CTY &STT &ZIP &ADDR)
             /** EDTC01 ************************************/
             /** EDIT ADDRESS                              */
             /** JW   2022.06.17                           */
             /**********************************************/
             DCL        VAR(&NAM )   TYPE(*CHAR) LEN(30)
             DCL        VAR(&AD1 )   TYPE(*CHAR) LEN(30)
             DCL        VAR(&AD2 )   TYPE(*CHAR) LEN(30)
             DCL        VAR(&CTY )   TYPE(*CHAR) LEN(30)
             DCL        VAR(&STT )   TYPE(*CHAR) LEN(2)
             DCL        VAR(&ZIP )   TYPE(*CHAR) LEN(10)
             DCL        VAR(&ADDR)   TYPE(*CHAR) LEN(120)

      /**    CHGVAR     VAR(&ADDR) VALUE(&AD1 *BCAT &AD2)   **/


             CHGVAR     VAR(&ADDR) VALUE(&NAM *TCAT ',' *BCAT &AD1 *BCAT &AD2 +
                          *TCAT ',' *BCAT &CTY *TCAT ',' *BCAT &STT +
                          *BCAT &ZIP)

 @EXIT:      ENDPGM
