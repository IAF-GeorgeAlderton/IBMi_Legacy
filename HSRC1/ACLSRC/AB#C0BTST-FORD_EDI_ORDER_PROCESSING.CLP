             PGM
             /** AB#C0B *************************************************/
             /*  EDI ORDER PROCESSING (FORD)                            */
             /************************************** AB#C0B *************/

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CNT) TYPE(*DEC) LEN(10 0)

             RTVMBRD    FILE(TFILE1/AB#EP50) NBRCURRCD(&CNT)
             IF         COND(&CNT *EQ 0) THEN(GOTO CMDLBL(@END))

    /* CLEAR 1PROCESS FILE */
             CLRPFM     FILE(TFILE1/ABF1P01)
             MONMSG     MSGID(CPF0000)

    /* CREATE 1PROCESS FILE */
             OVRDBF     FILE(AB#EP50) TOFILE(TFILE1/AB#EP50)
             OVRDBF     FILE(ABFAP01) TOFILE(TFILE1/ABFAP01)
             OVRDBF     FILE(ABFAL01) TOFILE(TFILE1/ABFAL01)
             OVRDBF     FILE(ABF1L01) TOFILE(TFILE1/ABF1L01)
             OVRDBF     FILE(AB#PPCT) TOFILE(TFILE1/AB#PPCT)
             CALL       PGM(TOBJ1/AB#R0E)

    /* PRINT DATA LIST */
             OVRPRTF    FILE(QPRINT) OUTQ(QDKT)
             OVRDBF     FILE(ABF1L01) TOFILE(TFILE1/ABF1L01)
             OVRDBF     FILE(EDIPL30) TOFILE(HFILE1/EDIPL30)
             OVRDBF     FILE(FCEPL01) TOFILE(HFILE1/FCEPL01)
             OVRDBF     FILE(ABFDP01) TOFILE(HFILE1/ABFDP01)
             CALL       PGM(TOBJ1/AB#RF2)
             DLTOVR     FILE(QPRINT)

    /* MOVE 1PROCESS FILE TO SUMMURY FILE */
      /*     CPYF       FROMFILE(ABF1P01) TOFILE(ABF2P01) +  */
      /*                  MBROPT(*ADD)                       */
      /*     MONMSG     MSGID(CPF0000)                       */

             CPYF       FROMFILE(TFILE1/ABF1P01) +
                          TOFILE(TFILE1/ABFHP01) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)

             CLRPFM     FILE(TFILE1/ABFIP01)
             CLRPFM     FILE(TFILE1/ABFJP01)

             MONMSG     MSGID(CPF0000)
             OVRDBF     FILE(ABFHP01) TOFILE(TFILE1/ABFHP01)
             OVRDBF     FILE(ABF2L04) TOFILE(TFILE1/ABF2L04)
             OVRDBF     FILE(ABFIP01) TOFILE(TFILE1/ABFIP01)
             OVRDBF     FILE(ABFJP01) TOFILE(TFILE1/ABFJP01)
             CALL       PGM(TOBJ1/AB#RF7F4)

/** TEMP **/
             GOTO CMDLBL(@END)
/**********/

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)
             OVRPRTF    FILE(QPRINT) OUTQ(QPRINT) FORMTYPE(K6H1) +
                          HOLD(*YES)
             OVRDBF     FILE(ABFDP01) TOFILE(HFILE1/ABFDP01)
             OVRDBF     FILE(ABFAP01) TOFILE(TFILE1/ABFAP01)
             OVRDBF     FILE(ABF9P01) TOFILE(HFILE1/ABF9P01)
             OVRDBF     FILE(ABF1L01) TOFILE(TFILE1/ABF1L01)
             OVRDBF     FILE(GADPL11) TOFILE(HFILE1/GADPL11)
             CALL       PGM(TOBJ1/AB#RFN) PARM(&PD)

             IF         COND(&PD *NE ' ') THEN(DO)
             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132B) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             RLSSPLF    FILE(QPRINT) JOB(&NBR/&USER/&WSID) +
                          SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132B)
             CALL       PGM(AB#RW0)

             SNDDST     TYPE(*FILE) TOINTNET(                  +
                                             (TANEBEK@iafi.com)) +
                          DSTD('<<TEST>> FORD error List') +
                          MSG('<<TEST>> Please check +
                          the attached list.') +
                          DOCFILE(HWFILE1/PRT132B) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('FORD Error list')
             DLTOVR     FILE(PRT132)
             ENDDO

/* TTTTTTTTT CLRPFM     FILE(AB#EP50) TTTTTTTTTTTT */

             DLTOVR     FILE(*ALL)
@END:

             ENDPGM
