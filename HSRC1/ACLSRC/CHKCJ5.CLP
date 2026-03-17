             PGM

             DCL        VAR(&SYS) TYPE(*CHAR) LEN(8)

             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&SRCL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(10)

             DCL        VAR(&ECNT) TYPE(*DEC) LEN(3 0)

             DCL        VAR(&CHKWPU1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CHKWPJ2) TYPE(*CHAR) LEN(10)

             DCL        VAR(&REC)   TYPE(*DEC)  LEN(10 0) VALUE(0)

             DCL        VAR(&DOCD) TYPE(*CHAR) LEN(64)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(64)

             RTVNETA    SYSNAME(&SYS)
             RTVJOBA    JOB(&WSID)
             CHGVAR     VAR(&WT) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&SRCL) VALUE('HSRC1')
             CHGVAR     VAR(&WLIB) VALUE('HWFILE1')

             CHGVAR     VAR(&CHKWPU1) VALUE('CHKWPU1' *CAT &WT)
             CHGVAR     VAR(&CHKWPJ2) VALUE('CHKWPJ2' *CAT &WT)

             CHGVAR     VAR(&DOCD) VALUE(&SYS *CAT ':WRKACTJOB +
                          ERROR/CHKCJ5')
             CHGVAR     VAR(&MSG) VALUE(&SYS *CAT ':WRKACTJOB +
                          ERROR/CHKCJ5')

          /* WRKACTJOB -> CHKWPU1XXX */
             CALL       PGM(CHKCU0)

             DLTF       FILE(&WLIB/&CHKWPJ2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&CHKWPJ2) SRCFILE(&SRCL/ADDSSRC) +
                          SRCMBR(CHKWPJ2) OPTION(*NOLIST *NOSRC) +
                          SIZE(5000 1000) LVLCHK(*NO) AUT(*ALL)

          /* CHKWPU1XXX + CHKPP01 -> CHKWPJ2XXX */
             OVRDBF     FILE(CHKWPU1) TOFILE(&WLIB/&CHKWPU1)
             OVRDBF     FILE(CHKWPJ2) TOFILE(&WLIB/&CHKWPJ2)
             CALL       PGM(CHKRJ6) PARM(&ECNT)
             DLTOVR     FILE(*ALL)

             RTVMBRD    FILE(&CHKWPJ2) NBRCURRCD(&REC)
             IF         COND(&ECNT *EQ 0) THEN(DO)

             CHGVAR     VAR(&DOCD) VALUE(' ')
             CHGVAR     VAR(&MSG) VALUE(' ')
             CHGVAR     VAR(&DOCD) VALUE(&SYS *CAT ':WRKACTJOB +
                          OK/CHKCJ5')
             CHGVAR     VAR(&MSG) VALUE(&SYS *CAT ':WRKACTJOB +
                          OK/CHKCJ5')

          /* SNDDST     TYPE(*FILE) +
                          TOINTNET(('T-SAKASHITA@ASJ-FASTENERS.CO.JP'+
                          )) DSTD('DSTS') MSG(&MSG) +
                          DOCFILE(&CHKWPJ2) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD(&DOCD) */
          /* MONMSG     MSGID(CPF0000) */

             SNDDST     TYPE(*FILE) +
                          TOINTNET(('QSYSOPR@AOYAMAGRP.COM'+
                          )) DSTD('DSTS') MSG(&MSG) +
                          DOCFILE(&CHKWPJ2) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD(&DOCD)
             MONMSG     MSGID(CPF0000)

             GOTO       CMDLBL(@END)

             ENDDO

          /* SNDDST     TYPE(*FILE) +
                          TOINTNET(('T-SAKASHITA@ASJ-FASTENERS.CO.JP'+
                          )) DSTD('DSTS') MSG(&MSG) +
                          DOCFILE(&CHKWPJ2) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD(&DOCD) */
          /* MONMSG     MSGID(CPF0000) */

             SNDDST     TYPE(*FILE) +
                          TOINTNET(('QSYSOPR@AOYAMAGRP.COM') +
                          ('ERR_IAF_AS400_JOB@ASJ-FASTENERS.CO.JP')) +
                          DSTD('DSTS') MSG(&MSG) DOCFILE(&CHKWPJ2) +
                          DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD(&DOCD)
             MONMSG     MSGID(CPF0000)
@END:
             ENDPGM
