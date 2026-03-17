             PGM
             /** AB#C8N ************************************/
             /*  EDI FIXED ORDER NOT ON SALES LIST         */
             /*  K.OKACHI  1998.03.12                      */
             /*                                            */
             /*  JW1    2021.05.03 ADD OUTPUT LIST TO CSV  */
             /**********************************************/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)

             DCL        VAR(&WS)     TYPE(*CHAR) LEN(2)
             DCL        VAR(&REC)    TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&FILE)   TYPE(*CHAR)  LEN(9)
             DCL        VAR(&FILE1)  TYPE(*CHAR)  LEN(9)
             DCL        VAR(&FILE2)  TYPE(*CHAR)  LEN(11)

    /*SEND MAIL SET */
             DCL        VAR(&TO1)    TYPE(*CHAR) LEN(50)
             DCL        VAR(&SUB)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&FNAME)  TYPE(*CHAR) LEN(30)

             DCL        VAR(&FROM)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&TO  )   TYPE(*CHAR) LEN(8)
             DCL        VAR(&KEN)    TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&FNAM)   TYPE(*CHAR) LEN(30)

             CHGVAR     VAR(&TO1)   VALUE('ATSUO.MAMIYA@IAFI.COM')
             CHGVAR     VAR(&SUB)   VALUE('SALES DATA')
             CHGVAR     VAR(&FNAME) VALUE('SALES-DATA.TXT')

             RTVJOBA    JOB(&WSID)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

        /**  CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))           **/
        /**  CHGVAR     VAR(&FILE)  VALUE('AB#WP80' *CAT &WS)     **/
        /**  CHGVAR     VAR(&FILE1) VALUE('AB#WP81' *CAT &WS)     **/
        /**  CHGVAR     VAR(&FILE2) VALUE('AB#WP8Z' *CAT &WS)     **/

             DLTF       FILE(QTEMP/AB#WP80)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP80) RCDLEN(128) +
                          OPTION(*NOLIST) SIZE(99999 3000) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AB#WP80) TOFILE(QTEMP/AB#WP80)
     /***    CALL       PGM(AB#R80)     ***/
             CALL       PGM(AB#R80N) PARM(&FROM &TO)

             CHGVAR     VAR(&REC) VALUE('0')
             RTVMBRD    FILE(QTEMP/AB#WP80) NBRCURRCD(&REC)
             IF         COND(&REC = 0) THEN(GOTO CMDLBL(END))

             DLTF       FILE(QTEMP/AB#WP81)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP81) RCDLEN(128) +
                          OPTION(*NOLIST) SIZE(99999 3000) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(QTEMP/AB#WP82)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTDUPOBJ  OBJ(AB#WP82) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             FMTDTA     INFILE((QTEMP/AB#WP80)) +
                          OUTFILE(QTEMP/AB#WP81) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S80) +
                          OPTION(*NOPRT)

        /**  OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +    **/
        /**               RPLUNPRT(*YES) OUTQ(LANPRT50) +        **/
        /**               FORMTYPE(K6H1) IGCDTA(&PIGCD)          **/

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(EPRINT1) +
                          FORMTYPE(K6H1) HOLD(*YES) IGCDTA(&PIGCD)

             OVRDBF     FILE(AB#WP81) TOFILE(QTEMP/AB#WP81)
             CALL       PGM(AB#R81)

             CALL       PGM(AB#R81N) PARM(&FROM &TO)

             RTVMBRD    FILE(QTEMP/AB#WP82) NBRCURRCD(&KEN)

             IF         (&KEN *GT 0) THEN(DO)
             CHGVAR     VAR(&FNAM) VALUE('UNPOSTED ORDER LIST')
             CALL       PGM(APLC94) PARM('2' 'AB#WP82' 'QTEMP' &FNAM +
                          'Y' ' ' 'Y')
             ENDDO

        /**  DLTF       FILE(&FILE1)    **/

             DLTF       FILE(QTEMP/AB#WP8Z)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP8Z) RCDLEN(128) +
                          OPTION(*NOLIST) SIZE(99999 3000) +
                          LVLCHK(*NO) AUT(*ALL)

 END:        DLTOVR     FILE(*ALL)

             ENDPGM
