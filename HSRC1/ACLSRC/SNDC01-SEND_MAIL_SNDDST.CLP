             PGM   PARM(&FILE &USER &WSID &NBR &ADR1 &DSTD &DOCD &MSG &WDTH)
             /*= SNDC01 ====================================================*/
             /*  SEND MAIL                                                  */
             /*  J.WATANABE     2020.06.19                                  */
             /*  --------------                                             */
             /*  &FILE  (10A) PRINTER FILE (QPRINT...)                      */
             /*  &USER  (10A) USER ID                                       */
             /*  &WSID  (10A) WSID                                          */
             /*  &NBR   (06A) JOB#                                          */
             /*  &ADR1 (250A) MAIL ADDRESS                                  */
             /*  &DSTD  (50A) MAIL DESCRIPTION                              */
             /*  &DOCD  (50A) DOC. DESCRIPTION                              */
             /*  &MSG  (250A) MSG                                           */
             /*  &WDTH   (3A) REPORT WIDTH (132 OR 198)                     */
             /*=============================================================*/
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR ) TYPE(*CHAR) LEN(06)
             DCL        VAR(&ADR1) TYPE(*CHAR) LEN(250)
             DCL        VAR(&DSTD) TYPE(*CHAR) LEN(50)
             DCL        VAR(&DOCD) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSG ) TYPE(*CHAR) LEN(240)
             DCL        VAR(&WDTH) TYPE(*CHAR) LEN(03)

/* FOR 132 */
             IF         COND(&WDTH = '132') THEN(DO)
             CRTDUPOBJ  OBJ(PRT132 ) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/PRT132 )
             CPYSPLF    FILE(&FILE) TOFILE(QTEMP/PRT132 ) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(QTEMP/PRT132 )
             CALL       PGM(AB#RW0)

             SNDDST     TYPE(*FILE) TOINTNET((&ADR1)) DSTD(&DSTD) +
                          MSG(&MSG) DOCFILE(QTEMP/PRT132) +
                          DOCTYPE(*FFT) SNDFMT(*NOCHG) DOCD(&DOCD)
             DLTOVR     FILE(PRT132)
             GOTO       CMDLBL(ENDP)
             ENDDO

/* FOR 198 */
             IF         COND(&WDTH = '198') THEN(DO)
             CRTDUPOBJ  OBJ(PRT198 ) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/PRT198 )
             CPYSPLF    FILE(&FILE) TOFILE(QTEMP/PRT198 ) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT198) TOFILE(QTEMP/PRT198 )
             CALL       PGM(AB#RW1)

             SNDDST     TYPE(*FILE) TOINTNET((&ADR1)) DSTD(&DSTD) +
                          MSG(&MSG) DOCFILE(QTEMP/PRT198) +
                          DOCTYPE(*FFT) SNDFMT(*NOCHG) DOCD(&DOCD)
             DLTOVR     FILE(PRT198)
             GOTO       CMDLBL(ENDP)
             ENDDO

ENDP:
             ENDPGM
