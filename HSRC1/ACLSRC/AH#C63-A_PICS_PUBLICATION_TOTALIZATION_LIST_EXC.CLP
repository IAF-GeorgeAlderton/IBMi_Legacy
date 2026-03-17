             PGM        PARM(&@BMON &@YY &@MM)
             /*** AH#C63 ***************************************/
             /* A-PICS PUBLICATION TOTALIZATION LIST EXCLUSIVE GOJYOGAWA */
             /*           H.ITO             1995.07.18         */
             /*************************************** AH#C63 ***/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PUS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&@BMON) TYPE(*CHAR) LEN(4)
             DCL        VAR(&@YY) TYPE(*CHAR) LEN(4)
             DCL        VAR(&@MM) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(9)
             RTVJOBA    JOB(&WSID) USER(&PUS)
             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&FILE1) VALUE('AH#WP63' *CAT &WS)
             CHGVAR     VAR(&FILE2) VALUE('AH#WP64' *CAT &WS)
             CHGJOB     RUNPTY(40) SWS(00000000)

             CALL       PGM(KZZR00) PARM(&WSID &PRT &TYPE &PRTG)

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE/&FILE1) RCDLEN(64) +
                        OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                        AUT(*ALL)

             OVRDBF     FILE(AH#WP63) TOFILE(&FILE1)
             CALL       PGM(AH#R63) PARM(&@BMON &@YY &@MM)

             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE/&FILE2) RCDLEN(64) +
                        OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO) +
                        AUT(*ALL)

             OVRDBF     FILE(AH#WP64) TOFILE(&FILE2)
             FMTDTA     INFILE((&FILE1)) OUTFILE(&FILE2) +
                        SRCFILE(FMTSRC) SRCMBR(AH#S63) +
                        OPTION(*NOPRT)
             DLTF       FILE(&FILE1)

             OVRPRTF    FILE(AH#PR64) PAGESIZE(66 132) LPI(6) CPI(10) +
                        OVRFLW(60) RPLUNPRT(*YES) OUTQ(&PRTG) +
                        FORMTYPE(K6H1) MAXRCDS(*NOMAX)
             CALL       PGM(AH#R64) PARM(&PUS)
             DLTF       FILE(&FILE2)
             DLTOVR     FILE(*ALL)

 @END:       CHGJOB     RUNPTY(20)

             ENDPGM
