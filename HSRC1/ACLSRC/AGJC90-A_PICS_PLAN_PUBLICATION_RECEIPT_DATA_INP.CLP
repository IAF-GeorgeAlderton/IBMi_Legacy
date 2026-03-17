             PGM
             /*** AGJC90 ***********************************/
             /* A-PICS SORT M/F                            */
             /*  ITS.              2013.11.25              */
             /**********************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGJR91)
             CALL       PGM(AGJR94)
       /*ENGIN BOLT  */
             CALL       PGM(AGJR9B)
       /*RINNJI*/
             CALL       PGM(AGJR9A)

 END:
             ENDPGM
