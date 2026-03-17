             PGM
             /** AH#C7B **********************************/
             /* PRIORITY LIST                            */
             /*       JAN/10/02  TCH                     */
             /*                                          */
             /*                                          */
             /* TCH 03/14/05   TCH51                     */
             /* TCHK1 09/11/07 CHG AH#WP70 TO AH#WP74    */
             /* TCHK2 11/12/08 RMV AH#PP70X              */
             /* TCHK3 07/15/10 CHG TEMPORARY CHANGE CALENDAR M/F */
             /* TCHK4 05/16/13 CREATE COPY FROM AH#C74   */
             /********************** BASE OF   AH#C72 ****/
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

/* TCHK1 */  CRTDUPOBJ  OBJ(AH#WP74) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
/* TCHK1 */  MONMSG     MSGID(CPF0000)
/* TCHK1 */  CLRPFM QTEMP/AH#WP74
/* TCHK1 */  OVRDBF     FILE(AH#WP74) TOFILE(QTEMP/AH#WP74)


             CALL       PGM(AH#R7B)


             DLTOVR     FILE(*ALL)

 END:        CHGJOB     RUNPTY(20)

             ENDPGM
