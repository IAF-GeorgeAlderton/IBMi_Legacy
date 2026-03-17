             PGM
/** ALCC17 **********************************************/
/*  THE NUMBER OF PROCESSED BOXES BY WORKER LIST INQUIRY*/
/*                                                      */
/* TCHK1 06/04/09 CREATE(COPY FROM ALDC05)              */
/********************************************************/
             DCLF       FILE(ALCPW17)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&ST)   TYPE(*CHAR) LEN(02)

             RTVJOBA    JOB(&WSID) USER(&USR)

             CHGVAR     VAR(&YEAR) VALUE(0)
             CHGVAR     VAR(&MM)   VALUE(0)
             CHGVAR     VAR(&DD)   VALUE(0)
    /*       CHGVAR     VAR(&USER) VALUE('      ')     */

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(ALCPW171)

             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         (&IN01 *EQ '1') GOTO END

             IF         (&YEAR *NE 0) GOTO STP2
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             GOTO       STP1

 STP2:
             IF         ((&MM *GE 01) *AND (&MM *LE 12)) GOTO STP3
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             GOTO       STP1


 STP3:

             CRTDUPOBJ  OBJ(ALCWP15) FROMLIB(HWFILE1) +
                          OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/ALCWP15)

             CRTDUPOBJ  OBJ(ALCWL15) FROMLIB(HWFILE1) +
                          OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(ALCWP15) TOFILE(QTEMP/ALCWP15)
             OVRDBF     FILE(ALCWL15) TOFILE(QTEMP/ALCWL15)

             CALL       PGM(ALCR151) PARM(&YEAR &MM &DD)

             CALL       PGM(ALCR161) PARM(&YEAR &MM &DD &ST)

             IF         COND(&ST *EQ '12') THEN(GOTO CMDLBL(STP1))
 END:
             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000)

             ENDPGM
