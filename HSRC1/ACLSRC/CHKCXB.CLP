             PGM

             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&CHKWPX0) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CHKWPX1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CHKWPXB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FLG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SYS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SUBJ) TYPE(*CHAR) LEN(32)

             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CHKWPXB) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID)
             CHGVAR     VAR(&WT) VALUE(%SST(&WSID 1 3))
             RTVNETA    SYSNAME(&SYS)

             CHGVAR     VAR(&WLIB) VALUE('HWFILE1')

             RTVJOBA    JOB(&WSID)
             CHGVAR     VAR(&WT) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&WLIB) VALUE('HWFILE1')

             CHGVAR     VAR(&CHKWPX0) VALUE('CHKWPX0' *CAT &WT)
             CHGVAR     VAR(&CHKWPX1) VALUE('CHKWPX1' *CAT &WT)
             CHGVAR     VAR(&CHKWPXB) VALUE('CHKWPXB' *CAT &WT)

             CALL       PGM(CHKCX0)

             OVRDBF     FILE(CHKWPX1) TOFILE(&WLIB/&CHKWPX1)

             CALL       PGM(CHKRXA) PARM(&FLG)

             DLTOVR     FILE(*ALL)

             DLTF       FILE(&CHKWPXB)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&CHKWPXB) RCDLEN(35)

          /* CHKWPX1 -> CHKWPXB */
             OVRDBF     FILE(CHKWPX1) TOFILE(&WLIB/&CHKWPX1)
             OVRDBF     FILE(CHKWPXB) TOFILE(&WLIB/&CHKWPXB)
             CALL       PGM(CHKRXB)
             DLTOVR     FILE(*ALL)

             CHGVAR     VAR(&SUBJ) VALUE(&SYS *CAT ':WRKDSTQ CHK OK/CHKCXA')
             IF         COND(&FLG *NE ' ') THEN(DO)
             CHGVAR     VAR(&SUBJ) VALUE(&SYS *CAT ':WRKDSTQ ERR !!/CHKCXA')
             SNDDST     TYPE(*FILE) +
                          TOINTNET(('ERR_IAF_AS400_JOB@asj-fasteners.+
                          co.jp')) DSTD('DSTS') MSG(&SUBJ) +
                          DOCFILE(&CHKWPXB) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD(&SUBJ)
             ENDDO

          /* SNDDST     TYPE(*FILE) +
                          TOINTNET(('T-SAKASHITA@asj-fasteners.+
                          co.jp')) DSTD('DSTS') MSG(&SUBJ) +
                          DOCFILE(&CHKWPXB) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD(&SUBJ) */

             SNDDST     TYPE(*FILE) +
                          TOINTNET(('QSYSOPR@AOYAMAGRP.COM')) +
                          DSTD('DSTS') MSG(&SUBJ) DOCFILE(&CHKWPXB) +
                          DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD(&SUBJ)

             SNDDST     TYPE(*FILE) +
                          TOINTNET(('SAKASHITA.TOMOKIYO@AOYAMAGRP.COM')) +
                          DSTD('DSTS') MSG(&SUBJ) DOCFILE(&CHKWPXB) +
                          DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD(&SUBJ)

             ENDPGM
