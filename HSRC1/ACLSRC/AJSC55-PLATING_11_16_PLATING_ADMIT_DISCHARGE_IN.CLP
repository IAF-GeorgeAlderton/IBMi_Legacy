             PGM
             /** AJSC55 ************************************/
             /* PLATING 11-16 PLATING ADMIT /  DISCHARGE DATA BRING IN */
             /* C:N.HAYAKAWA                 90.06.18      */
             /**********************************************/
             DCLF       FILE(AJSPW55)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&SWITCH) TYPE(*CHAR) LEN(8)
             DCL        VAR(&US)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&JIFIL)  TYPE(*CHAR) LEN(8) VALUE('JI')
             DCL        VAR(&TOFIL)  TYPE(*CHAR) LEN(8) VALUE('TO')
             DCL        VAR(&IN99)   TYPE(*LGL)  LEN(1)
             RTVJOBA    JOB(&WSID) USER(&US) SWS(&SWITCH)

             CALL       PGM(AGAR00)  PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     RUNPTY(40)

             /* FA M/F SCREEN DATE FILE NAME RECEIPT */
 STEP1:      SNDRCVF  DEV(&WSID)      RCDFMT(AJSPW551)
             IF       (&IN01 *EQ '1') GOTO END

             CHGVAR   VAR(&IN99)   VALUE('0')
             IF       COND(&RUNHIZ *EQ '      ') THEN(CHGVAR +
                      VAR(&IN99)   VALUE('1'))
             IF       (&IN99 = '1') GOTO STEP1
             CHGVAR   VAR(%SST(&TOFIL 3 6)) VALUE(%SST(&RUNHIZ 3 6))
             CHGVAR   VAR(%SST(&JIFIL 3 6)) VALUE(%SST(&RUNHIZ 3 6))

             /*CREATE WORK FILE */
             /* ADMIT AJSWP55 */
             DLTF       FILE(HWFILE1/AJSWP55)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/AJSWP55) RCDLEN(95) TEXT('CHUBU +
                          RIKA PLATING ADMITED DATA') +
                          OPTION(*NOLIST) SIZE(5000 500 3) +
                          LVLCHK(*NO) AUT(*ALL)

             GRTOBJAUT  OBJ(AJSWP55) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

             /* DISCHARGE AJSWP56 */
             DLTF       FILE(HWFILE1/AJSWP56)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/AJSWP56) RCDLEN(95) TEXT('CHUBU +
                          RIKA PLATING DISCHARGE DATA') +
                          OPTION(*NOLIST) SIZE(5000 500 3) +
                          LVLCHK(*NO) AUT(*ALL)

             GRTOBJAUT  OBJ(AJSWP56) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

             /*VERTUAL DISKETTE MAKING */
             DLTF       FILE(HFILE1/AJSVD55)
             MONMSG     MSGID(CPF3261 CPF2105)

          /* CRTVDF     FILE(HFILE1/AJSVD55) MBR(AJSVD55) SIZE(1200) */

             GRTOBJAUT  OBJ(AJSVD55) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

             /*COPY TO WORK BY FSU*/
          /* ENTPCFSU   FILE(HFILE1/AJSVD55) */
             /*COPY ADMITTED DATA */
             /*11 */
          /* CPYFRMVD   FILE(HFILE1/AJSVD55) MBR(AJSVD55) +          */
          /*              S38FILE(HWFIL1E/AJSWP55) S38MBR(AJSWP55) + */
          /*              DKTF(&TOFIL) EXT(11) REP(N) ADD(N) +      */
          /*              RCDLEN(95) IGC(N)                         */
             MONMSG     MSGID(FSU0104) EXEC(SNDPGMMSG +
                          MSG('PLATING ADMITTED DATA OF 11 MACHINE ARE +
                          NOT COPIED.') TOMSGQ(&WSID) +
                          MSGTYPE(*INFO) KEYVAR(&MBAN))
             /*12 */
          /* CPYFRMVD   FILE(HFILE1/AJSVD55) MBR(AJSVD55) +          */
          /*              S38FILE(HWFILE1/AJSWP55) S38MBR(AJSWP55) + */
          /*              DKTF(&TOFIL) EXT(12) REP(N) ADD(N) +      */
          /*              RCDLEN(95) IGC(N)                         */
             MONMSG     MSGID(FSU0104) EXEC(SNDPGMMSG +
                          MSG('PLATING ADMITTED DATA OF 12 MACHINE ARE +
                          NOT COPIED.') TOMSGQ(&WSID) +
                          MSGTYPE(*INFO) KEYVAR(&MBAN))
             /*13 */
          /* CPYFRMVD   FILE(HFILE1/AJSVD55) MBR(AJSVD55) +          */
          /*              S38FILE(HWFILE1/AJSWP55) S38MBR(AJSWP55) + */
          /*              DKTF(&TOFIL) EXT(13) REP(N) ADD(N) +      */
          /*              RCDLEN(95) IGC(N)                         */
             MONMSG     MSGID(FSU0104) EXEC(SNDPGMMSG +
                          MSG('PLATING ADMITTED DATA OF 13 MACHINE ARE +
                          NOT COPIED.') TOMSGQ(&WSID) +
                          MSGTYPE(*INFO) KEYVAR(&MBAN))
             /*14 */
          /* CPYFRMVD   FILE(HFILE1/AJSVD55) MBR(AJSVD55) +          */
          /*              S38FILE(HWFILE1/AJSWP55) S38MBR(AJSWP55) + */
          /*              DKTF(&TOFIL) EXT(14) REP(N) ADD(N) +      */
          /*              RCDLEN(95) IGC(N)                         */
             MONMSG     MSGID(FSU0104) EXEC(SNDPGMMSG +
                          MSG('PLATING ADMITTED DATA OF 14 MACHINE ARE +
                          NOT COPIED.') TOMSGQ(&WSID) +
                          MSGTYPE(*INFO) KEYVAR(&MBAN))
             /*15 */
          /* CPYFRMVD   FILE(HFILE1/AJSVD55) MBR(AJSVD55) +          */
          /*              S38FILE(HWFILE1/AJSWP55) S38MBR(AJSWP55) + */
          /*              DKTF(&TOFIL) EXT(15) REP(N) ADD(N) +      */
          /*              RCDLEN(95) IGC(N)                         */
             MONMSG     MSGID(FSU0104) EXEC(SNDPGMMSG +
                          MSG('PLATING ADMITTED DATA OF 15 MACHINE ARE +
                          NOT COPIED.') TOMSGQ(&WSID) +
                          MSGTYPE(*INFO) KEYVAR(&MBAN))
             /*16 */
          /* CPYFRMVD   FILE(HFILE1/AJSVD55) MBR(AJSVD55) +          */
          /*              S38FILE(HWFILE1/AJSWP55) S38MBR(AJSWP55) + */
          /*              DKTF(&TOFIL) EXT(16) REP(N) ADD(N) +      */
          /*              RCDLEN(95) IGC(N)                         */
             MONMSG     MSGID(FSU0104) EXEC(SNDPGMMSG +
                          MSG('PLATING ADMITTED DATA OF 16 MACHINE ARE +
                          NOT COPIED.') TOMSGQ(&WSID) +
                          MSGTYPE(*INFO) KEYVAR(&MBAN))

             /* DISCHARGE DATA COPY */
             /*11 */
          /* CPYFRMVD   FILE(HFILE1/AJSVD55) MBR(AJSVD55) +          */
          /*              S38FILE(HWFILE1/AJSWP56) S38MBR(AJSWP56) + */
          /*              DKTF(&JIFIL) EXT(11) REP(N) ADD(N) +      */
          /*              RCDLEN(95) IGC(N)                         */
             MONMSG     MSGID(FSU0104) EXEC(SNDPGMMSG +
                          MSG('PLATING DISCHARGE DATA OF 11 MACHINE ARE +
                          NOT COPIED.') TOMSGQ(&WSID) +
                          MSGTYPE(*INFO) KEYVAR(&MBAN))
             /*12 */
          /* CPYFRMVD   FILE(HFILE1/AJSVD55) MBR(AJSVD55) +          */
          /*              S38FILE(HWFILE1/AJSWP56) S38MBR(AJSWP56) + */
          /*              DKTF(&JIFIL) EXT(12) REP(N) ADD(N) +      */
          /*              RCDLEN(95) IGC(N)                         */
             MONMSG     MSGID(FSU0104) EXEC(SNDPGMMSG +
                          MSG('PLATING DISCHARGE DATA OF 12 MACHINE ARE +
                          NOT COPIED.') TOMSGQ(&WSID) +
                          MSGTYPE(*INFO) KEYVAR(&MBAN))
             /*13 */
          /* CPYFRMVD   FILE(HFILE1/AJSVD55) MBR(AJSVD55) +          */
          /*              S38FILE(HWFILE1/AJSWP56) S38MBR(AJSWP56) + */
          /*              DKTF(&JIFIL) EXT(13) REP(N) ADD(N) +      */
          /*              RCDLEN(95) IGC(N)                         */
             MONMSG     MSGID(FSU0104) EXEC(SNDPGMMSG +
                          MSG('PLATING DISCHARGE DATA OF 13 MACHINE ARE +
                          NOT COPIED.') TOMSGQ(&WSID) +
                          MSGTYPE(*INFO) KEYVAR(&MBAN))
             /*14 */
          /* CPYFRMVD   FILE(HFILE1/AJSVD55) MBR(AJSVD55) +          */
          /*              S38FILE(HWFILE1/AJSWP56) S38MBR(AJSWP56) + */
          /*              DKTF(&JIFIL) EXT(14) REP(N) ADD(N) +      */
          /*              RCDLEN(95) IGC(N)                         */
             MONMSG     MSGID(FSU0104) EXEC(SNDPGMMSG +
                          MSG('PLATING DISCHARGE DATA OF 14 MACHINE ARE +
                          NOT COPIED.') TOMSGQ(&WSID) +
                          MSGTYPE(*INFO) KEYVAR(&MBAN))

             /*15 */
          /* CPYFRMVD   FILE(HFILE1/AJSVD55) MBR(AJSVD55) +          */
          /*              S38FILE(HWFILE1/AJSWP56) S38MBR(AJSWP56) + */
          /*              DKTF(&JIFIL) EXT(15) REP(N) ADD(N) +      */
          /*              RCDLEN(95) IGC(N)                         */
             MONMSG     MSGID(FSU0104) EXEC(SNDPGMMSG +
                          MSG('PLATING DISCHARGE DATA OF 15 MACHINE ARE +
                          NOT COPIED.') TOMSGQ(&WSID) +
                          MSGTYPE(*INFO) KEYVAR(&MBAN))

             /*16 */
          /* CPYFRMVD   FILE(HFILE1/AJSVD55) MBR(AJSVD55) +          */
          /*              S38FILE(HWFILE1/AJSWP56) S38MBR(AJSWP56) + */
          /*              DKTF(&JIFIL) EXT(16) REP(N) ADD(N) +      */
          /*              RCDLEN(95) IGC(N)                         */
             MONMSG     MSGID(FSU0104) EXEC(SNDPGMMSG +
                          MSG('PLATING DISCHARGE DATA OF 16 MACHINE ARE +
                          NOT COPIED.') TOMSGQ(&WSID) +
                          MSGTYPE(*INFO) KEYVAR(&MBAN))

             /* PRINTFILE CHANGE 90.11.30 */
          /* OVRPRTF QPRINT HOLD(*YES) */
          /* OVRPRTF QPRINT2 HOLD(*YES) */
             /*WORK ADDED TO THE ADMISSION RESULTS FILE */
             CALL AJSR55
             /* WORK ADDED TO THE DISCHARGE RESULTS FILE */
             CALL AJSR56
             /* PRINTFILE CHANGE CANCEL */
          /* DLTOVR QPRINT */
          /* DLTOVR QPRINT2 */
             /* * * * * * * * * * * * * * * * * * * * * */
             /* INSERTED PART THAT MSK MAKING */
             /* MAKING CHECK LIST */
             /* USING AJSR58 */
             /* * * * * * * * * * * * * * * * * * * * * */

             DLTF       FILE(HWFILE1/AJSWP57)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/AJSWP57) RCDLEN(95) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)
             FMTDTA     INFILE((HWFILE1/AJSWP56)) +
                          OUTFILE(HWFILE1/AJSWP57) +
                          SRCFILE(HFILE1/ASOURCE) SRCMBR(AJSS57) +
                          OPTION(*NOPRT)
             MONMSG  MSGID(FMT9001) EXEC(GOTO CMDLBL(ERR01))
             GOTO NOERR
 ERR01:      SNDPGMMSG  MSG('SORT ENDED ABNORMALITY')
             GOTO ENDMA

 NOERR:      OVRPRTF    FILE(QPRINT) DEVTYPE(*AFPDS) OUTQ(&PRTG)
             CALL       PGM(AJSR58)

             /* DELETE WORK FILE */
 ENDMA:      DLTF       FILE(HFILE1/AJSVD55)
             DLTF       FILE(HWFILE1/AJSWP55)
             DLTF       FILE(HWFILE1/AJSWP56)

 END:        CHGJOB     RUNPTY(20)

             ENDPGM
