             PGM        PARM(&IAF#)
             /** UTLC56C ***************************************/
             /*  GET IAF-PO# FROM AB#PPCT2                     */
             /*  J.WATANABE 2022.11.28                         */
             /**************************************************/

             DCL        VAR(&DATE ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&UPD  ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&IAF# ) TYPE(*CHAR) LEN(10)

             CHGVAR     VAR(&DATE) VALUE(' ')
             CHGVAR     VAR(&UPD ) VALUE('Y')

             CALL       PGM(UTLR56C) PARM(&DATE &UPD &IAF#)

             ENDPGM
