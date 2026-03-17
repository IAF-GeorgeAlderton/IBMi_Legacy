             PGM        PARM(&PRT)
             /** UTLC21 ****************************************/
             /*  CALL REFORMATION PROGRAM                      */
             /*  JW1: J-WATANABE             2017.04.06        */
             /**************************************************/

             DCL        VAR(&PRT ) TYPE(*CHAR) LEN(12)
             DCL        VAR(&LOC ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&QC  ) TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&PRC ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&DPT ) TYPE(*DEC)  LEN(4 0)
             DCL        VAR(&ZETI) TYPE(*CHAR) LEN(4)
             DCL        VAR(&RTN ) TYPE(*CHAR) LEN(1)

        /*   CHGVAR     VAR(&PRT) VALUE('U0805B0038  ') */
             CHGVAR     VAR(&QC ) VALUE(0)
             CHGVAR     VAR(&DPT) VALUE(0)

             CALL       PGM(UTLR21) PARM(&PRT &LOC &QC &PRC &DPT &ZETI &RTN)

             ENDPGM
