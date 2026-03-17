             PGM
/*= AB#C1B ===============================================*/
/*  PROGRAM    : REVISION/COUNTRY OF ORIGIN MAINTENANCE   */
/*  WRITTEN    : 2018/11/30                               */
/*  WRITTEN BY : J.WATANABE                               */
/*========================================================*/

             DCL        VAR(&MHN1) TYPE(*CHAR) LEN(5)
             DCL        VAR(&MHN2) TYPE(*CHAR) LEN(5)
             DCL        VAR(&MHN3) TYPE(*CHAR) LEN(5)
             DCL        VAR(&MHN4) TYPE(*CHAR) LEN(5)
             DCL        VAR(&NONY) TYPE(*DEC)  LEN(4 0) VALUE(0)

             CALL       PGM(AB#R1B) PARM(&MHN1 &MHN2 &MHN3 &MHN4 &NONY)

             ENDPGM
