             PGM
             /** AB#C06 ***************************/
             /*   INQUALY OF EDI FIXED ORDER DATA */
             /*           K.YASUDA    1999.07.30  */
             /*************************** AB#C06 **/
             DCL        VAR(&US)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)

             RTVJOBA    JOB(&WSID)   USER(&US)
             CALL       PGM(AGAR00)  PARM(&WSID &PRT &TYPE &PRTG)

             CALL       PGM(AB#R06)

             ENDPGM
