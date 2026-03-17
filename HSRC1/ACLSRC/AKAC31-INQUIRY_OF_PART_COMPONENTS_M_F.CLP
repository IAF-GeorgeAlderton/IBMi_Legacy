             PGM        PARM(&MODE &HIN1 &HIN2 &HIN3)
             /** AKAC30 ********************************/
             /*   INQUIRY OF PART / COMPONENTS M/F     */
             /* I-HASADA                87.01.07       */
             /*----------------------------------------*/
             /* JW1   2024.05.01 CHG AKAR30            */
             /******************************************/
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&HIN1) TYPE(*CHAR) LEN(5)
             DCL        VAR(&HIN2) TYPE(*CHAR) LEN(5)
             DCL        VAR(&HIN3) TYPE(*CHAR) LEN(2)

             DCL        VAR(&ABBDS3) TYPE(*CHAR) LEN(7)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PKYM)   TYPE(*CHAR) LEN(6)
             RTVJOBA    JOB(&WSID)
             RTVDTAARA  DTAARA(ABBDS3) RTNVAR(&ABBDS3)

             CHGVAR     VAR(&PKYM) VALUE(%SST(&ABBDS3 1 6))

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)
             CALL       PGM(AKAR30) PARM(&PKYM &MODE &HIN1 &HIN2 &HIN3)
    /**JW1   CALL       PGM(AKAR30A) PARM(&PKYM &MODE &HIN1 &HIN2 &HIN3) **/

             ENDPGM
