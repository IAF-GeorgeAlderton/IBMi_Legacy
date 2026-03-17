             /** AA#C10 **********************************************/
             /* ＯＱ特急品管理モニター：データ作成                 */
             /*    OSHIMA.        2021.04.21                         */
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
             DLTF       FILE(&WLIB/AA#WP11)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AA#WP11) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AA#WP11) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 1500 3) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AA#WP11) TOFILE(&WLIB/AA#WP11)
          /* AB#PP10 -> AA#WP11 */
             CALL       PGM(AA#R11)

             DLTF       FILE(&WLIB/AA#WP12)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AA#WP12) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AA#WP12) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 1500 3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AA#WP11) TOFILE(&WLIB/AA#WP11)
             OVRDBF     FILE(AA#WP12) TOFILE(&WLIB/AA#WP12)
             CALL       PGM(AA#R12)

             DLTF       FILE(&WLIB/AA#WP13)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AA#WP13) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AA#WP13) OPTION(*NOLIST *NOSRC) +
                          SIZE(50000 1500 3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AA#WP12) TOFILE(&WLIB/AA#WP12)
             OVRDBF     FILE(AA#WP13) TOFILE(&WLIB/AA#WP13)
             CALL       PGM(AA#R13)

 STP11:

             CRTDTAARA  DTAARA(&OBJL/AA#C10ACT) TYPE(*CHAR) LEN(14) +
                          TEXT('AA#C10 PROCESSING')
             MONMSG     MSGID(CPF0000)

             RTVMBRD    FILE(&WLIB/AA#WP13)  NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             CLRPFM     FILE(&WLIB/AA#WP14)
             ENDDO
             ELSE DO
             CPYF       FROMFILE(&WLIB/AA#WP13) +
                          TOFILE(&WLIB/AA#WP14) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF0000)
             ENDDO

             RTVSYSVAL  SYSVAL(QDATETIME) RTNVAR(&DATTIMS)
             CHGDTAARA  DTAARA(AA#C10TIM *ALL) VALUE(%SST(&DATTIMS 1 +
                          14))

             DLTDTAARA  DTAARA(&OBJL/AA#C10ACT)
             MONMSG     MSGID(CPF0000)

 STP90:

 #END:       ENDPGM
