             PGM
/** ABBC25 *************************************************/
/* FORECAST DATA INQUIRY                                   */
/*      TCH  APR/03/02                                     */
/* TCHK1 05/13/09 ADD PARM                                 */
/* TCHK2 04/15/11 ADD AGDPL12 OVRDBF                       */
/* JW    2024.12.09 CHG ABBR25                             */
/************************************************* ABBC25 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

/* TCHK2 */  OVRDBF     FILE(AGDPP11) TOFILE(HFILE1/A@DPP11)
/* TCHK2 */  OVRDBF     FILE(AGDPL11) TOFILE(HFILE1/A@DPL11)
/* TCHK2 */  OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/A@DPL12)

/* TCHK1     CALL       PGM(ABBR25) */
/* TCHK1 */  CALL       PGM(ABBR25A) PARM(' ' ' ' ' ' ' ' ' ' ' ' ' ')

             ENDPGM
