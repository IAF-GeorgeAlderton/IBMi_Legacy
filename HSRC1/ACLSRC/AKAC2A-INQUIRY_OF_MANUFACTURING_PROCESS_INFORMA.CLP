             PGM
             /** AKAC2A ******************************************/
             /* INQUIRY OF MANUFACTURING PROCESS INFORMATION     */
             /* I-HASADA                  87.01.16               */
             /* JW1     2022.09.30 CHG AKAR2A TO AKAC2A1         */
             /****************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSID)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)

  /**JW1     CALL       PGM(AKAR2A)   **/
             CALL       PGM(AKAR2A1)

             ENDPGM
