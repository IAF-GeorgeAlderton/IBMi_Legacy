             PGM        PARM(&MSGQ &LIBL)

             DCL        VAR(&MSGQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBL) TYPE(*CHAR) LEN(10)

             DCL        VAR(&WLIBL) TYPE(*CHAR) LEN(10) +
                          VALUE('HWFILE1')

             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&CHKWPD0) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CHKWPD1) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID)
             CHGVAR     VAR(&WT) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&CHKWPD0) VALUE('CHKWPD0' *CAT &WT)
             CHGVAR     VAR(&CHKWPD1) VALUE('CHKWPD1' *CAT &WT)

             CHGJOB     OUTQ(WEEKDLT/CMDOUTQ)

             OVRPRTF    FILE(*PRTF) MAXRCDS(*NOMAX)
             DSPMSG     MSGQ(&LIBL/&MSGQ) OUTPUT(*PRINT)

             DLTF       FILE(&CHKWPD0)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIBL/&CHKWPD0) RCDLEN(256) +
                          IGCDTA(*YES) SIZE(900000 10000)

             CPYSPLF    FILE(QPDSPMSG) TOFILE(&WLIBL/&CHKWPD0) +
                          SPLNBR(*LAST)

             DLTF       FILE(&WLIBL/&CHKWPD1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIBL/&CHKWPD1) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(CHKWPD1) +
                          OPTION(*NOLIST *NOSRC) SIZE(900000) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(CHKWPD0) TOFILE(&WLIBL/&CHKWPD0)
             OVRDBF     FILE(CHKWPD1) TOFILE(&WLIBL/&CHKWPD1)
             CALL       PGM(CHKRD1)
             DLTOVR     FILE(*ALL)

             ENDPGM
