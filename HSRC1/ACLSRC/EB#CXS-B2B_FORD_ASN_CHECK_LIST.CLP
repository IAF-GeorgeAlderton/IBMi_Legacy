             PGM        PARM(&SFIL &SLIB)
             /** EB#C0S ******************************************/
             /*  B2B FORD ASN CHECK LIST                         */
             /*    T.SAKAKI      06/07/2017                      */
             /*                                                  */
             /*  JW1   2018.08.03 CHG EB#R0S TO EB#R0T           */
             /****************************************** AB#C0S **/
             DCL        VAR(&SFIL)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&SLIB)  TYPE(*CHAR) LEN(8)
             DLYJOB     DLY(5)
             DLTOVR (*ALL)

             ENDPGM
