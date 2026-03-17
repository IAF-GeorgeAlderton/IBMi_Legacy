             PGM        PARM(&RERUN &SIME)
             /** MBDC11********************************************/
             /* DELIVERY STATISTICS FILE CREATE  MAIN OP-DELIVERY OF PRODUCTS */
             /*            M-OKUDA        1981.10.02              */
             /*                                                   */
             /*    11/19/2004  CHANGE THE SAVE LIBRARY         */
             /*          TCH                                      */
             /*    15/08/04 T.SAKAKI CLRPFM TO DELETE  %0001      */
             /*    15/10/06 T.SAKAKI CPYF   TO WRITE   %0002      */
             /*  2018/09/05 JW       FIX MESSAGE                  */
             /******************************************* MBDC11 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RERUN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SWITCH) TYPE(*CHAR) LEN(8)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SIME) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SAVL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTYM) TYPE(*CHAR) LEN(6)

             CHGVAR     VAR(&DTYM) VALUE(%SUBSTRING(&SIME 1 6))
             CHGVAR VAR(&SAVL) VALUE('SAV' *CAT &DTYM)
             CHKOBJ     OBJ(&SAVL) OBJTYPE(*LIB)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTLIB     LIB(&SAVL)
             ENDDO

             RTVJOBA    JOB(&WSID) SWS(&SWITCH) USER(&US)

             CALL       PGM(ALBC00) PARM(&US &WLIB)

             CHKOBJ     OBJ(MBDPP01) OBJTYPE(*FILE)
             MONMSG     CPF9801 *N GOTO STEP3
             GOTO       STEP2

 STEP3:      SNDPGMMSG  MSG('( G.C ) MONTHEND BACKED UP TAPE < +
                          MBDPP01 > SET SALES STATISTICS FILE. +
                          (MBDC11)') TOMSGQ(QSYSOPR) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE = 'G') *OR (&KOTAE = '')) +
                          THEN(GOTO CMDLBL(STEP4))
             IF         COND((&KOTAE = 'C') *OR (&KOTAE = '')) +
                          THEN(RETURN)
             GOTO       STEP3

 STEP4:
             RSTOBJ     OBJ(MBDPP01) SAVLIB(&SAVL) DEV(TAP01) +
                          OBJTYPE(*FILE) VOL(IAF) ENDOPT(*UNLOAD) +
                          MBROPT(*ALL) RSTLIB(HFILE1)
      /*     RSTOBJ     OBJ(MBDPP01) SAVLIB(HFILE1) DEV(TAPE1) +
                          OBJTYPE(*FILE) VOL(IAF) ENDOPT(*UNLOAD) +
                          MBROPT(*ALL)      */

 STEP5:      SNDPGMMSG  MSG('( G ) MONTHEND BACKED UP TAPE < MBDPP01 +
                          > REMOVE SALES STATISTICS DATA.(MBDC11)') +
                          TOMSGQ(QSYSOPR) MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE = 'G') *OR (&KOTAE = '')) +
                          THEN(GOTO CMDLBL(STEP2))
             GOTO       STEP5

 STEP2:      DLTF       FILE(MBDWP11)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/MBDWP11) RCDLEN(98) +
                          TEXT('DELIVERY STATISTICS WORK') +
                          OPTION(*NOLIST) SIZE(999999 5000) +
                          LVLCHK(*NO) AUT(*ALL)
      /* %0002 ADD WORK FILE */
             DLTF       FILE(MBDWP01)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/MBDWP01) SRCFILE(HSRC1/ADDSSRC) +
                          TEXT('DELIVERY STATISTICS WORK2') +
                          OPTION(*NOLIST) SIZE(999999 5000) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(MBDR11) PARM(&RERUN)

      /* %0002 ADD WORK FILE */
             CPYF       FROMFILE(MBDWP11) TOFILE(MBDWP01) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)

      /* %0001  */
      /*     CLRPFM     FILE(MBDPP01)    */
             CALL       PGM(MBDR18)

      /* %0002 CPYF TO WRITE */
      /*  MBDWP01 -> MBDPP01 */
             CALL       PGM(MBDR20)
      /*     CPYF       FROMFILE(MBDWP11) TOFILE(MBDPP01) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)    */

             DLTF       FILE(MBDWP11)

             DLTF       FILE(MBDWP14)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/MBDWP14) RCDLEN(184) +
                          TEXT('DELIVERY STATISTICS WORK') +
                          OPTION(*NOLIST) SIZE(999999 5000) +
                          LVLCHK(*NO) AUT(*ALL)
      /* %0002 ADD WORK FILE */
             DLTF       FILE(MBDWP10)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/MBDWP10) SRCFILE(HSRC1/ADDSSRC) +
                          TEXT('DELIVERY STATISTICS WORK3') +
                          OPTION(*NOLIST) SIZE(999999 5000) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(MBDR14)

      /* %0002 ADD WORK FILE */
             CPYF       FROMFILE(MBDWP14) TOFILE(MBDWP10) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)

      /* %0001  */
       /*    CLRPFM     FILE(MBDPP11)  */
             CALL       PGM(MBDR19)

      /* %0002 CPYF TO WRITE */
      /*  MBDWP10 -> MBDPP11 */
             CALL       PGM(MBDR21)

      /*     CPYF       FROMFILE(MBDWP14) TOFILE(MBDPP11) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)   */
             DLTF       FILE(MBDWP14)


 STEP6:      SNDPGMMSG  MSG('( G.C )NEW DELIVERY STATISTICS FILE  < +
                          MBDPP01 > & PUT DELIVERY MONTHLY PEPORT +
                          BACKUP TAPE < MBEPP01 > SET BUCKED UP +
                          TAPE') TOMSGQ(QSYSOPR) MSGTYPE(*INQ) +
                          KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE = 'G') *OR (&KOTAE = '')) +
                          THEN(GOTO CMDLBL(STEP7))
             IF         COND((&KOTAE = 'C') *OR (&KOTAE = '')) +
                          THEN(RETURN)
             GOTO       STEP6

 STEP7:
             IF         COND(%SUBSTRING(&SIME 5 2) *EQ '01' *AND +
                          &RERUN *EQ '0') THEN(DO)
             INZTAP     DEV(TAP01) NEWVOL(IAF) CHECK(*NO) +
                          DENSITY(*ULTRIUM6)
             ENDDO

             IF         COND(&RERUN *EQ '1') THEN(DO)
             DLTF       FILE(&SAVL/MBDPP01)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(&SAVL/MBEPP01)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(&SAVL/MBEPP02)
             MONMSG     MSGID(CPF0000)
             ENDDO

             CPYF       FROMFILE(HFILE1/MBDPP01) +
                          TOFILE(&SAVL/MBDPP01) CRTFILE(*YES)
             CPYF       FROMFILE(HFILE1/MBEPP01) +
                          TOFILE(&SAVL/MBEPP01) CRTFILE(*YES)
             CPYF       FROMFILE(HFILE1/MBEPP02) +
                          TOFILE(&SAVL/MBEPP02) CRTFILE(*YES)
             SAVOBJ     OBJ(MBDPP01 MBEPP01 MBEPP02) LIB(&SAVL) +
                          DEV(TAP01) OBJTYPE(*FILE) VOL(IAF) +
                          ENDOPT(*UNLOAD)

         /*  INZTAP     DEV(TAPE1) NEWVOL(IAF) CHECK(*NO)  */
         /*  SAVOBJ     OBJ(MBDPP01 MBEPP01 MBEPP02) LIB(HFILE1) +
                          DEV(TAPE1) OBJTYPE(*FILE) VOL(IAF) +
                          ENDOPT(*UNLOAD) */

 STEP8:      SNDPGMMSG  MSG('( G ) SALES STATISTICS FILE +
                          <MBDPP01.MBEPP01.PP02> HAVE BEEN +
                          ADDED.(MBDC11)') TOMSGQ(QSYSOPR) +
                          MSGTYPE(*INQ) KEYVAR(&MBAN)
             RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +
                          MSG(&KOTAE)
             IF         COND((&KOTAE = 'G') *OR (&KOTAE = '')) +
                          THEN(GOTO CMDLBL(STEP9))
             GOTO       STEP8

 STEP9:      ENDPGM
