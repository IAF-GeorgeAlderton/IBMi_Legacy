             PGM
             /** AB#C0W **********************************************/
             /*  FRS LISTS PRINT                                     */
             /*    H.AMANO       MAR/03/03                           */
             /*                                                      */
             /*                                                      */
             /********************************************** AB#C0W **/


             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             RTVMBRD    FILE(AB#WPGN) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL(@END))

             CPYF       FROMFILE(AB#WPGN) TOFILE(QTEMP/AB#GN) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          INCREL((*IF BAPRNT *EQ ' '))

             RTVMBRD    FILE(QTEMP/AB#GN) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             CLRPFM     FILE(AB#WPGN)
             MONMSG     MSGID(CPF0000)
             GOTO       CMDLBL(@END)
             ENDDO


             CPYF       FROMFILE(QTEMP/AB#GN) TOFILE(&WLIB/AB#WPGN) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF0000)

  @END:
             ENDPGM
