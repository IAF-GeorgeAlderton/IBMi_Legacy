             PGM        PARM(&TAC5 &TANM &CMD &STS)
            /** ECSC80 **********************************************/
            /*  (HDT) STORE THE DIE IN                              */
            /*          2017.06.05  ITS.  T.MITSUI                  */
            /********************************************************/
             DCL        VAR(&WSID)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRNT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&DEVT)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&IGCD)     TYPE(*CHAR) LEN(4)

             DCL        VAR(&TAC5)     TYPE(*CHAR) LEN(5)
             DCL        VAR(&TANM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&CMD)      TYPE(*CHAR) LEN(2)
             DCL        VAR(&STS)      TYPE(*CHAR) LEN(1)

 #STEP01:   /*======================================================*/
            /*    PROCESS PREPARATION                               */
            /*======================================================*/
             RTVJOBA    JOB(&WSID)     USER(&USER)
             CALL       PGM(AGAR01)    PARM(&WSID &DEVT &IGCD)
             CALL       PGM(AGAR00)    PARM(&WSID &PRNT &TYPE &PRTG)


 #STEP02:   /*======================================================*/
            /*    STORE THE DIE IN                                  */
            /*======================================================*/
             CALL       PGM(ECSR80)    +
                        PARM(&TAC5 &TANM &CMD &STS)


 #STEP99:   /*======================================================*/
            /*    FINAL PROCESSING                                  */
            /*======================================================*/
             ENDPGM

