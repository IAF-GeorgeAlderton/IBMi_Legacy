             /** AB#C1H ****************************************/
             /*  SPLIT HONDA ORDER BY PALETTE (OVER 60 BOXES)  */
             /*  (USE THIS CL TO RUN SPLIT AGAIN)              */
             /*  J.WATANABE  2016.09.12                        */
             /**************************************************/
             PGM

             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTN1)  TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             OVRPRTF    FILE(QPRINT) USRDTA('SPLIT60')

             CALL       PGM(AB#R1H) PARM(&RTN1)

             ENDPGM
