             PGM
             /**** GDIC10 ****************************************/
             /*  PRINT OF ORDER SHEET / TOTALIZATION OF DIE NO.  */
             /*     G.B.C                          97/03/06      */
             /*     TCH                            02/04/23      */
             /* TCHK1 04/05/11 CHG QPRINT --> LANPRT03           */
             /****************************************************/
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPGO) TYPE(*CHAR) LEN(2)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLIB)  TYPE(*CHAR) LEN(8)
             RTVJOBA    JOB(&WSID) USER(&PPUSER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             /* TEST MODE CHECK */
             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO
             /* *************** */

             CALL       PGM(GDIR10) PARM(&PPUSER &PPGO)
             IF         (&PPGO *NE 'GO')   GOTO END

             CPYF       FROMFILE(GDIPP01)  TOFILE(QTEMP/GDIPP01X) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          INCREL((*IF IGSYHZ *EQ 0))
             MONMSG     MSGID(CPF0000)

          /* CPYF       FROMFILE(GDIPP01)  TOFILE(YASU/GDIPP01_BK) +
                          MBROPT(*ADD) CRTFILE(*YES)  */
          /* MONMSG     MSGID(CPF0000)                */

             CLRPFM     FILE(GDIPP01)

             CPYF       FROMFILE(QTEMP/GDIPP01X) TOFILE(GDIPP01) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF0000)
             /* PRINT OF KANBAN TOTAL LIST */
/* TCHK1     OVRPRTF    FILE(QPRINT) OUTQ(QPRINT) FORMTYPE(K6H1) */
/* TCHK1 */  OVRPRTF    FILE(QPRINT) OUTQ(LANPRT03) FORMTYPE(K6H1)
             OVRDBF     FILE(GWIPL10) TOFILE(GDIPL10)
             CALL GDIR15
             DLTOVR *ALL

             CHKOBJ     OBJ(&FLIB/TRANS) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(&FLIB/TRANS) TYPE(*CHAR) LEN(2) +
                          TEXT('IAF->ASJ TRANSFER CHECK'))
             CHGDTAARA  DTAARA(&FLIB/TRANS (2 1)) VALUE('*')
             CRTDTAARA  DTAARA(HFILE1/GDIC10SM) TYPE(*CHAR) LEN(6) +
                        TEXT('サマリー済み')
             MONMSG     MSGID(CPF1023)

 END:        ENDPGM
