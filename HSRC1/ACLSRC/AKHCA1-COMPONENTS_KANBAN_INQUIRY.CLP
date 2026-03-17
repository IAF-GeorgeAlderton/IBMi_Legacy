             PGM        PARM(&PCMD3)
             /** AKHCA1 **********************/
             /* INQUIRY OF COMPONENTS KANBAN  */
             /* I-HASADA 93.01.20 */
             /********************** AKHCA1 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&PCMD3) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGVAR     VAR(&WS)    VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&FILE1) VALUE(AKHWPA2 *CAT &WS)

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FILE1) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AKHWPA2) OPTION(*NOLIST *NOSRC) +
                          SIZE(3000 1000 3) LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(AKHRA1) PARM(&PCMD3)

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)

             ENDPGM
