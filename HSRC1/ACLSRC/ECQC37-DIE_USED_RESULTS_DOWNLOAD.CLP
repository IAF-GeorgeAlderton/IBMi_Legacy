             PGM
             /** ECQC09 **********************************/
             /* 6  MONTHS DIE USED RESULTS INQUIRY */
             /* PROGRAM ID. : ECQC09. <CLP> */
             /* CREATE DATE. : COPIED FROM ECQC36        */
             /* AUTHOR.     TCH 06/15/05                 */
             /********************************** ECQC09 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ANS) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CLRPFM     FILE(*LIBL/ECSWP36)
             MONMSG     MSGID(CPF0000)

             CHGJOB     OUTQ(&PRTG)
             CALL       PGM(ECQR37)

             ENDPGM
