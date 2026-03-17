             PGM        PARM(&LIBL &FILE &MOJI)
             /** FINC02 ****************************************/
             /*  ..CHARACTER STRING RETRIEVAL PROGRAM          */
             /*       A.MAMIYA                2001.01.29       */
             /**************************************** FINC02 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MOJI) TYPE(*CHAR) LEN(50)
             DCL        VAR(&WT) TYPE(*CHAR) LEN(5)
             DCL        VAR(&FILE02) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE03) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)    TYPE(*CHAR) LEN(8)
             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WT) VALUE(%SST(&WSID 1 5))

             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGVAR     VAR(&FILE02) VALUE('FWP02' *CAT &WT)
             DLTF       FILE(&FILE02)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE02) RCDLEN(256) IGCDTA(*YES)

             OVRPRTF    FILE(QPUOPRTF) HOLD(*YES)
             FNDSTRPDM  STRING(&MOJI) FILE(&LIBL/&FILE) MBR(*ALL) +
                          OPTION(*NONE) PRTMBRLIST(*YES)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(QPUOPRTF)

             CPYSPLF    FILE(QPUOPRTF) TOFILE(&WLIB/&FILE02) +
                          SPLNBR(*LAST) MBROPT(*REPLACE)
             DLTSPLF    FILE(QPUOPRTF) SPLNBR(*LAST)

             CHGVAR     VAR(&FILE03) VALUE('FWP03' *CAT &WT)
             OVRDBF     FILE(FINWP02) TOFILE(&WLIB/&FILE02)
             OVRDBF     FILE(FINWP03) TOFILE(&WLIB/&FILE03)
             CALL       PGM(FINR03)
             DLTOVR     FILE(FINWP02)
             DLTOVR     FILE(FINWP03)

             DLTF       FILE(&FILE02)
             MONMSG     MSGID(CPF3261 CPF2105)

             ENDPGM
