             PGM
             /** CHKCX0 **********************************/
             /* ..配布待ち行列状況ファイル..           */
             /*  KIRI 2015.04.24                         */
             /********************************************/

             DCL        VAR(&WSID)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT)      TYPE(*CHAR) LEN(3)
             DCL        VAR(&SLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CHKWPX0) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CHKWPX1) TYPE(*CHAR) LEN(10)


             RTVJOBA    JOB(&WSID)
             CHGVAR     VAR(&WT) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&SLIB) VALUE('HSRC1')
             CHGVAR     VAR(&WLIB) VALUE('HWFILE1')
             CHGVAR     VAR(&CHKWPX0) VALUE('CHKWPX0' *CAT &WT)
             CHGVAR     VAR(&CHKWPX1) VALUE('CHKWPX1' *CAT &WT)

             CHGJOB     OUTQ(QUSRSYS/CMDOUTQ)

             WRKDSTQ    OUTPUT(*PRINT)

             DLTF       FILE(&CHKWPX0)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&CHKWPX0) RCDLEN(256) IGCDTA(*YES)

             ADDRPYLE SEQNBR(4989) MSGID(CPA3312) RPY('G')

             CHGJOB INQMSGRPY(*SYSRPYL)

             CPYSPLF    FILE(QPDSTSTS) TOFILE(&WLIB/&CHKWPX0) +
                          SPLNBR(*LAST)

             CHGJOB INQMSGRPY(*RQD)

             RMVRPYLE   SEQNBR(4989)

             DLTF       FILE(&WLIB/&CHKWPX1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&CHKWPX1) SRCFILE(&SLIB/ADDSSRC) +
                          SRCMBR(CHKWPX1) OPTION(*NOLIST *NOSRC) +
                          SIZE(5000 1000) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(CHKWPX0) TOFILE(&WLIB/&CHKWPX0)
             OVRDBF     FILE(CHKWPX1) TOFILE(&WLIB/&CHKWPX1)
             CALL       PGM(CHKRX0)
             DLTOVR     FILE(*ALL)

             ENDPGM
