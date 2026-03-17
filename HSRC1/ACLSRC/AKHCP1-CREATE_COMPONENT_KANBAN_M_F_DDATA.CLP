             PGM
             /** AKHCP1 ************************************/
             /*  .. COMPONENTS KANBAN M/F DDATA MAKING ..  */
             /* I-HASADA                    92.09.12       */
             /************************************ AKHCP1 **/
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)     TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE1)  TYPE(*CHAR) LEN(9)
             RTVJOBA    JOB(&WSID)   USER(&USER)

             CALL       PGM(AGAR00)  PARM(&WSID &PRT &TYPE &PRTG)

             CHGVAR     VAR(&WS)     VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&FILE1)  VALUE(AKHWP02 *CAT &WS)

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) SRCFILE(ADDSSRC) +
                          SRCMBR(AKHWP02) OPTION(*NOLIST *NOSRC) +
                          SIZE(3000 1000 3) LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(AKHR01) PARM(&USER)

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)

             ENDPGM
