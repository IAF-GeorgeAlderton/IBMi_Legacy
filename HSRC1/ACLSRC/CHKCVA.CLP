             PGM

             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&CHKWPV0) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CHKWPV1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FLG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SYS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SUBJ) TYPE(*CHAR) LEN(32)

             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(10)

             RTVNETA    SYSNAME(&SYS)

             CHGVAR     VAR(&WLIB) VALUE('HWFILE1')

             RTVJOBA    JOB(&WSID)
             CHGVAR     VAR(&WT) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&CHKWPV0) VALUE('CHKWPV0' *CAT &WT)
             CHGVAR     VAR(&CHKWPV1) VALUE('CHKWPV1' *CAT &WT)

             CALL       PGM(CHKCV0)

             OVRDBF     FILE(CHKWPV1) TOFILE(&WLIB/&CHKWPV1)

             CALL       PGM(CHKRVA) PARM(&FLG)

             DLTOVR     FILE(*ALL)

             CHGVAR     VAR(&SUBJ) VALUE(&SYS *CAT ':WRKDSKSTS CHK OK/CHKCVA')
             IF         COND(&FLG *NE ' ') THEN(DO)
             CHGVAR     VAR(&SUBJ) VALUE(&SYS *CAT ':WRKDSKSTS ERR !!/CHKCVA')
             SNDDST     TYPE(*FILE) +
                          TOINTNET(('ERR_IAF_AS400_JOB@asj-fasteners.+
                          co.jp')) DSTD('DSTS') MSG(&SUBJ) +
                          DOCFILE(&CHKWPV0) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD(&SUBJ)
             ENDDO

          /* SNDDST     TYPE(*FILE) +
                          TOINTNET(('T-SAKASHITA@asj-fasteners.+
                          co.jp')) DSTD('DSTS') MSG(&SUBJ) +
                          DOCFILE(&CHKWPV0) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD(&SUBJ) */

             SNDDST     TYPE(*FILE) +
                          TOINTNET(('QSYSOPR@AOYAMAGRP.COM')) +
                          DSTD('DSTS') MSG(&SUBJ) DOCFILE(&CHKWPV0) +
                          DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD(&SUBJ)

             ENDPGM
