             PGM
             /********************************************/
             /* TOOL KANBAN MAINTENANCE DATA CREATION    */
             /*   ITS.            2013.10.25             */
             /********************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&IAFSRC)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&IAFWFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&GCRWP21) TYPE(*CHAR) LEN(10)
             DCL        VAR(&GCRWP22) TYPE(*CHAR) LEN(10)
             DCL        VAR(&GCRWP23) TYPE(*CHAR) LEN(10)
             DCL        VAR(&GCRWP24) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3)      TYPE(*CHAR) LEN(3)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SYS) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&PARM1) TYPE(*CHAR) LEN(10) +
                          VALUE('AFSWFILE')
             DCL        VAR(&PARM2) TYPE(*CHAR) LEN(10) /* +
                          FILENAME */
             DCL        VAR(&PARM3) TYPE(*CHAR) LEN(8) /* HOST */
             DCL        VAR(&PARM4) TYPE(*CHAR) LEN(52) +
                          VALUE('C:$AS400$DATA$GCRWP23.CSV') +
                          /* PC FILE NAME */
             DCL        VAR(&PARM41) TYPE(*CHAR) LEN(52) +
                          VALUE('C:$AS400$DATA$GCRWP24.CSV') +
                          /* PC FILE NAME */
             DCL        VAR(&PARM5) TYPE(*CHAR) LEN(2) VALUE('1') +
                          /* FILE TYPE */
             RTVNETA    SYSNAME(&SYS)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&IAFSRC)   VALUE('HSRC1     ')
             CHGVAR     VAR(&IAFWFILE) VALUE('HWFILE1   ')

             CHGVAR     VAR(&WS3)   VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&GCRWP21) VALUE('GCRWP21' *CAT &WS3)
             CHGVAR     VAR(&GCRWP22) VALUE('GCRWP22' *CAT &WS3)
             CHGVAR     VAR(&GCRWP23) VALUE('GCRWP23' *CAT &WS3)
             CHGVAR     VAR(&GCRWP24) VALUE('GCRWP24' *CAT &WS3)

             CHGJOB     OUTQ(&PRTG)

 STP00:
             CALL       PGM(GCRR20) PARM(&PCMD)
             IF         COND(&PCMD *EQ '01') THEN(GOTO CMDLBL(#STP80))
 STP01:
             DLTF       FILE(&IAFWFILE/&GCRWP21)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&IAFWFILE/&GCRWP21) +
                          SRCFILE(&IAFSRC/ADDSSRC) SRCMBR(GCRWP21) +
                          OPTION(*NOLIST *NOSRC) SIZE(5000 5000 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(GCRWP21) TOFILE(&IAFWFILE/&GCRWP21)
             CALL       PGM(GCRR21)
         /*--------------*/
         /* DELETE DATA  */
         /*--------------*/
             CALL       PGM(GCRR25)
 STP02:
             DLTF       FILE(&IAFWFILE/&GCRWP22)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&IAFWFILE/&GCRWP22) +
                          SRCFILE(&IAFSRC/ADDSSRC) SRCMBR(GCRWP22) +
                          OPTION(*NOLIST *NOSRC) SIZE(5000 5000 +
                          3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(GCRWP21) TOFILE(&IAFWFILE/&GCRWP21)
             OVRDBF     FILE(GCRWP22) TOFILE(&IAFWFILE/&GCRWP22)
             CALL       PGM(GCRR22)

 STP03:
             DLTF       FILE(&IAFWFILE/&GCRWP23)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&IAFWFILE/&GCRWP23) RCDLEN(1024) +
                          OPTION(*NOLIST) SIZE(1000 5000) +
                          LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(GCRWP21) TOFILE(&IAFWFILE/&GCRWP21)
             OVRDBF     FILE(GCRWP23) TOFILE(&IAFWFILE/&GCRWP23)
             CALL       PGM(GCRR23)

 STP04:
             DLTF       FILE(&IAFWFILE/&GCRWP24)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&IAFWFILE/&GCRWP24) RCDLEN(1024) +
                          OPTION(*NOLIST) SIZE(1000 5000) +
                          LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(GCRWP22) TOFILE(&IAFWFILE/&GCRWP22)
             OVRDBF     FILE(GCRWP24) TOFILE(&IAFWFILE/&GCRWP24)
             CALL       PGM(GCRR24)

 STP05:
       /*品番別*/
             CHGVAR     VAR(&PARM2) VALUE(&GCRWP23)
             CHGVAR     VAR(&PARM3) VALUE(&SYS)
             CALL       PGM(APLC98) PARM(&PARM1 &PARM2 &PARM3 &PARM4 +
                          &PARM5)
 STP06:
       /*型番別*/
             CHGVAR     VAR(&PARM2) VALUE(&GCRWP24)
             CHGVAR     VAR(&PARM3) VALUE(&SYS)
             CALL       PGM(APLC98) PARM(&PARM1 &PARM2 &PARM3 &PARM41 +
                          &PARM5)
 #STP80:
             ENDPGM
