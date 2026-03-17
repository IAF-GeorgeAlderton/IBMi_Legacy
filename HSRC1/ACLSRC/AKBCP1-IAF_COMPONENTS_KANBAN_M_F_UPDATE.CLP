             PGM
             /** AKBCP1 ************************************/
             /*   IAF COMPONENTS KANBAN M/F                */
             /*                S.YAMAGAMI 92.09.01         */
             /*          CHAGE S.YAMAGAMI 96.09.25         */
             /**********************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             OVRDBF     FILE(AAJTL14) SHARE(*YES)
             OPNDBF     FILE(AAJTL14) OPTION(*ALL) OPNID(A01) +
                          TYPE(*PERM)
             MONMSG     MSGID(CPA0701 CPF4174)

             CHGJOB     OUTQ(&PRTG)
             CALL       PGM(AKBR02) PARM(&USER)
             CLOF       OPNID(A01)
             DLTOVR     FILE(*ALL)

             ENDPGM
