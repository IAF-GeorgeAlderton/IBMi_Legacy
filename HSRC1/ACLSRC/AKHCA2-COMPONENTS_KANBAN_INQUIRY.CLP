             PGM        PARM(&PCMD3 &PKHIN &PKOTI &PKBMN &PTKRO +
                          &PRECD &PSBMN &PKBMK &PKANB)
             /** AKHCA2 ************************************/
             /* INQUIRY OF COMPONENTS KANBAN M/F DATA  */
             /*   LOCATION CODE M/F / KANBAN M/F */
             /* I-HASADA                    93.01.20       */
             /************************************ AKHCA2 **/
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)     TYPE(*CHAR) LEN(2)
             DCL        VAR(&PCMD3)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PKHIN)  TYPE(*CHAR) LEN(12)
             DCL        VAR(&PKOTI)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&PKBMN)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&PTKRO)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PRECD)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&PSBMN)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&PKBMK)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PKANB)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE1)  TYPE(*CHAR) LEN(9)
             RTVJOBA    JOB(&WSID)

             CHGVAR     VAR(&WS)     VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&FILE1)  VALUE(AKHWPA2 *CAT &WS)

             CLRPFM     FILE(&FILE1)

             OVRDBF     FILE(AKHWPA2) TOFILE(&FILE1)
             CALL       PGM(AKHRA2) PARM(&PKHIN &PKOTI &PKBMN &PTKRO +
                          &PKBMK)

             CALL       PGM(AKHRA3) PARM(&PCMD3 &PKHIN &PKOTI &PKBMN +
                          &PRECD &PSBMN &PKANB)
             DLTOVR     FILE(*ALL)

             ENDPGM
