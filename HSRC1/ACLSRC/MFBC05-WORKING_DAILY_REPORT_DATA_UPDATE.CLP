             PGM
             /** MFBC05 ****************************************/
             /*     WORKING DAILY REPORT DATA UPDATE           */
             /*          A-MAMIYA         97.12.03             */
             /**************************************** MFBC02 **/
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&IN01) TYPE(*LGL) LEN(1)
             DCL        VAR(&IN99) TYPE(*LGL) LEN(1)
             DCL        VAR(&@NO) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG) TYPE(*CHAR)  LEN(60)
             RTVJOBA    JOB(&WSID) USER(&US)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

 STP2:       CHGJOB     OUTQ(&PRTG)
             CALL       PGM(MFBR02) PARM(&US)

 END:        ENDPGM
