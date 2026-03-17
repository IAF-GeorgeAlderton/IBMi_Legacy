             PGM
         /** ABTC20 **********************************************/
         /* SHORTAGE FOLLOW (ABTWP20 --> ABTWP21)                */
         /*    SAKAKI.          2019.12.04                       */
         /*                                                      */
         /*   ABTWP21 IS USED BY ABTC21                          */
         /*                                                      */
         /********************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&OBJL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DATTIMS) TYPE(*CHAR) LEN(20)
             DCL        VAR(&DAT14) TYPE(*CHAR) LEN(14)

        /*---------------------------*/
        /*  CHECK  ENVIRONMENT       */
        /*---------------------------*/
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)
        /*--------------------------------------------*/
        /*  CHANGE ENVIRONMENT IF TEST USER USES      */
        /*--------------------------------------------*/
             CALL       PGM(ALBC02) PARM(&USER &OBJL)

 STP00:
             DLTF       FILE(&WLIB/ABTWP20)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/ABTWP20) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABTWP20) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 1500 3) LVLCHK(*NO) AUT(*ALL)

 STP10:   /* ALDPL68 -> ABTWP20 */
             CALL       PGM(ABTR20)

 STP20:
             CRTDTAARA  DTAARA(&OBJL/ABTC20ACT) TYPE(*CHAR) LEN(14) +
                          TEXT('ABTC20 PROCESSING')
             MONMSG     MSGID(CPF0000)

             CPYF       FROMFILE(&WLIB/ABTWP20) +
                          TOFILE(&WLIB/ABTWP21) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF0000)

             RTVSYSVAL  SYSVAL(QDATETIME) RTNVAR(&DATTIMS)
             CHGDTAARA  DTAARA(ABTC20TIM *ALL) VALUE(%SST(&DATTIMS 1 +
                          14))

             DLTDTAARA  DTAARA(&OBJL/ABTC20ACT)
             MONMSG     MSGID(CPF0000)

 STP30:
             DLYJOB     DLY(300)
             GOTO       CMDLBL(STP00)

 #END:       ENDPGM
