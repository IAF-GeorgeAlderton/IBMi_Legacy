             PGM
             /*** AH#CY0 *************************************/
             /*   CREATE A-PICS DATA OF NO SCAN              */
             /*    2017.12.01   Y.MAEDA                      */
             /*    2017.12.06   J.WATANABE (JW1) ADD AH#CY3  */
             /*    2019.01.15   J.WATANABE (JW2) ADD AH#CY4  */
             /************************************* AH#CY0 ***/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PSHN1) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PSHN2) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PSHN3) TYPE(*CHAR) LEN(2)
             DCL        VAR(&STOR1) TYPE(*CHAR) LEN(2)
             DCL        VAR(&STOR2) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SHKHZ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&EHKHZ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PSTS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&AH#WPY0) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AH#WPY1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRINT)   TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSNO) USER(&USER)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGVAR     VAR(&WS3) VALUE(%SST(&WSNO 1 3))
             CHGVAR     VAR(&AH#WPY0) VALUE('AH#WPY0' *CAT &WS3)
             CHGVAR     VAR(&AH#WPY1) VALUE('AH#WPY1' *CAT &WS3)
 @DSP1:
     /* JW2  CALL       PGM(AH#RY2) PARM(&PSHN1 &PSHN2 &PSHN3 &SHKHZ +  */
     /*                   &EHKHZ &PSTS)                                 */
             CALL       PGM(AH#RY1) PARM(&PSHN1 &PSHN2 &PSHN3 &SHKHZ +
                          &EHKHZ &PSTS &PRINT)

             IF         COND(&PSTS *EQ '1') THEN(GOTO CMDLBL(@END))

             DLTF       FILE(&WLIB/&AH#WPY0)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AH#WPY0) RCDLEN(1024) +
                          OPTION(*NOLIST *NOSRC) SIZE(5000000 30000) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&WLIB/&AH#WPY1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AH#WPY1) RCDLEN(1024) +
                          OPTION(*NOLIST *NOSRC) SIZE(100000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             CHGVAR     VAR(&STOR1) VALUE(' ')
             CHGVAR     VAR(&STOR2) VALUE(' ')

             OVRDBF     FILE(AH#WPY0) TOFILE(&WLIB/&AH#WPY0)
             OVRDBF     FILE(AH#WPY1) TOFILE(&WLIB/&AH#WPY1)
             CALL       PGM(AH#RY2) PARM(&PSHN1 &PSHN2 &PSHN3 &STOR1 +
                          &STOR2 &SHKHZ &EHKHZ)

             CALL       PGM(AH#RY3)

 /* JW1 INQUIRY */
             IF         COND(&PRINT *EQ ' ') THEN(DO)
             DLTOVR     FILE(AH#WPY1)
             CALL       PGM(AH#CY4) PARM(&WLIB &AH#WPY1)
             GOTO       CMDLBL(@DSP1)
             ENDDO

 /* JW2 PRINT   */
             IF         COND(&PRINT *NE ' ') THEN(DO)
             DLTOVR     FILE(AH#WPY1)
             OVRPRTF    FILE(QPRINT) OUTQ(&PRINT)
             CALL       PGM(AH#CY5) PARM(&WLIB &AH#WPY1)
          /* CPYF */
          /* CPYF       FROMFILE(AH#WPY1) TOFILE(AH#WPY2) +   */
          /*              MBROPT(*ADD) FMTOPT(*NOCHK)         */
             CALL       PGM(AH#RY6)
             GOTO       @END
             ENDDO

 @END:       DLTOVR     FILE(*ALL)
             ENDPGM
