             PGM
             /** CHKCJ4 ************************************************/
             /*  CHECK BATCH STATUS MSGW/LCKW (NEW)                    */
             /* -----------------------------------                    */
             /*  JW1   2025.03.06  ADD CHKCJ42                         */
             /**********************************************************/
             DCL        VAR(&SYS)     TYPE(*CHAR) LEN(8)
             DCL        VAR(&WSID)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT)      TYPE(*CHAR) LEN(3)
             DCL        VAR(&SRCL)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&CHKWPU1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CHKWPJ4) TYPE(*CHAR) LEN(10)
             DCL        VAR(&REC)     TYPE(*DEC)  LEN(10 0) VALUE(0)
             DCL        VAR(&DOCD)    TYPE(*CHAR) LEN(64)
             DCL        VAR(&MSG)     TYPE(*CHAR) LEN(64)

             RTVNETA    SYSNAME(&SYS)
             RTVJOBA    JOB(&WSID)
             CHGVAR     VAR(&WT) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&SRCL) VALUE('HSRC1')
             CHGVAR     VAR(&WLIB) VALUE('HWFILE1')

             CHGVAR     VAR(&CHKWPU1) VALUE('CHKWPU1' *CAT &WT)
             CHGVAR     VAR(&CHKWPJ4) VALUE('CHKWPJ4' *CAT &WT)

             CHGVAR     VAR(&DOCD) VALUE(&SYS *CAT ':WRKACTJOB +
                          ERROR/CHKCJ4')
             CHGVAR     VAR(&MSG) VALUE(&SYS *CAT ':WRKACTJOB +
                          ERROR/CHKCJ4')

          /* WRKACTJOB -> CHKWPU1XXX */
             CALL       PGM(CHKCU0)

             DLTF       FILE(&WLIB/&CHKWPJ4)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&CHKWPJ4) SRCFILE(&SRCL/ADDSSRC) +
                          SRCMBR(CHKWPJ4) OPTION(*NOLIST *NOSRC) +
                          SIZE(5000 1000) LVLCHK(*NO) AUT(*ALL)

          /* CHKWPU1XXX + CHKPP01 -> CHKWPJ4XXX */
             OVRDBF     FILE(CHKWPU1) TOFILE(&WLIB/&CHKWPU1)
             OVRDBF     FILE(CHKWPJ4) TOFILE(&WLIB/&CHKWPJ4)
             CALL       PGM(CHKRJ5)
             CALL       PGM(CHKRJ4)
             DLTOVR     FILE(*ALL)

             RTVMBRD    FILE(&CHKWPJ4) NBRCURRCD(&REC)
             IF         (&REC *NE 0) THEN(DO)
  /* ASJ-IT */
             SNDDST     TYPE(*FILE) +
                          TOINTNET(('err_iaf_as400_job@asj-fasteners.+
                          co.jp')) DSTD('DSTS') MSG(&MSG) +
                          DOCFILE(&CHKWPJ4) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD(&DOCD)
  /* IAF */
             SNDDST     TYPE(*FILE) +
                          TOINTNET(('AS400-System@iafi.com')) +
                          DSTD('DSTS') MSG(&MSG) DOCFILE(&CHKWPJ4) +
                          DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD(&DOCD)
              ENDDO

  /** JW1  **/
             CALL       PGM(CHKCJ42)

ENDP:
             ENDPGM
