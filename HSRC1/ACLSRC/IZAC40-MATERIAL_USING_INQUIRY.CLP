             PGM
             /** IZAC40 **********************************/
             /* MATERIAL USING INQUIRY                   */
             /*   TCH                      2003.07.01    */
             /********************************** IZAC40 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CALL       PGM(IZAR40)

             ENDPGM
