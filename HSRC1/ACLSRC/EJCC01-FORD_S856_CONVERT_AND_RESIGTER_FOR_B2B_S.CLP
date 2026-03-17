             PGM
             /** EJCC01 *************************************/
             /*  FORD S856 CONVERT AND RESIGTER FOR B2B_S   */
             /*    T.SAKAKI                   2016.11.29    */
             /*                                             */
             /* ******************************************* */
             /* * NEED TO REGISTER TO EJKPP10 IN ADVANCE  * */
             /* ******************************************* */
             /* JW1     2017.11.06 CHG JOBQ TO JOBQ7        */
             /*********************************** EJCC01 ****/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)    TYPE(*CHAR) LEN(3)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&JYKB) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DKB) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PTID) TYPE(*CHAR) LEN(12)
             DCL        VAR(&PIPGMN) TYPE(*CHAR) LEN(10)

             DCL        VAR(&FNAM)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&SFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SLIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ENDFLG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&EB#WP66) TYPE(*CHAR) LEN(10)

             DCL        VAR(&PGM)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGD)  TYPE(*CHAR) LEN(256)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 3))

        /* PROGRAM NAME */
             OVRPRTF QPPGMDMP QSYS/QDARCDSP
             DMPCLPGM
             MONMSG     MSGID(CPF0570) EXEC(DO)
             RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSGD)
             CHGVAR     VAR(&PGM) VALUE(%SST(&MSGD 1 10))
             ENDDO

        /* PROGRAM NAME */                /* EJCC01  */
             CHGVAR     VAR(&PIPGMN) VALUE(&PGM)

        /*--------------------------------------------*/
        /*    CHECK ENVIRONMENT                       */
        /*--------------------------------------------*/
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

        /*----------------*/
        /* SET PARAMETERS */
        /*----------------*/
   /*** NEED TO REGISTER TO EJKPP10 IN ADVANCE ***/
             CALL       PGM(EJKR12) PARM(&PIPGMN &JYKB &DKB &PTID)
                             /* 'EJCC01' -> 'FD' '856' 'FORD' */

        /* CREATE DUPULICATE CHECK FILE */
             CHGVAR     VAR(&NFILE) VALUE('EJCWPNB' *CAT &WS)
             DLTF       FILE(&WLIB/&NFILE)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&NFILE) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(EJCWPNB) OPTION(*NOLIST *NOSRC) +
                          SIZE(9999 1000 3) LVLCHK(*NO) AUT(*ALL)

        /* CREATE FORD ASN 856 CHECK FILE */

             CHGVAR     VAR(&EB#WP66) VALUE('EB#WP66' *CAT &WS)

             DLTF       FILE(&WLIB/&EB#WP66)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&EB#WP66) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(EB#WP66) OPTION(*NOLIST *NOSRC) +
                          SIZE(9999 1000 3) LVLCHK(*NO) AUT(*ALL)


             CHGVAR     VAR(&SLIBL) VALUE(&WLIB)
             CHGVAR     VAR(&SFILE) VALUE('EJCWP01' *CAT &WS)

 @STP1: /* CREATE RECEPTION FILE */

             DLTF       FILE(&SLIBL/&SFILE)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&SLIBL/&SFILE) RCDLEN(165) +
                          OPTION(*NOLIST *NOSRC) SIZE(100000 1000 +
                          3) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(OUTPUT) TOFILE(&SLIBL/&SFILE)
             OVRDBF     FILE(EJCWPNB) TOFILE(&WLIB/&NFILE)
             OVRDBF     FILE(EB#WP66) TOFILE(&WLIB/&EB#WP66)

        /* CONVERSION  */
        /* EB#EP66 -> OUTPUT ( -> EB#EP66S(PROCESSED)) */
        /* EB#EP63 -> OUTPUT ( -> EB#EP63S(PROCESSED)) */
        /* EB#EP64 -> OUTPUT ( -> EB#EP64S(PROCESSED)) */
        /* EB#EP65 -> OUTPUT ( -> EB#EP65S(PROCESSED)) */
             CALL       PGM(EJCR01) PARM(&PTID &FNAM &ENDFLG)


        /*-----------------------------------------------*/
        /* REGISTER RECEPTION FILE FOR FORD ASN FILE     */
        /*    &SFILE/&SLIBL --> S888XX0000 -->  EJKPP40  */
        /*-----------------------------------------------*/
             CALL       PGM(EJKC47) PARM(&JYKB &DKB &SFILE &SLIBL &FNAM)

     /* ALL DONE ? */
             IF         COND(&ENDFLG *EQ ' ') THEN(GOTO CMDLBL(@STP1))


     /* CHG JOBQ6 TO JOBQ7 (JW1)                                   */
             SBMJOB     CMD(CALL PGM(EJKC40)) JOB(B2B_FORD) +
                          JOBD(QBATCH) JOBQ(JOBQ7) USER(B2BUSER) +
                          RTGDTA(*JOBD) INLLIBL(*JOBD) LOG(4 00 +
                          *SECLVL) LOGCLPGM(*YES)

     /* CHG JOBQ6 TO JOBQ7 (JW1)                                      */
             SBMJOB     CMD(CALL PGM(EB#C0S) PARM(&EB#WP66 &WLIB)) +
                          JOB(EB#C0S) JOBD(QBATCH) JOBQ(JOBQ7) +
                          USER(B2BUSER) RTGDTA(*JOBD) +
                          INLLIBL(*JOBD) LOG(4 00 *SECLVL) +
                          LOGCLPGM(*YES)

@END:
             DLTOVR     FILE(*ALL)

  /* FOR PRODUCTION */
             IF         COND(&USER *NE 'TEST') THEN(DO)
      /* SEQUENTIAL # CONTROL FILE */
             CPYF       FROMFILE(&WLIB/&NFILE) +
                          TOFILE(WEEKDLT/EJCWPNB) MBROPT(*ADD) +
                          CRTFILE(*YES) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)
             CHGPF      FILE(WEEKDLT/EJCWPNB) SIZE(1000000)
             MONMSG     MSGID(CPF0000)
      /* SAVE FOR TEST */
             CPYF       FROMFILE(EB#EP63S) +
                          TOFILE(WEEKDLT/EB#EP63S) MBROPT(*ADD) +
                          CRTFILE(*YES) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)
             CHGPF      FILE(WEEKDLT/EB#EP63S) SIZE(1000000)
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(EB#EP64S) +
                          TOFILE(WEEKDLT/EB#EP64S) MBROPT(*ADD) +
                          CRTFILE(*YES) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)
             CHGPF      FILE(WEEKDLT/EB#EP64S) SIZE(1000000)
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(EB#EP65S) +
                          TOFILE(WEEKDLT/EB#EP65S) MBROPT(*ADD) +
                          CRTFILE(*YES) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)
             CHGPF      FILE(WEEKDLT/EB#EP65S) SIZE(1000000)
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(EB#EP66S) +
                          TOFILE(WEEKDLT/EB#EP66S) MBROPT(*ADD) +
                          CRTFILE(*YES) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)
             CHGPF      FILE(WEEKDLT/EB#EP66S) SIZE(1000000)
             MONMSG     MSGID(CPF0000)

             ENDDO

  /* FOR TEST */
             IF         COND(&USER *EQ 'TEST') THEN(DO)
      /* SEQUENTIAL # CONTROL FILE */
             CPYF       FROMFILE(&WLIB/&NFILE) +
                          TOFILE(WEEKDLT/EJCWPNBT) MBROPT(*ADD) +
                          CRTFILE(*YES) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)
             CHGPF      FILE(WEEKDLT/EJCWPNBT) SIZE(1000000)
             MONMSG     MSGID(CPF0000)
             ENDDO

             CLRPFM     FILE(EB#EP63)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(EB#EP64)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(EB#EP65)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(EB#EP66)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(EB#EP63S)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(EB#EP64S)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(EB#EP65S)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(EB#EP66S)
             MONMSG     MSGID(CPF0000)

             ENDPGM
