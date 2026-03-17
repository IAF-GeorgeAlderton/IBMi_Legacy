             PGM
             /** AB#CAH **********************************************/
             /*  ASJ KANBAN DUPLICATE SCAN                           */
             /*    H.AMANO       APR/26/04                           */
             /*                                                      */
             /*                                                      */
             /********************************************** AB#CAH **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CALL       PGM(AB#RAH)

             ENDPGM
