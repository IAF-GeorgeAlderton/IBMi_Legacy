             PGM
             /** BAMC11 ************************************/
             /* INQUIRY  OF INTRAL COMPANY KANBAN CHANGE M/F CL */
             /*          E.KAWASHIMA 1990.04.06            */
             /* * * * * * * * * * * * */
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSNO) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)
 STEP02:     CHGJOB     OUTQ(&PRTG)
             CALL       PGM(BAMR11) PARM(&USER)
             CHGJOB     OUTQ(&PRT)
 END:        ENDPGM
