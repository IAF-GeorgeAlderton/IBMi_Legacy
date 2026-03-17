             PGM
             /** ALDC04 **********************************************/
             /*  THE NUMBER OF PROCESSED BOXES BY WORKER LIST        */
             /*  TCH 00.08.14                                        */
             /*  THE NUMBER OF PROCESSED BOXES BY DATE(ALDR08)ADDED  */
             /*  TCH 00.01.15                                        */
             /*  ADD DAILY REPORT OPTION(F09)    TCH OCT/10/02       */
             /*  TCH 02/02/05 SCREEN VERSION                         */
             /*  TCHK1 04/21/06 CHG HWFILE1 ---> QTEMP               */
             /*  TCHK3 03/05/07 BUG FIX                              */
             /********************************************** ALDC04 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&ST)   TYPE(*CHAR) LEN(02)
             DCL        VAR(&YEAR) TYPE(*DEC) LEN(04 0)
             DCL        VAR(&MM) TYPE(*DEC) LEN(02 0)
             DCL        VAR(&DD) TYPE(*DEC) LEN(02 0)
             DCL        VAR(&HHMM) TYPE(*DEC) LEN(04 0)
             DCL        VAR(&YEAR2) TYPE(*DEC) LEN(04 0)
             DCL        VAR(&MM2) TYPE(*DEC) LEN(02 0)
             DCL        VAR(&DD2) TYPE(*DEC) LEN(02 0)
             DCL        VAR(&HHMM2) TYPE(*DEC) LEN(04 0)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(02)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1) VALUE('3')

             RTVJOBA    JOB(&WSID) USER(&USR)

             CHGVAR     VAR(&YEAR) VALUE(0)
             CHGVAR     VAR(&MM)   VALUE(0)
             CHGVAR     VAR(&DD)   VALUE(0)

 STP1:
             CALL       PGM(ALDRA5) PARM(&YEAR &MM &DD &HHMM &YEAR2 +
                          &MM2 &DD2 &HHMM2 &PCMD)

             IF         COND(&PCMD *EQ '01') THEN(GOTO CMDLBL(END))

 STP2:
 STP3:

             CRTDUPOBJ  OBJ(ALDWP07) FROMLIB(HWFILE1) +
                          OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(QTEMP/ALDWP07)
             MONMSG     MSGID(CPF0000)

             CRTDUPOBJ  OBJ(ALDL704) FROMLIB(HWFILE1) +
                          OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(ALDWP05) TOFILE(QTEMP/ALDWP07)
             OVRDBF     FILE(ALDWL04) TOFILE(QTEMP/ALDL704)

             CALL       PGM(ALDR13) PARM(&YEAR &MM &DD &HHMM &YEAR2 +
                          &MM2 &DD2 &HHMM2)

             CALL       PGM(ALDR12) PARM(&YEAR &MM &DD &HHMM &YEAR2 +
                          &MM2 &DD2 &HHMM2 &ST &TYPE)

             IF         COND(&ST *EQ '12') THEN(GOTO CMDLBL(STP1))
 END:
             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000)

             ENDPGM
