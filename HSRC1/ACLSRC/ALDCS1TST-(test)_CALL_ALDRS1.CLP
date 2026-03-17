             PGM
             /** ALDCS1TST ***********************************/
             /*  TSET ALDRS1                                 */
             /*  JW   2023.01.04                             */
             /************************************************/
             DCL        VAR(&CHYU) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ZENO) TYPE(*CHAR) LEN(4)
             DCL        VAR(&THNO) TYPE(*CHAR) LEN(3)
             DCL        VAR(&THHZ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MAIS) TYPE(*CHAR) LEN(4)

             CHGVAR     VAR(&CHYU) VALUE('A')
             CHGVAR     VAR(&ZENO) VALUE('2846')
             CHGVAR     VAR(&THNO) VALUE('574')
             CHGVAR     VAR(&THHZ) VALUE('20230104')
             CHGVAR     VAR(&MAIS) VALUE(' ')

             CALL       PGM(ALDRS1) PARM(&CHYU &ZENO &THNO &THHZ &MAIS)

             ENDPGM
