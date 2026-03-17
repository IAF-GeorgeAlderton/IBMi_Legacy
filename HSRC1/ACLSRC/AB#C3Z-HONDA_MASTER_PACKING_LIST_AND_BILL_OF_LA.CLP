/* AB3C3Z ***********************************************************/
/* HONDA MASTER PACKING LIST AND BILL OF LADING                     */
/* JW    2022.05.17                                                 */
/*                                                                ED*/
/********************************************************************/
             DCL        VAR(&OUTS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OUTT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OUTU) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OUTV) TYPE(*CHAR) LEN(1)

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             CALL       PGM(AB#R3Z) PARM(&OUTS &OUTT &OUTU &OUTV)
/* B/L */
             IF         COND(&OUTS *NE ' ') THEN(DO)
             CRTDUPOBJ  OBJ(PRT132A) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/PRT132A)
             CPYSPLF    FILE(AB#PR3S) TOFILE(QTEMP/PRT132A) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132 ) TOFILE(QTEMP/PRT132A)
             CALL       PGM(AB#RW1)
                /*XXXXXXXXXXXXXXXXXXXXX*/
             ENDDO

ENDP:
     ENDPGM
