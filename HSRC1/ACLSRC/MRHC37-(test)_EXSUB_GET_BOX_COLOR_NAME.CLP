             PGM
             /*** MRHC37 ***********************************/
             /*   TEST EXSUB: GET BOX COLOR/NAME           */
             /*   MRHR37                                   */
             /**********************************************/

             DCL        VAR(&SKBN )    TYPE(*CHAR) LEN(1)
             DCL        VAR(&BKNO )    TYPE(*DEC) LEN(2 0)
             DCL        VAR(&BKTI )    TYPE(*CHAR) LEN(3)
             DCL        VAR(&JKTI )    TYPE(*CHAR) LEN(3)
             DCL        VAR(&JBMN )    TYPE(*CHAR) LEN(4)
             DCL        VAR(&AKTI )    TYPE(*CHAR) LEN(3)
             DCL        VAR(&CKTI )    TYPE(*CHAR) LEN(3)
             DCL        VAR(&AKKB )    TYPE(*CHAR) LEN(3)
             DCL        VAR(&BCCD )    TYPE(*CHAR) LEN(1)
             DCL        VAR(&BCNM )    TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTCD )    TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&SKBN ) VALUE(' ')
             CHGVAR     VAR(&BKNO ) VALUE(4)
             CHGVAR     VAR(&BKTI ) VALUE('OQ')
             CHGVAR     VAR(&JKTI ) VALUE('BZ')
             CHGVAR     VAR(&JBMN ) VALUE('0111')
             CHGVAR     VAR(&AKTI ) VALUE('SL1')
             CHGVAR     VAR(&CKTI ) VALUE('SD')
             CHGVAR     VAR(&AKKB ) VALUE('S37')
             CHGVAR     VAR(&BCCD ) VALUE(' ')
             CHGVAR     VAR(&BCNM ) VALUE(' ')
             CHGVAR     VAR(&RTCD ) VALUE(' ')

             CALL       PGM(MRHR37) PARM(&SKBN &BKNO &BKTI &JKTI +
                          &JBMN &AKTI &CKTI &AKKB &BCCD &BCNM &RTCD)

             ENDPGM
