             PGM
             /** UTLC21B ***************************************/
             /*  CALL REFORMATION PROGRAM                      */
             /*  JW1: J-WATANABE             2017.04.06        */
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
             DCL        VAR(&RTN ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&PRT)  VALUE('90119A0372  ')
             CHGVAR     VAR(&DATE) VALUE('20191113')

             CALL       PGM(UTLR21B) PARM(&PRT &DATE &LOC &QC &PRC +
                          &DPT &MCN &ZETI &MQTY &RTN)

             ENDPGM
