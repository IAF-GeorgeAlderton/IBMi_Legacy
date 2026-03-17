             PGM
             /* AH#C3I *************************************************/
             /* ASJ MATERIAL INVESTIGATION LIST                        */
             /*             07/20/01                                   */
             /* TCH62 05/12/05 ADDED PRINTER OPT.                      */
             /* TCHK1 07/15/10 CHG TEMPORARY CHANGE CALENDAR M/F       */
             /* JW1   04/14/20 CHG AH#R3Y TO AH#R3Y2                   */
             /**********************************************************/
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&WS)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&TIME)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&EID)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&OUTQ) TYPE(*CHAR) LEN(8)

/* TCHK1 */  OVRDBF     FILE(AGDPP11) TOFILE(HFILE1/A@DPP11)
/* TCHK1 */  OVRDBF     FILE(AGDPL11) TOFILE(HFILE1/A@DPL11)
/* TCHK1 */  OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/A@DPL12)

             RTVJOBA    JOB(&WS)  USER(&USER)
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&TIME)
             CHGJOB     RUNPTY(40) SWS(00000000)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

             /* TEST MODE CHECK */
             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&USER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO
             /* *************** */

             CHGJOB     OUTQ(&PRTG)


             CRTDUPOBJ  OBJ(AH#WP3Y) FROMLIB(&FLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/AH#WP3Y)

             OVRDBF     FILE(AH#WP3Y) TOFILE(QTEMP/AH#WP3Y)
  /*TCH62    CALL       PGM(AH#R3Y) PARM(&EID)             */
  /*JW1      CALL       PGM(AH#R3Y) PARM(&EID &OUTQ)       */

  /*JW1*/    CALL       PGM(AH#R3Y2) PARM(&EID &OUTQ)

             IF         COND(&EID *NE ' ') THEN(GOTO CMDLBL(END))


  /*TCH62    CALL       PGM(AH#R3Z) PARM(&TIME)     */
             CALL       PGM(AH#R3Z) PARM(&TIME &OUTQ)

 END:
             DLTOVR     FILE(*ALL)
             CHGJOB     RUNPTY(20)

             ENDPGM
