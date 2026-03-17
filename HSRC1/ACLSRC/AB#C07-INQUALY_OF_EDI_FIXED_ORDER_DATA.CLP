             PGM
             /** AB#C07 ***************************/
             /*   INQUALY OF EDI FIXED ORDER DATA */
             /*           K.OKACHI    2000.06.27  */
             /*************************** AB#C07 **/
             DCL        VAR(&US)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)

             RTVJOBA    JOB(&WSID)   USER(&US)
             CALL       PGM(AGAR00)  PARM(&WSID &PRT &TYPE &PRTG)

             CALL       PGM(AB#R07)

             ENDPGM
