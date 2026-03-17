 PGM
/** AB#C0A ************************************************/
/*    EDI ORDER PROCESSING (GENTRAN)                      */
/*                                                        */
/**********************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PFLG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PSIRE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&KEN)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PSPO) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ID)   TYPE(*CHAR) LEN(1)
/* TCHK7 */  DCL        VAR(&PRUN) TYPE(*CHAR) LEN(1)
/* JE2   */  DCL        VAR(&REC)  TYPE(*DEC)  LEN(10 0)

/* TCHK6 */  OVRDBF     FILE(AGDPP11) TOFILE(TFILE1/A@DPP11)
/* TCHK6 */  OVRDBF     FILE(AGDPL11) TOFILE(TFILE1/A@DPL11)
/* TCHK6 */  OVRDBF     FILE(AGDPL12) TOFILE(TFILE1/A@DPL12)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGJOB     SWS(00000000)

             DLTF       FILE(QTEMP/AB#WP451)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP451) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(30000) LVLCHK(*NO) +
                          AUT(*ALL)

             DLTF       FILE(QTEMP/AB#WP452)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP452) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(30000) LVLCHK(*NO) +
                          AUT(*ALL)

             DLTF       FILE(QTEMP/AB#WP2A)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP2A) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(30000) LVLCHK(*NO) +
                          AUT(*ALL)

             DLTF       FILE(QTEMP/AB#EP4T)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(AB#EP4T) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/AB#EP4T

  /*TEST * JW1 2016.02.18 ADDED: SAVE AB#EP40 TO AB#EP40S */
  /*TEST**** CALL       PGM(EDSR40) **********************************/

             OVRDBF     FILE(AB#EP4T) TOFILE(QTEMP/AB#EP4T)

             OVRDBF     FILE(AB#WP451) TOFILE(QTEMP/AB#WP451)
             OVRDBF     FILE(AB#WP2A) TOFILE(QTEMP/AB#WP2A)
             CALL       PGM(AB#R0A)

/***************************************/
/* TEMP                                */
/*           GOTO       CMDLBL(ENDP)   */
/***************************************/


  /*TEST*/
  /*TEST     RTVMBRD    FILE(AB#EP20) NBRCURRCD(&KEN)                */
  /*TEST     IF         COND(&KEN *GT 0) THEN(DO)                    */
  /*TEST     CALL       PGM(AB#R0Q)                                  */
  /*TEST                                                             */
  /*TEST     OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) SAVE(*YES)       */
  /*TEST                                                             */
  /*TEST     CALL       PGM(AB#RE3) PARM(&PSPO)                      */
  /*TEST     IF         COND(&PSPO *EQ '1') THEN(DO)                 */
  /*TEST     CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132) +        */
  /*TEST                  JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)        */
  /*TEST                                                             */
  /*TEST                                                             */
  /*TEST     OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132)          */
  /*TEST     CALL       PGM(AB#RW0)                                  */
  /*TEST     DLTOVR     FILE(PRT132)                                 */
  /*TEST                                                             */
  /*TEST     IF         COND(&USER *NE 'TEST') THEN(DO)              */
  /*TEST                                                             */
  /*TEST     SNDDST     TYPE(*FILE) TOINTNET(                    +   */
  /*TEST                  (EDI862SpecialOrderGM@iafi.com)        +   */
  /*TEST                                    )                    +   */
  /*TEST                  DSTD('GM-SPO order information')       +   */
  /*TEST                  MSG('We received the order information +   */
  /*TEST                  from GM-SPO. Please check the attached +   */
  /*TEST                  list.(AB#C0A).')                       +   */
  /*TEST                  DOCFILE(HWFILE1/PRT132)                +   */
  /*TEST                  DOCTYPE(*FFT) SNDFMT(*NOTE)            +   */
  /*TEST                  DOCD('GM-SPO order information')           */
  /*TEST     ENDDO                                                   */
/* TCHK1 E */
  /*TEST     ENDDO                                                   */
  /*TEST     DLTOVR     FILE(QPRINT)                                 */
  /*TEST     ENDDO                                                   */

  /* VW */
             RTVMBRD    FILE(HFILE1/ABVEP20) NBRCURRCD(&KEN)
             IF         COND(&KEN *GT 0) THEN(DO)
             CALL       PGM(ABVRE3)
             ENDDO

             IF         COND(%SWITCH(0XXXXXXX)) THEN(GOTO CMDLBL(ENDP))

             DLTF       FILE(QTEMP/AB#WP453)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP453) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(30000) LVLCHK(*NO) +
                          AUT(*ALL) /* TCHK4 */

             DLTF       FILE(QTEMP/AB#WP454)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP454) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(30000) LVLCHK(*NO) +
                          AUT(*ALL) /* TCHK4 */

             DLTF       FILE(QTEMP/AB#WP455)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP455) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(30000) LVLCHK(*NO) +
                          AUT(*ALL) /* TCHK5 */

             DLTF       FILE(QTEMP/AB#WP456)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP456) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(30000) LVLCHK(*NO) +
                          AUT(*ALL) /* TCHK8 */

             FMTDTA     INFILE((QTEMP/AB#WP451)) +
                          OUTFILE(QTEMP/AB#WP453) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S45) +
                          OPTION(*NOPRT)
    /*TEST   DLTF       FILE(QTEMP/AB#WP451)                      */

             OVRDBF     FILE(AB#WP453) TOFILE(QTEMP/AB#WP453)
             OVRDBF     FILE(AB#WP454) TOFILE(QTEMP/AB#WP454)
             OVRDBF     FILE(AB#WP455) TOFILE(QTEMP/AB#WP455)
             OVRDBF     FILE(AB#WP456) TOFILE(QTEMP/AB#WP456)

             CALL       PGM(AB#R452)
             CALL       PGM(AB#R453)
             CALL       PGM(AB#R455)

             FMTDTA     INFILE((QTEMP/AB#WP456)) +
                          OUTFILE(QTEMP/AB#WP452) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S45) +
                          OPTION(*NOPRT)

             DLTF       FILE(QTEMP/AB#WP201)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP201) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(30000) LVLCHK(*NO) +
                          AUT(*ALL)

             OVRDBF     FILE(AB#WP452) TOFILE(QTEMP/AB#WP452)
             OVRPRTF    FILE(QPRINT) OUTQ(LANPRT50) HOLD(*YES) +
                          SAVE(*YES) /* TCHK2 */
             CALL       PGM(AB#R451)
             DLTOVR     FILE(QPRINT)

             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ)
             OVRPRTF    FILE(QPRINT2) OUTQ(SAVEOUTQ)
             OVRPRTF    FILE(QPRINT6) OUTQ(SAVEOUTQ)

             OVRPRTF    FILE(QPRINT)  OUTQ(EPRINT1) HOLD(*YES)
             OVRPRTF    FILE(QPRINT2) OUTQ(EPRINT1) HOLD(*YES)
             OVRPRTF    FILE(QPRINT5) OUTQ(EPRINT1) HOLD(*YES)
             OVRPRTF    FILE(QPRINT6) OUTQ(EPRINT1) HOLD(*YES)

             OVRDBF     FILE(AB#WP452) TOFILE(QTEMP/AB#WP452)
             OVRDBF     FILE(AB#WP201) TOFILE(QTEMP/AB#WP201)

/* *************************************************************** */
             CALL       PGM(AB#R45) PARM(&USER)

             GOTO ENDP

ENDP:
             ENDPGM
