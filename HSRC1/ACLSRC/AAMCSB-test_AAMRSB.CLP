PGM
/** TEST CLP **/

             DCL        VAR(&INHIN1 ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&INHIN2 ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&INHIN3 ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&OPNCLS ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OUTBMN ) TYPE(*CHAR) LEN(60)
             DCL        VAR(&OUTKBN ) TYPE(*CHAR) LEN(45)
             DCL        VAR(&OUTTKR ) TYPE(*CHAR) LEN(90)
             DCL        VAR(&OUTSHR ) TYPE(*CHAR) LEN(15)
             DCL        VAR(&OUTKOT ) TYPE(*CHAR) LEN(45)
             DCL        VAR(&OUTHBN ) TYPE(*CHAR) LEN(80)
             DCL        VAR(&STATUS ) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&INHIN1 ) VALUE('A0619')
             CHGVAR     VAR(&INHIN2 ) VALUE('A5103')
             CHGVAR     VAR(&INHIN3 ) VALUE('  ')
             CHGVAR     VAR(&OPNCLS ) VALUE('1')
             CHGVAR     VAR(&OUTBMN ) VALUE(' ')
             CHGVAR     VAR(&OUTKBN ) VALUE(' ')
             CHGVAR     VAR(&OUTTKR ) VALUE(' ')
             CHGVAR     VAR(&OUTSHR ) VALUE(' ')
             CHGVAR     VAR(&OUTKOT ) VALUE(' ')
             CHGVAR     VAR(&OUTHBN ) VALUE(' ')
             CHGVAR     VAR(&STATUS ) VALUE(' ')

             CALL       PGM(AAMRSB) PARM(&INHIN1 &INHIN2 &INHIN3 +
                          &OPNCLS &OUTBMN &OUTKBN &OUTSHR &OUTKOT +
                          &OUTHBN &STATUS)

             ENDPGM
