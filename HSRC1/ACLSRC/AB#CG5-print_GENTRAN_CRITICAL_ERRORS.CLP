/* SEND ERROR LEVEL 12 TO EMAIL OR QSYSOPR   */
/*              DECEMBER, 28, 2015.  RMK   */
/* ADD CLRPFM BEFORE CPYSPLF               */
/* 04/11/16.  CLOSE QPRINT IF OPEN         */
/*                                         */
/*-----------------------------------------*/
             PGM

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&ERR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CYYMMDD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CYMDNUM) TYPE(*DEC) LEN(7 0)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR) +
                          CYMDDATE(&CYYMMDD)
             CLOF       OPNID(QPRINT)
             MONMSG     MSGID(CPF4520)

             CHGVAR     VAR(&ERR) VALUE(' ')
             CHGVAR     VAR(&CYMDNUM) VALUE(&CYYMMDD)
             OVRPRTF    FILE(QPRINT) OUTQ(SAVEOUTQ) HOLD(*YES)
             CALL       PGM(AB#RG7) PARM(&NBR &CYMDNUM &ERR)
             DLTOVR     FILE(QPRINT)

             IF COND(&ERR = 'Y') THEN(DO)
             CLRPFM     FILE(HWFILE1/PRT132A)
             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132A) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132A)
             CALL       PGM(AB#RW0)
             DLTOVR     FILE(PRT132)

             SNDDST     TYPE(*FILE) +
                          TOINTNET(('AS400-System@iafi.com')) +
                          DSTD('Gentran EDI Critical Errors.') +
                          MSG('Gentran EDI Critical Error listing.  +
                          Please check the attached list.(AB#CG5).') +
                          DOCFILE(HWFILE1/PRT132A) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('Gentran Error Listing.')

             RLSSPLF    FILE(QPRINT) JOB(&NBR/&USER/&WSID) +
                          SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)
             CLOF       OPNID(QPRINT)
             MONMSG     MSGID(CPF4520)
             ENDDO
             ENDPGM
