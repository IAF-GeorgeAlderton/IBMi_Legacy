             PGM
             /** AKAC30 ********************************/
             /*   INQUIRY OF PART / COMPONENTS M/F   */
             /* I-HASADA                87.01.07       */
             /******************************** AKAC30 **/
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
             CALL       PGM(AKAR30) PARM(&PKYM ' ' '     ' '     ' '  ')
    /**JW    CALL       PGM(AKAR30A) PARM(&PKYM ' ' '     ' '     ' '  ') **/

             ENDPGM
