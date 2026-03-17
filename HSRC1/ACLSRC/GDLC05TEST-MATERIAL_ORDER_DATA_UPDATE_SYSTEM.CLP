             PGM
             /** GDLC05 ***********************************/
             /*  MATERIAL ORDER DATA UPDATE SYSTEM        */
             /*               K.YASUDA  2000.08.08        */
             /*                                           */
             /*  TCHK1 03/18/08 ADD USER EXISTING CHECK   */
             /*********************************** GDLC05 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
/* TCHK1 */  DCL        VAR(&MSG)  TYPE(*CHAR) LEN(46)
/* TCHK1 */  DCL        VAR(&MSGX)  TYPE(*CHAR) LEN(35)
/* TCHK1 */  DCL        VAR(&SMB)  TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)


             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             OVRDBF     FILE(GDLPL01) TOFILE(TFILE1/GDLPL01)
             OVRDBF     FILE(FGBPL01) TOFILE(HFILE1/FGBPL01)
             OVRDBF     FILE(IZAPL01) TOFILE(HFILE1/IZAPL01)
             OVRDBF     FILE(IZBPL01) TOFILE(HFILE1/IZBPL01)
             OVRDBF     FILE(GDLWP03) TOFILE(TFILE1/GDLWP03)

             CALL       PGM(TOBJ1/GDLR05) PARM(&USER)

             DLTOVR     FILE(*ALL)

             ENDPGM
