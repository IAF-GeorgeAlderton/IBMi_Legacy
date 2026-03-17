             PGM
             /** AB#C0V **********************************************/
             /*  RUN GENTRAN EDI                                     */
             /*    H.AMANO       MAR/12/03                           */
             /*                                                      */
             /*                                                      */
             /********************************************** AB#C0W **/

             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&END) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CALL       PGM(AB#R0V) PARM(&END)

             IF         COND(&END *EQ '1') THEN(GOTO CMDLBL(@END))

             CHGLIBL    LIBL(QTEMP QGPL TFILE1 TWFILE1 QPCFSU QMGU +
                          TOBJ1 HJRN1 HSRC1 GENSTD G3X1TST G3X1PGM)


             OVRMSGF    MSGF(QTCPMSGF) TOMSGF(QTCP/QTCPMSGF)

             SBMJOB     CMD(CALL PGM(G3X1CUSOBJ/GENEDI))


  @END:
             ENDPGM
