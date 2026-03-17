             PGM
             /** ATACMS ************************************/
             /* WORK VOTE AND PER DAY FILE CREATE        */
             /*                              86.11.12      */
             /*                  VER. 2.0 90.06.09 */
             /************************************ ATACMS **/
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&RPY)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&BUMN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&HYMD)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&CODE)   TYPE(*CHAR) LEN(5)
             DCL        VAR(&CORD)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&ANSY)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&IKMA)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&BIN)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&FIL3)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&FIL4)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&FIL5)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&ARA1)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&ARA2)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&BL1)    TYPE(*CHAR) LEN(3)
             DCL        VAR(&BL2)    TYPE(*CHAR) LEN(3)
             DCL        VAR(&CP)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&MINBAN) TYPE(*CHAR) LEN(2)
             DCL        VAR(&NOUHIN) TYPE(*CHAR) LEN(2)
          /*930622*/
             DCL        VAR(&CHKSW)  TYPE(*CHAR) LEN(1)
         /* * * * * * * * */
             RTVDTAARA  DTAARA(MINBAN) RTNVAR(&MINBAN)
             RTVDTAARA  DTAARA(NOUHIN) RTNVAR(&NOUHIN)
             RTVJOBA    JOB(&WSNO) USER(&USER)
             CHGJOB     RUNPTY(40)

             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)

 STEP02:     CHGJOB     OUTQ(&PRTG)

             /*------------------------------------------------------*/
             CHGVAR     VAR(&HYMD)    VALUE('00000000')
             CHGVAR     VAR(&BIN)     VALUE('00')
             CHGVAR     VAR(&ANSY)    VALUE(' ')
             CHGVAR     VAR(&IKMA)    VALUE(' ')
             CHGVAR     VAR(&BL1)     VALUE('   ')
             CHGVAR     VAR(&BL2)     VALUE('   ')

             CALL       PGM(ATARMS) PARM(&CODE &ANSY &HYMD &BIN +
                                    &IKMA   &BL1  &BL2)

             CHGVAR     VAR(&FIL3)   VALUE('ATW80' *CAT &CODE)
             CHGVAR     VAR(&FIL4)   VALUE('ATL80' *CAT &CODE)
             CHGVAR     VAR(&FIL5)   VALUE('ATW86' *CAT &CODE)

             IF         COND(&CODE *EQ '0111 ') THEN(DO)
             CHGVAR     VAR(&CORD) VALUE('I ')
             ENDDO

             CHGVAR     VAR(&ARA1)   VALUE(&MINBAN *CAT &CORD)

             /*-----------------------------------------------------*/
             IF         (&ANSY  *NE 'Y')  DO
             GOTO       CMDLBL(ENDMA)
             ENDDO

 STEP71:     CHGVAR     VAR(&CP) VALUE('1')

             OVRPRTF    FILE(ATAPRM2) DEV(PE) DEVTYPE(*AFPDS) +
                          PAGESIZE(66 88) LPI(6) OVRFLW(66) +
                          OUTQ(QPRINTA) FORMTYPE(D992) COPIES(&CP) +
                          LVLCHK(*NO)
             CALL       PGM(ATARM2) PARM(&HYMD &BIN &CODE &IKMA  +
                                     &BL1  &BL2)

 FILECRT:    CHKOBJ     OBJ(&FIL3) OBJTYPE(*FILE)
             MONMSG MSGID(CPF9801) EXEC(GOTO CMDLBL(STEP06)) /* +
                          APPLICABLE FILE NO EXIST */
             CLRPFM     FILE(&FIL3)
             GOTO       STEP07

 STEP06:     CRTPF      FILE(HFILE1/&FIL3) RCDLEN(250) LVLCHK(*NO) +
                          AUT(*ALL)

 STEP07:     CHKOBJ     OBJ(&FIL4) OBJTYPE(*FILE)
             MONMSG MSGID(CPF9801) EXEC(GOTO CMDLBL(STEP08)) /* +
                          APPLICABLE FILE NO EXIST */
             CLRPFM     FILE(&FIL4)
             GOTO       STEP09

 STEP08:     CRTPF      FILE(HFILE1/&FIL4) RCDLEN(250) LVLCHK(*NO) +
                          AUT(*ALL)

 STEP09:     CHKOBJ     OBJ(&FIL5) OBJTYPE(*FILE)
             MONMSG MSGID(CPF9801) EXEC(GOTO CMDLBL(STEP10)) /* +
                          APPLICABLE FILE NO EXIST */
             GOTO       STEP11

 STEP10:     CRTPF      FILE(HFILE1/&FIL5) RCDLEN(160) LVLCHK(*NO) +
                          AUT(*ALL)

 STEP11:     OVRDBF     FILE(ATAWP80) TOFILE(&FIL3) MBR(&FIL3) +
                        LVLCHK(*NO)
             OVRDBF     FILE(ATAWP86) TOFILE(&FIL5) MBR(&FIL5) +
                        LVLCHK(*NO)

             OVRPRTF    FILE(ATAPR95) DEVTYPE(*AFPDS) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(QPRINTA) FORMTYPE(K6H1)
             CALL       PGM(ATARM3) PARM(&USER &HYMD &BIN &CODE +
                          &IKMA &BL2)
             DLTOVR     FILE(ATAPR95)

             /*-----------------------------------------------------*/
             FMTDTA     INFILE((HFILE1/&FIL3)) OUTFILE(HFILE1/&FIL4) +
                          SRCFILE(FMTSRC) SRCMBR(ATAS81) OPTION(*NOPRT)

 @00:        OVRDBF     FILE(ATAWL80) TOFILE(&FIL4) MBR(&FIL4) +
                        LVLCHK(*NO)
             OVRPRTF    FILE(ATAPR85) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(66) OUTQ(QPRINTA) +
                          FORMTYPE(D992) LVLCHK(*NO)
             CALL       PGM(ATARM5) PARM(&CODE)

             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDUSRMSG  MSG('PGM (ATAR85) ERROR OUTBREAK +
                          ........ RETRY -- R . CANCEL -- C') +
                          VALUES('R' 'C') MSGTYPE(*INQ) +
                          TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF         COND((&RPY = 'R') *OR (&RPY = 'r')) +
                          THEN(GOTO CMDLBL(@00))
             RETURN
             ENDDO

 @01:        CLRPFM     FILE(&FIL4)
             FMTDTA     INFILE((HFILE1/&FIL3)) OUTFILE(HFILE1/&FIL4) +
                          SRCFILE(FMTSRC) SRCMBR(ATAS83) OPTION(*NOPRT)

             OVRDBF     FILE(ATAWL80) TOFILE(&FIL4) MBR(&FIL4) +
                        LVLCHK(*NO)
             OVRPRTF    FILE(ATAPR88) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(56) OUTQ(QPRINTA) +
                          FORMTYPE(D992) LVLCHK(*NO)
             CALL       PGM(ATARM8) PARM(&CODE)

             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDUSRMSG  MSG('PGM (ATAR88) ERROR OUTBREAK +
                          ........ RETRY -- R . CANCEL -- C') +
                          VALUES('R' 'C') MSGTYPE(*INQ) +
                          TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF         COND((&RPY = 'R') *EQ (&RPY = 'r')) +
                          THEN(GOTO CMDLBL(@01))
             RETURN
             ENDDO

             /*-----------------------------------------------------*/
 STEP73:     CLRPFM     FILE(&FIL4)
             FMTDTA     INFILE((HFILE1/&FIL3)) OUTFILE(HFILE1/&FIL4) +
                          SRCFILE(FMTSRC) SRCMBR(ATAS82) OPTION(*NOPRT)

             OVRDBF     FILE(ATAWL80) TOFILE(&FIL4) MBR(&FIL4) +
                        LVLCHK(*NO)
             OVRPRTF    FILE(ATAPR84) DEVTYPE(*AFPDS) PAGESIZE(21 +
                          132) LPI(6) OVRFLW(21) OUTQ(QPRINTA) +
                          FORMTYPE(D991) LVLCHK(*NO)
             CALL       PGM(ATAR84)

             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDUSRMSG  MSG('PGM (ATAR84) ERROR OUTBREAK +
                          ........ RETRY -- R . CANCEL -- C') +
                          VALUES('R' 'C') MSGTYPE(*INQ) +
                          TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF         COND((&RPY = 'R') *EQ (&RPY = 'r')) +
                          THEN(GOTO CMDLBL(STEP73))
             RETURN
             ENDDO

             /*-----------------------------------------------------*/

 STEP14:     CALL       PGM(ATAR86) PARM(&USER)

             CALL       PGM(ATAR87)
             CLRPFM     FILE(&FIL4)

 ENDMA:      DLTOVR     FILE(*ALL)
             IF         COND(&ANSY *NE 'D') THEN(DO)
             DLTDTAARA  DTAARA(&ARA1)
             MONMSG     MSGID(CPF2105)
             ENDDO

 END:        CHGJOB     OUTQ(&PRT) RUNPTY(20)

             ENDPGM
