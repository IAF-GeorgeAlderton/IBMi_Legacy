             PGM        PARM(&SIME &RERUN &PRTG &TYPE)
             /** BCECJ2 *******************************************/
             /* DELIVERY MONTHLY REPORT JOBQ-CL OP-EDP */
             /*           M-OKUDA           81.12.20              */
             /*                                                   */
             /* ADD PARAMETER TO MBDC11                           */
             /* TCHK1 04/07/06 CHG OUTQ                           */
             /******************************************* BCECJ2 **/
             DCL        VAR(&SIME) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RERUN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MCEDP01) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)

    /*SEND MAIL SET */
             DCL        VAR(&TO1)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&SUB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&FNAME)  TYPE(*CHAR) LEN(30)

             CHGVAR     VAR(&TO1) +
                          VALUE('SAMEJIMA.YUKI@AOYAMAGRP.COM')
             CHGVAR     VAR(&SUB) VALUE('SALES DATA')
             CHGVAR     VAR(&FNAME) VALUE('SALES-DATA.TXT')


             RTVJOBA    JOB(&WSID) USER(&US)

             CHGVAR     VAR(&MCEDP01) VALUE(&SIME)
             CHGDTAARA  DTAARA(MCEDP01) VALUE(&MCEDP01)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(ALBC00) PARM(&US &WLIB)
             CHGVAR     VAR(&WLIB2) VALUE(&WLIB)

             /* MONTHLY REPORT DATA PICK OUT ACCORDING TO THE PARM */
             DLTF       FILE(MCEWP21)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/MCEWP21) RCDLEN(100) +
                          TEXT('DELIVERY MONTHLY REPORT WORK1') +
                          OPTION(*NOLIST) SIZE(500000 10000 4) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(MCER21) PARM(&SIME &RERUN)

             /*         MONTHLY REPORT FILE CREATE < MBEPP01 > */
             DLTF       FILE(MCEWP22)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/MCEWP22) RCDLEN(100) +
                          TEXT('MONTHLY REPORT  WORK2') +
                          OPTION(*NOLIST) SIZE(500000 10000 4) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/MCEWP21)) +
                          OUTFILE(&WLIB/MCEWP22) SRCFILE(FMTSRC) +
                          SRCMBR(MCES22) OPTION(*NOPRT)

             CLRPFM     FILE(MBEPP01)

             /*         DELIVERY MONTHLY REPORT BY PART NUMBER LIST PRINT */
             CALL       PGM(MCER22) PARM(&SIME)

             /*         CZ SALES                                   */
       /*    CALL       PGM(ATBC01)    */
             DLTF       FILE(MCEWP22)

/* TCHK1 */  OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(MONTHLY) FORMTYPE(K6H1) +
                          COPIES(&TYPE) IGCDTA(&PIGCD)
             CALL       PGM(MCER23) PARM(&SIME)

             DLTF       FILE(BCEWPJ2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/BCEWPJ2) RCDLEN(132) +
                          OPTION(*NOLIST) SIZE(99999 10000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(APLC31) PARM('QPRINT     ' &WLIB2 +
                          'BCEWPJ2   ')

             CALL       PGM(APLC30) PARM(&TO1 &SUB &WLIB2 'BCEWPJ2   +
                          ' &FNAME)

     /*      CHGVAR     VAR(&TO1) +
                          VALUE('T-SAKAKI@ASJ-FASTENERS.CO.JP') */
     /*      CALL       PGM(APLC30) PARM(&TO1 &SUB &WLIB2 'BCEWPJ2   +
                          ' &FNAME)                            */

             DLTOVR     FILE(QPRINT)

             /*    MONTHLY REPORT PUBLICATION FINISHED INSTRUCTION WRITE BACK */
             CALL       PGM(MCER24) PARM(&SIME)
             DLTF       FILE(MCEWP21)

             /*        DELIVERY STATISTICS BY PART NUMBERFILE CREATE */
             CALL       PGM(MCER26) PARM(&SIME &RERUN)

             CALL       PGM(MBDC11) PARM(&RERUN &SIME)

             ENDPGM
