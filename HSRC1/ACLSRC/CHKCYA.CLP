             PGM

             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&CHKWPYA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SYS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0) VALUE(0)
             DCL        VAR(&SUBJ) TYPE(*CHAR) LEN(32)

             RTVNETA    SYSNAME(&SYS)

             RTVJOBA    JOB(&WSID)

             CHGVAR     VAR(&WT) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&CHKWPYA) VALUE('CHKWPYA' *CAT &WT)
             WRKNETF    USER(*ALL) OUTPUT(*OUTFILE) +
                          OUTFILE(HWFILE1/&CHKWPYA)

             RTVMBRD    FILE(HWFILE1/&CHKWPYA) NBRCURRCD(&REC)

             CHGVAR     VAR(&SUBJ) VALUE(&SYS *CAT ':WRKNETF CHK OK')
             IF         COND(&REC *NE 0) THEN(DO)
             CHGVAR     VAR(&SUBJ) VALUE(&SYS *CAT ':WRKNETF ERR !!')
             SNDDST     TYPE(*FILE) +
                          TOINTNET(('ERR_IAF_AS400_JOB@ASJ-FASTENERS.CO.+
                          JP')) DSTD('DSTS') MSG(&SUBJ) +
                          DOCFILE(&CHKWPYA) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD(&SUBJ)
             ENDDO

             IF         COND(&REC *NE 0) THEN(DO)
          /* SNDDST     TYPE(*FILE) +
                          TOINTNET(('T-SAKASHITA@ASJ-FASTENERS.CO.+
                          JP')) DSTD('DSTS') MSG(&SUBJ) +
                          DOCFILE(&CHKWPYA) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD(&SUBJ) */
             SNDDST     TYPE(*FILE) +
                          TOINTNET(('QSYSOPR@AOYAMAGRP.COM')) +
                          DSTD('DSTS') MSG(&SUBJ) DOCFILE(&CHKWPYA) +
                          DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD(&SUBJ)
             ENDDO

             IF         COND(&REC *EQ 0) THEN(DO)
          /* SNDDST     TYPE(*LMSG) +
                          TOINTNET(('T-SAKASHITA@ASJ-FASTENERS.CO.+
                          JP')) DSTD('DSTS') LONGMSG(&SUBJ) +
                          DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD(&SUBJ) */
             SNDDST     TYPE(*LMSG) +
                          TOINTNET(('QSYSOPR@AOYAMAGRP.COM')) +
                          DSTD('DSTS') LONGMSG(&SUBJ) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD(&SUBJ)
             ENDDO

             ENDPGM
