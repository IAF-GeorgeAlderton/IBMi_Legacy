             PGM
             /** MFAC03 ****************************************/
             /*            FACILITY MANAGEMENT M/F UPDATE  */
             /*         G.B.C.            89.10.23             */
             /**************************************** MFAC03 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

 STP1:       CHGJOB     OUTQ(&PRTG)
             CALL       PGM(MFAR03) PARM(&USER)

 END:        ENDPGM
