             PGM
/** ALCC9VT  **********************************************/
/*  TEST CONVEYANCE                                       */
/*  LEC          2023.08.02                               */
/**********************************************************/

             DCL        VAR(&OPER) TYPE(*CHAR) LEN(6) VALUE('999999')
             DCL        VAR(&USER) TYPE(*CHAR) LEN(20) VALUE('QPGMR')
             DCL        VAR(&SECT) TYPE(*CHAR) LEN(1) VALUE('2')
             DCL        VAR(&FLAG) TYPE(*CHAR) LEN(1)

             CALL       PGM(TOBJ1/ALDR9X) PARM(&OPER &USER &SECT &FLAG)
             SIGNOFF

             ENDPGM
