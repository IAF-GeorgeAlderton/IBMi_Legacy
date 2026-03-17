/* PROCESS FORD 997S.  CREATE REPORT.      */
/*              OCTOBER 13, 2015. RMK.     */
/*                                         */
/*-----------------------------------------*/
             PGM

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&CNT) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&PD) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             CRTPF      FILE(QTEMP/CMPFIL) RCDLEN(80)
             MONMSG     MSGID(CPF5813 CPF7302) EXEC(CLRPFM +
                          FILE(QTEMP/CMPFIL))
             CRTPF      FILE(QTEMP/DCMFIL) RCDLEN(2000)
             MONMSG     MSGID(CPF5813 CPF7302) EXEC(CLRPFM +
                          FILE(QTEMP/DCMFIL))

             CALL       PGM(AB#RG4)
             CALL       PGM(AB#RG5)
             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) HOLD(*YES)
             CALL       PGM(AB#RG6) PARM(&PD)
             DLTOVR     FILE(QPRINT)

             IF         COND(&PD *NE ' ') THEN(DO)
             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132A) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132A)
             CALL       PGM(AB#RW0)
             DLTOVR     FILE(PRT132)
             DLTSPLF    FILE(QPRINT) JOB(&NBR/&USER/&WSID) +
                          SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)

             IF         COND(&USER *NE 'TEST') THEN(DO)
             SNDDST     TYPE(*FILE) +
                          TOINTNET(('Ford-ASN-997@iafi.com')) +
                          DSTD('EDI 997 Functional +
                          Acknowledgements.') MSG('EDI Ford +
                          Acknowledgement (997) has been processed.  +
                          Please check the attached list.') +
                          DOCFILE(HWFILE1/PRT132A) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('EDI 997 +
                          Acknowledgements.')
                        ENDDO
             ENDDO

        /* TEST SAKAKI */
             RTVMBRD    FILE(AB#PP6U) NBRCURRCD(&CNT)
             IF         (&CNT *GT 0) THEN(DO)
             CPYF       FROMFILE(AB#PP6U)  TOFILE(AB#PP6US) +
                          MBROPT(*ADD)
             MONMSG     MSGID(CPF0000)
             ENDDO

             ENDPGM
