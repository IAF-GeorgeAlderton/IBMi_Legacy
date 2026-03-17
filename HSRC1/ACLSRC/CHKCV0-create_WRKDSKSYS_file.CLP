             PGM
             /** CHKCV0 **********************************/
             /* ..ディスク処理状況ファイル作成..       */
             /*  KIRI 2015.04.23                         */
             /********************************************/

             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&SLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CHKWPV0) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CHKWPV1) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID)
             CHGVAR     VAR(&WT) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&SLIB) VALUE('HSRC1')
             CHGVAR     VAR(&WLIB) VALUE('HWFILE1')

             CHGVAR     VAR(&CHKWPV0) VALUE('CHKWPV0' *CAT &WT)
             CHGVAR     VAR(&CHKWPV1) VALUE('CHKWPV1' *CAT &WT)

             CHGJOB     OUTQ(QUSRSYS/CMDOUTQ)

             WRKDSKSTS  OUTPUT(*PRINT)

             DLTF       FILE(&CHKWPV0)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&CHKWPV0) RCDLEN(256) IGCDTA(*YES)

             CPYSPLF    FILE(QPWCDSKS) TOFILE(&WLIB/&CHKWPV0) +
                          SPLNBR(*LAST)

             DLTF       FILE(&WLIB/&CHKWPV1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&CHKWPV1) SRCFILE(&SLIB/ADDSSRC) +
                          SRCMBR(CHKWPV1) OPTION(*NOLIST *NOSRC) +
                          SIZE(5000 1000) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(CHKWPV0) TOFILE(&WLIB/&CHKWPV0)
             OVRDBF     FILE(CHKWPV1) TOFILE(&WLIB/&CHKWPV1)
             CALL       PGM(CHKRV1)
             DLTOVR     FILE(*ALL)

             ENDPGM
