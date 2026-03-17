             PGM
             /** IZAC40 **********************************/
             /* MATERIAL USING INQUIRY                   */
             /*   TCH                      2003.07.01    */
             /********************************** IZAC40 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SKUB) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PEND) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CLRPFM     FILE(HWFILE1/IZAPW41)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(IZAR41)

 END:

             ENDPGM
