         PGM
         /** MBDCT2 *****************************************/
         /* SALES DATA STATISTICS                           */
         /*         T.SAKASHITA         2007.07.18          */
         /************************************** MBDCTA *****/
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0) VALUE(0)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PIPGMN) TYPE(*CHAR) LEN(10) +
                          VALUE('MBDCT2    ')
             DCL        VAR(&POUSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POKONA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POSTTS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PMSG) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PKINP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PKOUT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SYS) TYPE(*CHAR) LEN(10)

    /*SEND MAIL SET */
             DCL        VAR(&TO1)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&SUB)  TYPE(*CHAR) LEN(30)
             DCL        VAR(&FNAME)  TYPE(*CHAR) LEN(30)

             RTVNETA    SYSNAME(&SYS)
 STP2:       RTVJOBA    JOB(&WS) USER(&US)

             CHGVAR     VAR(&TO1) VALUE('Kazuki.Kobayashi@IAFI.COM')
             CHGVAR     VAR(&SUB) VALUE('SALES DATA    ' *CAT &US)
             CHGVAR     VAR(&FNAME) VALUE('SALES-DATA.CSV')

 STP1:
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

             DLTF       FILE(HWFILE1/MBDWPT2)
             MONMSG     MSGID(CPF2103 CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/MBDWPT2) RCDLEN(2048) +
                          OPTION(*NOLIST) SIZE(70000 1000 9) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(MBDRT2) PARM(&TO1)

             MONMSG     MSGID(CPF2103 CPF3261 CPF2105)

             RTVMBRD    FILE(HWFILE1/MBDWPT2) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL(#END))

             CALL       PGM(APLC30) PARM(&TO1 &SUB 'HWFILE1' +
                          'MBDWPT2' &FNAME)

 #END:

 @END:       ENDPGM
