             PGM
  /** ALRC20 *************************************/
  /*  PASS THRU SORTING SCAN                     */
  /*  J.WATANABE  2020.09.23                     */
  /***********************************************/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR )  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)

             DCL        VAR(&OPR )  TYPE(*CHAR) LEN(6)  VALUE(' ')
             DCL        VAR(&TANT)  TYPE(*CHAR) LEN(20) VALUE(' ')
             DCL        VAR(&SECT)  TYPE(*CHAR) LEN(1)  VALUE(' ')
             DCL        VAR(&VALID) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&OPR ) VALUE(%SUBSTRING(&USER 1 6))

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

 /*******************************************************************/
 /*  TEAM MEMBER SIGN-ON                                            */
             CALL       PGM(ALCR0Y) PARM(&OPR &USER &VALID)

        /* &TANT ? */
        /* &SECT ? */
             IF         COND(&VALID = 'Y') THEN(DO)
             CALL       PGM(ALRR20) PARM(&OPR &TANT &SECT)
             ENDDO

   /**       SIGNOFF   **/

             ENDPGM
