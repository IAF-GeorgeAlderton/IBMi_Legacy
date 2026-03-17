             PGM
             /** AB#C00 **********************************************/
             /*  GENTRAN EDI MENU                                    */
             /*    H.AMANO       DEC/03/02                           */
             /*                                                      */
             /* TCHK1 11/22/06 CHG CHGLIBL COMMAND                   */
             /********************************************** AB#C00 **/
             DCLF       FILE(AB#PW00)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PEND) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&END)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&DAT)  TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&US)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&US &WLIB)
  START:
             CHGVAR     VAR(&D@OPTN) VALUE(' ')

             SNDRCVF    RCDFMT(DSP01)

             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@END))

             IF         COND(&D@OPTN *EQ '1') THEN(CALL PGM(AB#C0F))

             IF         COND(&D@OPTN *EQ '2') THEN(CALL PGM(AB#C0G))

             IF         COND(&D@OPTN *EQ '3') THEN(CALL PGM(EB#C6K))

             IF         COND(&D@OPTN *EQ '4') THEN(DO)
             IF         COND(&WLIB *EQ 'TWFILE1') THEN(DO)
/* TCHK1 */  CHGLIBL    LIBL(QTEMP QGPL TFILE1 TWFILE1 QPCFSU QMGU +
                          TOBJ1 TJRN1 HSRC1 G3X6DTA G3X6PGM) +
                          CURLIB(G3X1CUSOBJ)
             ENDDO
             IF         COND(&WLIB *EQ 'HWFILE1') THEN(DO)
/* TCHK1 */  CHGLIBL    LIBL(QTEMP QGPL HFILE1 HWFILE1 QPCFSU QMGU +
                          HOBJ1 HJRN1 HSRC1 G3X6DTA G3X6PGM) +
                          CURLIB(G3X1CUSOBJ)
             ENDDO
             SLTMSG
             ENDDO

             IF         COND(&D@OPTN *EQ '5') THEN(DO)
             IF         COND(&WLIB *EQ 'TWFILE1') THEN(DO)
/* TCHK1 */  CHGLIBL    LIBL(QTEMP QGPL TFILE1 TWFILE1 QPCFSU QMGU +
                          TOBJ1 TJRN1 HSRC1 G3X6DTA G3X6PGM) +
                          CURLIB(G3X1CUSOBJ)
             ENDDO
             IF         COND(&WLIB *EQ 'HWFILE1') THEN(DO)
/* TCHK1 */  CHGLIBL    LIBL(QTEMP QGPL HFILE1 HWFILE1 QPCFSU QMGU +
                          HOBJ1 HJRN1 HSRC1 G3X6DTA G3X6PGM) +
                          CURLIB(G3X1CUSOBJ)
             ENDDO
             CALL       PGM(AB#R0Z) PARM(&DAT &END)
             IF         COND(&END *EQ ' ') THEN(DO)
             SLTAUD     DIRECTION(*IN) FROMDT(&DAT)
             ENDDO
             ENDDO

             IF         COND(&D@OPTN *EQ '6') THEN(DO)
             IF         COND(&WLIB *EQ 'TWFILE1') THEN(DO)
/* TCHK1 */  CHGLIBL    LIBL(QTEMP QGPL TFILE1 TWFILE1 QPCFSU QMGU +
                          TOBJ1 TJRN1 HSRC1 G3X6DTA G3X6PGM) +
                          CURLIB(G3X1CUSOBJ)
             ENDDO
             IF         COND(&WLIB *EQ 'HWFILE1') THEN(DO)
/* TCHK1 */  CHGLIBL    LIBL(QTEMP QGPL HFILE1 HWFILE1 QPCFSU QMGU +
                          HOBJ1 HJRN1 HSRC1 G3X6DTA G3X6PGM) +
                          CURLIB(G3X1CUSOBJ)
             ENDDO
             CALL       PGM(AB#R0Z) PARM(&DAT &END)
             IF         COND(&END *EQ ' ') THEN(DO)
             SLTAUD     DIRECTION(*OUT) FROMDT(&DAT)
             ENDDO
             ENDDO

             IF         COND(&D@OPTN *EQ '7') THEN(GENTRAN)

             IF         COND(&D@OPTN *EQ '8') THEN(CALL PGM(AB#R0T))

             IF         COND(&D@OPTN *EQ '9') THEN(CALL PGM(AB#R0X))


             GOTO       CMDLBL(START)
 @END:

             ENDPGM
