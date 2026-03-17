/** ALGC30 ************************************************/
/*  OQ - Print Nonconformance Sheet                       */
/*                                                        */
/* LEC  2022/09/14 - Create                               */
/**********************************************************/
             PGM        PARM(&WORKER &USER &AORB)

             DCL        VAR(&WORKER) TYPE(*CHAR) LEN(6)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(20)
             DCL        VAR(&AORB) TYPE(*CHAR) LEN(1)

             OVRPRTF    FILE(ALGPR30) OUTQ(SAVEOUTQ) +
                          USRDFNDTA('N/C Sheet')

             CALL       PGM(ALGR30) PARM(&WORKER &USER &AORB)

             ENDPGM
