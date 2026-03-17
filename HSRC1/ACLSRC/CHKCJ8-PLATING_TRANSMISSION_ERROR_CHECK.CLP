             PGM
             /** CHKCJ8 ***************************************/
             /*  PLATING TRANSMISSION ERROR CHECK (IAF)       */
             /*                                               */
             /*CREATED DATE  :2018.11.07                    */
             /*  AUTHOR      :Y.NAKANO                      */
             /*************************************** CHKCJ8 **/

             DCL        VAR(&SYS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SRCL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CHKWPJ8) TYPE(*CHAR) LEN(10)
             DCL        VAR(&REC)   TYPE(*DEC)  LEN(10 0) VALUE(0)
             DCL        VAR(&DOCD) TYPE(*CHAR) LEN(64)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(64)
             DCL        VAR(&POKNG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PSTS) TYPE(*CHAR) LEN(1) VALUE(' ')

             RTVNETA    SYSNAME(&SYS)
             RTVJOBA    JOB(&WSID)
             CHGVAR     VAR(&SRCL) VALUE('HSRC1')
             CHGVAR     VAR(&WLIB) VALUE('HWFILE1')
             CHGVAR     VAR(&MSG) VALUE(&SYS *CAT ':WRKACTJOB +
                          ERROR/CHKCJ8')
             CHGVAR     VAR(&CHKWPJ8) VALUE('CHKWPJ8' *CAT &WT)
             CHGVAR     VAR(&DOCD) VALUE(&SYS *CAT ':WRKACTJOB +
                          ERROR/CHKCJ8')

         /*  CALL       PGM(DATR30) PARM(&PSTS)  */
         /*  IF         COND(&PSTS *EQ '1') THEN(GOTO CMDLBL(@END)) */

             DLTF       FILE(&WLIB/&CHKWPJ8)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&CHKWPJ8) RCDLEN(60) +
                          OPTION(*NOLIST *NOSRC) SIZE(5000 1000) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(CHKRJ8) PARM(&POKNG)

             IF         COND(&POKNG *EQ '0') THEN(GOTO CMDLBL(@END))


             OVRDBF     FILE(CHKWPJ8) TOFILE(&CHKWPJ8)
             CALL       PGM(CHKRJ9)
             DLTOVR     FILE(*ALL)

          /* SNDDST     TYPE(*FILE) +
                          TOINTNET(('NAKANO.YUICHI@AOYAMAGRP.COM')+
                          ) DSTD('DSTS') MSG(&MSG) +
                          DOCFILE(&CHKWPJ8) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD(&DOCD) */

             SNDDST     TYPE(*FILE) +
                          TOINTNET(('ERR_KAIGAI_AS400_JOB@ASJ-FASTENE+
                          RS.CO.JP')) DSTD('DSTS') MSG(&MSG) +
                          DOCFILE(&CHKWPJ8) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD(&DOCD)

@END:
             ENDPGM
