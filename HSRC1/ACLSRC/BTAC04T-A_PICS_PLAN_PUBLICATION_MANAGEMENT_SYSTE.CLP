             PGM
             /*** BTAC04 ******************************/
             /* A-PICS PLAN PUBLICATION MANAGEMENT SYSTEM */
             /*                INPUT FOR MINUS  */
             /*          S.YAMAGAMI 1994.10.04 */
             /*****************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             OVRDBF     FILE(AGAPL31) TOFILE(HFILE1/AGAPL31)
             OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/AGDPL12)
             OVRDBF     FILE(FGBPL01) TOFILE(HFILE1/FGBPL01)

             OVRDBF     FILE(BTAPL04) TOFILE(TFILE1/BTAPL04)

             CALL       PGM(BTAR04) PARM(&USER)

             ENDPGM
