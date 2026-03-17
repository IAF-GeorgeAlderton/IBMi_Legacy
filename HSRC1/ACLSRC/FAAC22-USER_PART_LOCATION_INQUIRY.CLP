             PGM
             /** FAAC22 **********************************************/
             /* USER PART NUMBER LOCATION CODE INQUIRY SCREEN        */
             /* C:Y.AOYAMA           1992.08.06                      */
             /* JW1        2021.05.07 CHG FAAR22                     */
             /********************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)

      /**JW1 CALL       PGM(FAAR22)  **/
             CALL       PGM(FAAR22N)

             ENDPGM
