             PGM
             /*** BTAC05 ********************************************/
             /* PT PLAN PUBLICATION MANAGEMENT SYSTEM               */
             /*                INPUT FOR MINUS                      */
             /*          I-HASADA   2000.07.24                      */
             /*******************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             OVRDBF     FILE(FCEPL01) TOFILE(HFILE1/FCEPL01)
             OVRDBF     FILE(AKCPL01) TOFILE(HFILE1/AKCPL01)
             OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/AGDPL12)
             OVRDBF     FILE(AGAPL31) TOFILE(HFILE1/AGAPL31)
             OVRDBF     FILE(AAPTL01) TOFILE(HFILE1/AAPTL01)
             OVRDBF     FILE(BTAPP41) TOFILE(HFILE1/BTAPP41)

             OVRDBF     FILE(BTAPL05) TOFILE(TFILE1/BTAPL05)

             CALL       PGM(HOBJ1/BTAR05) PARM(&USER)

             ENDPGM
