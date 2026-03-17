             PGM        PARM(&SUPP)
             /** AFDC41 ***********************************/
             /*  SUPPLIER UNIT PRICE MASTER INQ           */
             /*  J.WATANABE  2018.06.01                   */
             /*********************************************/
             DCL        VAR(&SUPP) TYPE(*CHAR) LEN(4)
             DCL        VAR(&SHN1) TYPE(*CHAR) LEN(5)
             DCL        VAR(&SHN2) TYPE(*CHAR) LEN(5)
             DCL        VAR(&SHN3) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TKHZ) TYPE(*DEC)  LEN(8 0)
             DCL        VAR(&RTN ) TYPE(*CHAR) LEN(1)

             CALL       PGM(AFDR41) PARM(&SUPP &SHN1 &SHN2 &SHN3 &TKHZ &RTN)

             ENDPGM
