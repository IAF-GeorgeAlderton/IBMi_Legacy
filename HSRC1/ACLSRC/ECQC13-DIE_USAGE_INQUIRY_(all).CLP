             PGM
             /** ECQC15 **********************************/
             /* DIE USAGE INQUIRY                  */
             /* PROGRAM ID. : ECQC15. <CLP> */
             /* CREATE DATE.  04/01/05                   */
             /* AUTHOR.    TCH  REGRIND   TCH56          */
             /********************************** ECQC15 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

      /*     OVRPRTF    FILE(QPRINT) HOLD(*YES)   */
             CALL       PGM(ECQR14)

             ENDPGM
