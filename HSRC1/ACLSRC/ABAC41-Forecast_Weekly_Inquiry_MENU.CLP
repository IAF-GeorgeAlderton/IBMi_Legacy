             PGM
/** ABAC41 ************************************************/
/* FORECAST WEEKLY INQUIRY                                */
/*                                                        */
/* TCHK1 10/03/08 CREATE                                  */
/* TCHK2 06/12/09 CHG TEMPORARY CHANGE FOR CALENDAR M/F   */
/************************************************ ABAC41 **/

             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&CLBL)  TYPE(*CHAR) LEN(1) VALUE(' ')
             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

/* TCHK2 */  OVRDBF     FILE(AGDPP11) TOFILE(HFILE1/A@DPP11)
/* TCHK2 */  OVRDBF     FILE(AGDPL11) TOFILE(HFILE1/A@DPL11)
/* TCHK2 */  OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/A@DPL12)

             CALL       PGM(ABAR41) PARM(&CLBL)

             ENDPGM
