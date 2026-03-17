             PGM
             /** FCQC51 ****************************************/
             /*          工程・型引当マスター　照会          */
             /*         E.KAWASHIMA       90.03.20             */
             /**************************************** FCQC51 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)
             OVRDBF     FILE(HAAPL02) TOFILE(HFILE/HAAPL02)
             CALL       PGM(FCQR51)
             DLTOVR     FILE(HAAPL02)

             ENDPGM
