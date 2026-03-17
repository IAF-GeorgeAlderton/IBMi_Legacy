             PGM
/** AH#C741 ************************************************/
/* PRIORITY LIST                                           */
/*       COPY FROM AH#C74                                  */
/*                                                         */
/*                                                         */
/* TCH 03/14/05   TCH51                                    */
/* TCHK1 09/11/07 CHG AH#WP70 TO AH#WP74                   */
/* TCHK2 11/12/08 RMV AH#PP70X                             */
/* TCHK3 07/15/10 CHG TEMPORARY CHANGE CALENDAR M/F        */
/* TCHK4 08/03/12 CREATE                                   */
/************************************* BASE OF   AH#C72 ****/
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)

/* TCHK3 */  OVRDBF     FILE(AGDPP11) TOFILE(HFILE1/A@DPP11)
/* TCHK3 */  OVRDBF     FILE(AGDPL11) TOFILE(HFILE1/A@DPL11)
/* TCHK3 */  OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/A@DPL12)

             RTVJOBA    JOB(&WS) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

 STP1:       CHGJOB     OUTQ(&PRTG)
        /*               */
             DLTF       FILE(AH#WP30A)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AH#WP30A) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AH#WP30) OPTION(*NOLIST *NOSRC) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(AH#WP30B)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AH#WP30B) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AH#WP30) OPTION(*NOLIST *NOSOURCE) +
                          LVLCHK(*NO) AUT(*ALL)

/* TCHK1     CRTDUPOBJ  OBJ(AH#WP70) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)                       */
/* TCHK1     MONMSG     MSGID(CPF0000)                       */
/* TCHK1     CLRPFM QTEMP/AH#WP70                            */
/* TCHK1     OVRDBF     FILE(AH#WP70) TOFILE(QTEMP/AH#WP70)  */

/* TCHK1 */  CRTDUPOBJ  OBJ(AH#WP74) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
/* TCHK1 */  MONMSG     MSGID(CPF0000)
/* TCHK1 */  CLRPFM QTEMP/AH#WP74
/* TCHK1 */  OVRDBF     FILE(AH#WP74) TOFILE(QTEMP/AH#WP74)

/* TCHK4 */  CRTDUPOBJ  OBJ(AH#WP74A) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
/* TCHK4 */  MONMSG     MSGID(CPF0000)
/* TCHK4 */  CLRPFM QTEMP/AH#WP74A
/* TCHK4 */  OVRDBF     FILE(AH#WP74A) TOFILE(QTEMP/AH#WP74A)

/* TCHK4 */  CRTDUPOBJ  OBJ(AH#PP70A) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
/* TCHK4 */  MONMSG     MSGID(CPF0000)
/* TCHK4 */  CLRPFM QTEMP/AH#PP70A
/* TCHK4 */  OVRDBF     FILE(AH#PP70A) TOFILE(QTEMP/AH#PP70A)

       /*    CLRPFM     FILE(HWFILE1/AH#PP70X)    */
/* TCHK2     CRTDUPOBJ  OBJ(AH#PP70X) FROMLIB(&WLIB) OBJTYPE(*FILE) + */
/* TCHK2                  TOLIB(QTEMP)                                */
/* TCHK2     MONMSG     MSGID(CPF0000)                                */
/* TCHK2     CLRPFM QTEMP/AH#PP70X                                    */
/* TCHK2     OVRDBF     FILE(AH#PP70X) TOFILE(QTEMP/AH#PP70X)         */


             CALL       PGM(TOBJ1/AH#R741)


             DLTOVR     FILE(*ALL)

 END:        CHGJOB     RUNPTY(20)

             ENDPGM
