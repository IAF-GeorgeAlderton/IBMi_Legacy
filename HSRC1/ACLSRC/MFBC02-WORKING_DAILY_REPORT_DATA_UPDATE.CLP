             PGM
             /** MFBC02 ****************************************/
             /*            WORKING DAILY REPORT DATA UPDATE */
             /*         G.B.C.            89.10.24             */
             /**************************************** MFBC02 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&IN01) TYPE(*LGL) LEN(1)
             DCL        VAR(&IN99) TYPE(*LGL) LEN(1)
             DCL        VAR(&@NO) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG) TYPE(*CHAR)  LEN(60)
             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

 STP2:       CHGJOB     OUTQ(&PRTG)
             CALL       PGM(MFBR41) PARM(&USER)

 END:        ENDPGM
