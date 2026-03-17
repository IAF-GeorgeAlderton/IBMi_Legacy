             PGM
             /** ECQC09 **********************************/
             /* 6  MONTHS DIE USED RESULTS INQUIRY */
             /* PROGRAM ID. : ECQC09. <CLP> */
             /* CREATE DATE. : AUG.09,'88.               */
             /* AUTHOR.         : G.B.C.                 */
             /********************************** ECQC09 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ANS) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)
             CALL       PGM(ECQR09)

             ENDPGM
