             PGM        PARM(&PCMD3 &PUS &PKHIN &PKOTI &PKBMN &PTKRO +
                          &PRECD &PSBMN &PKBMK &PKANB)
             /** AKHC02 ************************************/
             /*  .. COMPONENTS KANBAN M/F DATA MAKING ..   */
             /*  .. M/F KEY CHANGE                         */
             /* I-HASADA                    92.09.12       */
             /************************************ AKHC02 **/
             DCL        VAR(&ABBDS3)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&WSID)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)       TYPE(*CHAR) LEN(2)
             DCL        VAR(&PCMD3)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PUS)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&PKHIN)    TYPE(*CHAR) LEN(12)
             DCL        VAR(&PKOTI)    TYPE(*CHAR) LEN(3)
             DCL        VAR(&PKBMN)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&PTKRO)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&PRECD)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&PSBMN)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&PKBMK)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PKANB)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PKYM)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&FILE1)    TYPE(*CHAR) LEN(9)
             RTVJOBA    JOB(&WSID)
             RTVDTAARA  DTAARA(ABBDS3) RTNVAR(&ABBDS3)

             CHGVAR     VAR(&PKYM) VALUE(%SST(&ABBDS3 1 6))
             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&FILE1) VALUE(AKHWP02 *CAT &WS)

             CLRPFM     FILE(&FILE1)

             OVRDBF     FILE(AKHWP02) TOFILE(&FILE1)
             CALL       PGM(AKHR02) PARM(&PKHIN &PKOTI &PKBMN &PTKRO +
                          &PKBMK)

             CALL       PGM(AKHR03) PARM(&PCMD3 &PUS &PKHIN &PKOTI +
                          &PKBMN &PRECD &PSBMN &PKANB &PKYM)
             DLTOVR     FILE(*ALL)

             ENDPGM
