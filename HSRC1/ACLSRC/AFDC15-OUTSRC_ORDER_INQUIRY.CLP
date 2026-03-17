             PGM        PARM(&SUPP &SUPX)
             /** AFDC15 ****************************/
             /* INQUIRY                            */
             /**************************** AFDC15 **/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&SUPP)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&SUPX)  TYPE(*CHAR) LEN(1)

             DCL        VAR(&HIN1)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&HIN2)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&HIN3)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&SDAT)  TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID)  USER(&USER)

      /*     CHGVAR     VAR(&SUPP) VALUE('2222')  */

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)

             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CALL       PGM(AFDR15) PARM(&SUPP &SUPX &HIN1 +
                                                     &HIN2 +
                                                     &HIN3 +
                                                     &SDAT )



             ENDPGM
