             PGM
             /** CHKCJ42 ***********************************************/
             /*  SERACH "MSGW" FROM WRKACTJOB                          */
             /*  JW    2025.05.15                                      */
             /**********************************************************/
             DCL        VAR(&SYS)     TYPE(*CHAR) LEN(8)
             DCL        VAR(&WSID)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT)      TYPE(*CHAR) LEN(3)
             DCL        VAR(&WLIB)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&CHKWPU1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&REC)     TYPE(*DEC)  LEN(10 0) VALUE(0)

             RTVNETA    SYSNAME(&SYS)
             RTVJOBA    JOB(&WSID)
             CHGVAR     VAR(&WT) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&WLIB) VALUE('HWFILE1')

             CHGVAR     VAR(&CHKWPU1) VALUE('CHKWPU1' *CAT &WT)

             CLRPFM     FILE(&WLIB/CHKWPJ42)

             OVRDBF     FILE(CHKWPU1) TOFILE(&WLIB/&CHKWPU1)
             CALL       PGM(CHKRJ42)

             RTVMBRD    FILE(CHKWPJ42) NBRCURRCD(&REC)
             IF         (&REC *NE 0) THEN(DO)
             SNDDST     TYPE(*FILE) +
                          TOINTNET(('AS400-SYSTEM@IAFI.com')) +
                          DSTD('** FOUND MSGW **') MSG('!! REPLY +
                          FOR MSGW !! (CHKCJ42)') +
                          DOCFILE(HWFILE1/CHKWPJ42) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('** MSGW **')
             ENDDO

             DLTOVR     FILE(*ALL)

             ENDPGM
