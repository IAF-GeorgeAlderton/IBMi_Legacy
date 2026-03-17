             PGM
             /** ALDC38 **********************************************/
             /*  THE NUMBER OF PROCESSED BOXES BY WORKER INQUIRY     */
             /*  FOR THE INTO LOCATION SCAN.                         */
             /********************************************** ALDC38 **/

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
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1) VALUE('2')

             RTVJOBA    JOB(&WSID) USER(&USR)

             CHGVAR     VAR(&YEAR) VALUE(0)
             CHGVAR     VAR(&MM)   VALUE(0)
             CHGVAR     VAR(&DD)   VALUE(0)

 STP1:
 /*************************************************************************/
 /*  Call Pgm to Get Date Range for Inquiry                               */
             CALL       PGM(ALDRA5) PARM(&YEAR &MM &DD &HHMM &YEAR2 +
                          &MM2 &DD2 &HHMM2 &PCMD)

 /*   F1 = End Program                                                    */
             IF         COND(&PCMD *EQ '01') THEN(GOTO CMDLBL(END))

 /*************************************************************************/
 /*  Create Empty Workfile in QTEMP for Inquiry                           */

             CRTDUPOBJ  OBJ(ALDWP38) FROMLIB(HWFILE1) +
                          OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(QTEMP/ALDWP38)
             MONMSG     MSGID(CPF0000)

 /*  Create Logical over the Workfile.                                    */
             CRTDUPOBJ  OBJ(ALDWL38) FROMLIB(HWFILE1) +
                          OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

 /*************************************************************************/
 /*  Call Pgm to Create Workfile info based on Date Range from Prev Step. */
             OVRDBF     FILE(ALDWP38) TOFILE(QTEMP/ALDWP38)

             CALL       PGM(ALDR38) PARM(&YEAR &MM &DD &HHMM &YEAR2 +
                          &MM2 &DD2 &HHMM2)

 /*************************************************************************/
 /*  Call Pgm to Display Total Boxes by Worker for Specified Date Range.  */
             OVRDBF     FILE(ALDWL38) TOFILE(QTEMP/ALDWL38)

             CALL       PGM(ALDR39) PARM(&YEAR &MM &DD &HHMM &YEAR2 +
                          &MM2 &DD2 &HHMM2 &ST &TYPE)

 /*************************************************************************/
 /*  If F12 to Cancel, go back to Step 1 and Enter new Date Range.        */
             IF         COND(&ST *EQ '12') THEN(GOTO CMDLBL(STP1))

 END:

 /*************************************************************************/
             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000)

             ENDPGM
