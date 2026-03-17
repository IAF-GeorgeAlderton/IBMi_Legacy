             PGM
             /** MYCC94 ***********************************/
             /* PROCESS MASTER DOWNLOAD - (HORIZONTAL)    */
             /*  I-HASADA      2019/10/08                 */
             /* ----------------------------              */
             /*  JW1       2023.03.16 CHG JAPANESE TEXT   */
             /*********************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(3)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PMSG) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PKINP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PKOUT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FNAM) TYPE(*CHAR) LEN(30) +
                          VALUE('PROCESS MASTER')

             DCL        VAR(&PIPGMN) TYPE(*CHAR) LEN(10) +
                          VALUE('MYCC94    ')
             DCL        VAR(&POUSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POKONA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POSTTS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREC) TYPE(*DEC) LEN(3 0) VALUE(0)

             DCL        VAR(&MYCWP94) TYPE(*CHAR) LEN(10)

             DCL        VAR(&PARM1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PARM2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PARM3) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PARM4) TYPE(*CHAR) LEN(80)
             DCL        VAR(&PARM5) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PSYS) TYPE(*CHAR) LEN(10)

             CHGJOB     SWS(00000000)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&MYCWP94) VALUE('MYCWP94' *CAT &WS)

    /*--------------*/
    /*  PGM:MYCR94  */
    /*--------------*/
             DLTF       FILE(&MYCWP94)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/&MYCWP94) RCDLEN(1000) +
                          TEXT('PROCESS MASTER WF') OPTION(*NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(MYCWP94) TOFILE(&MYCWP94)
             CALL       PGM(MYCR94)
             DLTOVR     FILE(*ALL)

    /*----------------------*/
    /* EXCLUSIVE CONTROL    */
    /*----------------------*/
 STPZ:       CALL       PGM(AJGR01) PARM(&PIPGMN &POUSID &POKONA +
                          &POSTTS)

             IF         (&POSTTS *NE '1') DO
             CHGVAR     VAR(&PREC) VALUE(&PREC + 1)

    /*-----------------------------------*/
    /* EXCLUSIVE CONTROL(COUNT 12 TIMES) */
    /*-----------------------------------*/
             IF         (&PREC *GE 12) DO
             CHGVAR     VAR(&PREC) VALUE(0)
             CALL       PGM(AJGR02) PARM(&PIPGMN)
             ENDDO

             DLYJOB     DLY(10)
             GOTO       STPZ
             ENDDO

    /*==================================*/
    /*  &PARM1 =LIBRARY (10A)           */
    /*  &PARM2 =SOURCE FILE (10A)       */
    /*  &PARM3 =SYSTEM NAME (8A)        */
    /*  &PARM4 =CSV FILE NAME (80A)     */
    /*  &PARM5 =FILE TYPE               */
    /*          (1: ASCII TEXT, 6:NO CONVERSION, 9:BIFF4) */
    /*          (12:CSV, 14:TAB SEPARATION, 16:BIFF8    ) */
    /*==================================*/

    /*------------------*/
    /*  AS400 --> PC    */
    /*  PROCESS MASTER  */
    /*  FILE:MYCWP94    */
    /*------------------*/
             DLTF       FILE(MYCWP94)
             MONMSG     MSGID(CPF2105)
             CRTPF      FILE(HWFILE1/MYCWP94) RCDLEN(1000) +
                          TEXT('PROCESS MASTER WF') OPTION(*NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO) AUT(*ALL)

             CPYF       FROMFILE(&MYCWP94) TOFILE(MYCWP94) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             DLTF       FILE(&MYCWP94)

             RTVNETA    SYSNAME(&PSYS)
             CHGVAR     VAR(&PARM1) VALUE('HWFILE1   ')
             CHGVAR     VAR(&PARM2) VALUE('MYCWP94   ')
             CHGVAR     VAR(&PARM3) VALUE(&PSYS)
             CHGVAR     VAR(&PARM4) +
                          VALUE('C:$AS400$DATA$MYCWP94.CSV            -
                                           ')
             CHGVAR     VAR(&PARM5) VALUE('1')

             CALL       PGM(AJGC01) PARM(&PARM1 &PARM2 &PARM3 &PARM4 +
                          &PARM5)

             CALL       PGM(APLC94) PARM('1' &PARM2 &PARM1 +
                          &FNAM 'Y' ' ' 'Y')

    /*-----------------------*/
    /* EXCLUSIVE CONTROL END */
    /*-----------------------*/
             CALL       PGM(AJGR02) PARM(&PIPGMN)

 END:        ENDPGM
