             PGM
/** ANZC07 ************************************************/
/*  ORDER VS SAFETY INVENTORY CHECK LIST                  */
/*  JW   2018.12.21                                       */
/*-----------------------------------------               */
/*  JW1  2024.01.05 ADD DOWNLOSD FUNCTION                 */
/**********************************************************/
             DCL        VAR(&RTN1)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTN2)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRINT) TYPE(*CHAR) LEN(10)

/* SELECT PRINTER */
             CALL       PGM(UTLR69B) PARM(&PRINT &RTN1)
             IF         COND(&RTN1 = '*') THEN(GOTO CMDLBL(ENDP))

/* CREATE WORK FILE */
             CRTDUPOBJ  OBJ(ANZWP07) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/ANZWP07)
             OVRDBF     FILE(ANZWP07) TOFILE(QTEMP/ANZWP07)

             CALL       PGM(ANZR07) PARM(&RTN2)

/* PRINT REPORT   */
             IF         COND(&RTN1 *NE 'X') THEN(DO)
             OVRPRTF    FILE(QPRINT) OUTQ(&PRINT)
             CALL       PGM(ANZR08)
             GOTO       CMDLBL(ENDP)
             ENDDO

/* JW1 DOWNLOAD   */
             IF         COND(&RTN1 *EQ 'X') THEN(DO)
             CALL       PGM(ANZC07A)
             GOTO       CMDLBL(ENDP)
             ENDDO
ENDP:
             ENDPGM
