             PGM        PARM(&PRT)
             /** UTLC21D ***************************************/
             /*  CALL REFORMATION PROGRAM                      */
             /*  JW1: J-WATANABE             2021.03.24        */
             /**************************************************/

             DCL        VAR(&PRT ) TYPE(*CHAR) LEN(12)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&LOC ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&QC  ) TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&PRC ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&DPT ) TYPE(*DEC)  LEN(4 0)
             DCL        VAR(&MCN ) TYPE(*CHAR) LEN(3)
             DCL        VAR(&ZETI) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MQTY) TYPE(*DEC ) LEN(9 0)
             DCL        VAR(&IAF ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SVC ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTN ) TYPE(*CHAR) LEN(1)

             CALL       PGM(UTLR21D) PARM(&PRT &DATE &LOC &QC &PRC +
                          &DPT &MCN &ZETI &MQTY &IAF &SVC &RTN)

             ENDPGM
