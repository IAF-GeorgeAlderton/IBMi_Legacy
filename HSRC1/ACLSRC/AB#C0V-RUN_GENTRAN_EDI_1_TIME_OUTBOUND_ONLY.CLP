             PGM
             /** AB#C0V **********************************************/
             /*  RUN GENTRAN EDI                                     */
             /*    H.AMANO       MAR/12/03                           */
             /*                                                      */
             /* TCHK1 11/22/06 CHG CHGLIBL                           */
             /********************************************** AB#C0W **/

             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&END) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CALL       PGM(AB#R0V) PARM(&END)

             IF         COND(&END *EQ '1') THEN(GOTO CMDLBL(@END))

/* TCHK1     CHGLIBL    LIBL(QTEMP QGPL HFILE1 HWFILE1 QPCFSU QMGU +
                          HOBJ1 HJRN1 HSRC1 GENSTD G3X1DTA G3X1PGM) +
                          CURLIB(G3X1CUSOBJ) */
/* TCHK1 */  CHGLIBL    LIBL(QTEMP QGPL HFILE1 HWFILE1 QPCFSU QMGU +
                          HOBJ1 HJRN1 HSRC1 G3X6DTA G3X6PGM) +
                          CURLIB(G3X1CUSOBJ)


             OVRMSGF    MSGF(QTCPMSGF) TOMSGF(QTCP/QTCPMSGF)
             CHGJOB     LOG(0 0) JOBMSGQFL(*WRAP)
             CALL       PGM(GENEDIZ)

  @END:
             SIGNOFF

             ENDPGM
