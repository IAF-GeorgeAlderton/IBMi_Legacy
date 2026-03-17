             PGM
             /** ABBC62 *****************************************/
             /*  CREATE FORECAST DATA FROM ABVP21 (VW DELFOR)   */
             /*   PGM CALL - ABBR62                             */
             /*   J.WATANABE 2017.05.25                         */
             /***************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CALL       PGM(ABBR62)

             ENDPGM
