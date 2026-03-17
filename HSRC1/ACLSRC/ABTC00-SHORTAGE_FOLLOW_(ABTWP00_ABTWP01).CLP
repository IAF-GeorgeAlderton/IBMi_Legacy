             PGM
         /** ABTC00 **********************************************/
         /* S_MONITOR MAIN JOB                                   */
         /*    SAKAKI.          2019.10.31                       */
         /*                                                      */
         /*   ABTWP01 IS USED BY ABTC01 & 02  (MONITOR)          */
         /*   ABTWP21 IS USED BY ABTC21       (PC)               */
         /*                                                      */
         /********************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&OBJL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATTIMS) TYPE(*CHAR) LEN(20)
             DCL        VAR(&DAT14) TYPE(*CHAR) LEN(14)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)

        /*---------------------------*/
        /*  CHECK  ENVIRONMENT       */
        /*---------------------------*/
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)
        /*--------------------------------------------*/
        /*  CHANGE ENVIRONMENT IF TEST USER USES      */
        /*--------------------------------------------*/
             CALL       PGM(ALBC02) PARM(&USER &OBJL)

 STP10:
             DLTF       FILE(&WLIB/ABTWL00)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(&WLIB/ABTWP00)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/ABTWP00) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABTWP00) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 1500 3) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(ABTWP00) TOFILE(&WLIB/ABTWP00)

             CRTLF      FILE(&WLIB/ABTWL00) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABTWL00) OPTION(*NOLIST *NOSRC) +
                          LVLCHK(*NO) AUT(*ALL)

          /* ALDPL68 -> ABTWP00 */
             CALL       PGM(ABTR00)

             DLTF       FILE(&WLIB/ABTWL30)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(&WLIB/ABTWP30)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/ABTWP30) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABTWP30) OPTION(*NOLIST *NOSRC) +
                          SIZE(500000 1500 3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(ABTWP30) TOFILE(&WLIB/ABTWP30)

             CRTLF      FILE(&WLIB/ABTWL30) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABTWL30) OPTION(*NOLIST *NOSRC) +
                          LVLCHK(*NO) AUT(*ALL)

          /* AB#PP10 -> ABTWP30 */
             CALL       PGM(ABTR30)

 STP11:

             CRTDTAARA  DTAARA(&OBJL/ABTR00ACT) TYPE(*CHAR) LEN(14) +
                          TEXT('ABTR00 PROCESSING')
             MONMSG     MSGID(CPF0000)

             RTVMBRD    FILE(&WLIB/ABTWP00)  NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             CLRPFM     FILE(&WLIB/ABTWP01)
             ENDDO
             ELSE DO
             CPYF       FROMFILE(&WLIB/ABTWP00) +
                          TOFILE(&WLIB/ABTWP01) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF0000)
             ENDDO

             RTVMBRD    FILE(&WLIB/ABTWP30)  NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             CLRPFM     FILE(&WLIB/ABTWP31)
             ENDDO
             ELSE DO
             CPYF       FROMFILE(&WLIB/ABTWP30) +
                          TOFILE(&WLIB/ABTWP31) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF0000)
             ENDDO

             RTVSYSVAL  SYSVAL(QDATETIME) RTNVAR(&DATTIMS)
             CHGDTAARA  DTAARA(ABTR00TIM *ALL) VALUE(%SST(&DATTIMS 1 +
                          14))

             DLTDTAARA  DTAARA(&OBJL/ABTR00ACT)
             MONMSG     MSGID(CPF0000)

 STP20:
             DLTF       FILE(&WLIB/ABTWP20)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/ABTWP20) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABTWP20) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 1500 3) LVLCHK(*NO) AUT(*ALL)

 STP21:   /* ALDPL68 -> ABTWP20 */
             CALL       PGM(ABTR20)

 STP22:

             CRTDTAARA  DTAARA(&OBJL/ABTR20ACT) TYPE(*CHAR) LEN(14) +
                          TEXT('ABTR20 PROCESSING')
             MONMSG     MSGID(CPF0000)

             RTVMBRD    FILE(&WLIB/ABTWP20)  NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             CLRPFM     FILE(&WLIB/ABTWP21)
             ENDDO
             ELSE DO
             CPYF       FROMFILE(&WLIB/ABTWP20) +
                          TOFILE(&WLIB/ABTWP21) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF0000)
             ENDDO

             RTVSYSVAL  SYSVAL(QDATETIME) RTNVAR(&DATTIMS)
             CHGDTAARA  DTAARA(ABTR20TIM *ALL) VALUE(%SST(&DATTIMS 1 +
                          14))

             DLTDTAARA  DTAARA(&OBJL/ABTR20ACT)
             MONMSG     MSGID(CPF0000)

 STP30:
             CALL       PGM(AA#C10)
 STP90:
             DLYJOB     DLY(300)
             GOTO       CMDLBL(STP10)

 #END:       ENDPGM
