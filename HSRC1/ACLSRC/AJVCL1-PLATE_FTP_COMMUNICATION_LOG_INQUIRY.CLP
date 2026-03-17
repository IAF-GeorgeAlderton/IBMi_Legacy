             PGM
             /*** AJVCL1 ********************************************/
             /*  PROGRAM NAME.  : MEKI FTP LOG INQURY           */
             /*  PROGRAM ID.    : AJVCL1       <CLP>                */
             /*  CREATE DATE.   : 2005/03/24                        */
             /*  AUTHOR.        : A.MAMIYA                          */
             /********************************************* AJVCL1 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(9)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CALL       PGM(AJVRL1)

             ENDPGM
