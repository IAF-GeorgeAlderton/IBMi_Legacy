             PGM
             /** AB#C0V1 *********************************************/
             /*  RUN GENTRAN EDI                                     */
             /*    H.AMANO       MAR/12/03                           */
             /*                                                      */
             /* TCHK  11/17/13 CREATE(COPY FROM AB#C0V)              */
             /********************************************************/

             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&END) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CALL       PGM(AB#R0V) PARM(&END)

             IF         COND(&END *EQ '1') THEN(GOTO CMDLBL(@END))

             CHGLIBL    LIBL(QTEMP QGPL HFILE1 HWFILE1 QPCFSU QMGU +
                          HOBJ1 HJRN1 HSRC1 G3X6DTA G3X6PGM) +
                          CURLIB(G3X1CUSOBJ)

             OVRMSGF    MSGF(QTCPMSGF) TOMSGF(QTCP/QTCPMSGF)
             CHGJOB     LOG(0 0) JOBMSGQFL(*WRAP)

             CALL       PGM(GENEDIY)

  @END:
             SIGNOFF

             ENDPGM
