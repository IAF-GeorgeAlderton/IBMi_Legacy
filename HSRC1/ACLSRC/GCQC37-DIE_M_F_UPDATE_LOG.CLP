             PGM
             /** GCQC37 ********************************/
             /*    DIE      M/F UPDATE LOG             */
             /* TCH   1/11/05                          */
             /******************************** GADC12 **/

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CNT) TYPE(*DEC) LEN(10 0)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGJOB     SWS(00000000)
             OVRPRTF    FILE(QPRINT) OUTQ(QPRINT) SAVE(*YES)

             CALL       PGM(GCQR37)

             CPYF       FROMFILE(&WLIB/GCQWP11) +
                          TOFILE(QTEMP/GCQWP11BK) MBROPT(*REPLACE) +
                          CRTFILE(*YES) INCREL((*IF WWPRNT *EQ ' '))
             MONMSG     MSGID(CPF0000)

             RTVMBRD    FILE(GCQWP11BK) NBRCURRCD(&CNT)
             IF         COND(&CNT *EQ 0) THEN(DO)
             CLRPFM GCQWP11
             MONMSG     MSGID(CPF0000)
             GOTO @SKIP
             ENDDO

             CPYF       FROMFILE(QTEMP/GCQWP11BK) +
                          TOFILE(&WLIB/GCQWP11) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF0000)
    @SKIP:
             DLTOVR     FILE(*ALL)

             IF         COND(%SWITCH(1XXXXXXX)) THEN(DO)

             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132B) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132B)
             CALL       PGM(AB#RW0)

 /*          SNDDST     TYPE(*FILE) TOINTNET((ClarkB@iafi.com) +
                          (*NONE *CC) (TakagiT@iafi.com *CC)) +
                          DSTD('DIE ALLOTMENT M/F UPDATE LOG') +
                          MSG('Die Allotment M/F code has been +
                          updated. Please check the attached +
                          list.') DOCFILE(HWFILE1/PRT132B) +
                          DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD('Die +
                          allotment update log')  */
             SNDDST     TYPE(*FILE) TOINTNET((*NONE) (*NONE *CC) +
                          (TanebeK@iafi.com *CC)) DSTD('DIE +
                          ALLOTMENT M/F UPDATE LOG') MSG('Die +
                          Allotment M/F code has been updated. +
                          Please check the attached list. +
                          (GCQC37)') DOCFILE(HWFILE1/PRT132B) +
                          DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD('Die +
                          allotment update log')
             DLTOVR     FILE(PRT132)
             DLTSPLF    FILE(QPRINT) JOB(&NBR/&USER/&WSID) +
                          SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)
             ENDDO

             ENDPGM
