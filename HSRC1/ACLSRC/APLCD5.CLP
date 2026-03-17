  /*                                                                 */
  /*     プログラムテスター自動生成                                */
  /*                                                                 */
             PGM        PARM(&PGM &CRTPGM &TLIB &TPGM)
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(20)
             DCL        VAR(&PGMNAM)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGMLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&CRTPGM)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&TLIB)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&TPGM)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TPGMD)   TYPE(*CHAR) LEN(10)

             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(80)
             DCLF       FILE(*LIBL/QADSPOBJ)

             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL($ERR))

   /*  CHGVAR  */
             CHGVAR     VAR(&PGMNAM) VALUE(%SST(&PGM   1 10))
             CHGVAR     VAR(&PGMLIB) VALUE(%SST(&PGM  11 10))
   /*  SRCF-SCN */
             DSPOBJD    OBJ(&PGMLIB/&PGMNAM) OBJTYPE(*PGM) +
                          DETAIL(*SERVICE) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/QADSPOBJ)
             OVRDBF     FILE(QADSPOBJ) TOFILE(QTEMP/QADSPOBJ) +
                          LVLCHK(*NO)
             RCVF
             CHGVAR     VAR(&PGMLIB) VALUE(&ODLBNM)
   /*  ADDLIBLE  */
          /* ADDLIBLE   LIB(MSK) POSITION(*LAST) */
          /* MONMSG     MSGID(CPF0000)           */
             ADDLIBLE   LIB(&PGMLIB) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)
             IF         COND(&TLIB *EQ '*PGMLIB') THEN(DO)
             CHGVAR     VAR(&TLIB) VALUE(&PGMLIB)
             ENDDO
             ADDLIBLE   LIB(&TLIB) POSITION(*LAST)
             MONMSG     MSGID(CPF0000)
   /*  CHECK     */
             CHKOBJ     OBJ(&PGMLIB/&PGMNAM) OBJTYPE(*PGM)
             CHKOBJ     OBJ(QSYS/&TLIB) OBJTYPE(*LIB)
             IF         COND(&TPGM = 'S_PGM') THEN(DO)
             CHGVAR     VAR(&TPGM) VALUE('S' *TCAT &PGMNAM)
             ENDDO
             CHGVAR     VAR(&TPGMD ) VALUE(&TPGM *TCAT 'D')
             IF         COND(&CRTPGM *NE 'Y') THEN(DO)
             CHKOBJ     OBJ(&TLIB/&TPGM) OBJTYPE(*PGM)
             GOTO       CMDLBL($CALL)
             ENDDO
   /*  CREATE    */
             CRTSRCPF   FILE(&TLIB/TSTPGMSRC) IGCDTA(*YES)
             MONMSG     MSGID(CPF0000)
   /*  ADDMBR    */
             CHKOBJ     OBJ(&TLIB/TSTPGMSRC) OBJTYPE(*FILE) MBR(&TPGM)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CPYSRCF    FROMFILE(HSRC1/ARPGSRC) +
                          TOFILE(&TLIB/TSTPGMSRC) FROMMBR(APLRD6) +
                          TOMBR(&TPGM)
             MONMSG     MSGID(CPF0000)
             ENDDO

             CHKOBJ     OBJ(&TLIB/TSTPGMSRC) OBJTYPE(*FILE) MBR(&TPGMD)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             CPYSRCF    FROMFILE(HSRC1/ADSPSRC) +
                          TOFILE(&TLIB/TSTPGMSRC) FROMMBR(APLPWD6) +
                          TOMBR(&TPGMD)
             MONMSG     MSGID(CPF0000)
             ENDDO

             CLRPFM     FILE(&TLIB/TSTPGMSRC) MBR(&TPGM)
             CLRPFM     FILE(&TLIB/TSTPGMSRC) MBR(&TPGMD)

   /*  OVRDBF    */
             OVRDBF     FILE(QRPGSRC) TOFILE(&TLIB/TSTPGMSRC) +
                          MBR(&TPGM) LVLCHK(*NO)
             OVRDBF     FILE(QDDSSRC) TOFILE(&TLIB/TSTPGMSRC) +
                          MBR(&TPGMD) LVLCHK(*NO)
             OVRDBF     FILE(INPUT) TOFILE(&ODSRCL/&ODSRCF) +
                          MBR(&PGMNAM) LVLCHK(*NO)
             OVRDBF     FILE(INPSKTR) TOFILE(HSRC1/ARPGSRC) +
                          MBR(APLRD6) LVLCHK(*NO)
             OVRDBF     FILE(INPSKTD) TOFILE(HSRC1/ADSPSRC) +
                          MBR(APLPWD6) LVLCHK(*NO)
   /*  CRTSRC DSP&RPG */
             CALL       PGM(APLRD5) PARM(&PGMNAM &TLIB &TPGM +
                          &TPGMD)
             DLTOVR     FILE(*ALL)
   /*  CREATE DSPF OR PGM  */
             IF         COND(&CRTPGM = 'Y') THEN(DO)
             DLTF       FILE(&TLIB/&TPGMD)
             MONMSG     MSGID(CPF0000)
             DLTPGM     PGM(&TLIB/&TPGM)
             MONMSG     MSGID(CPF0000)
             CRTDSPF    FILE(&TLIB/&TPGMD) SRCFILE(&TLIB/TSTPGMSRC)
             CRTRPGPGM  PGM(&TLIB/&TPGM) SRCFILE(&TLIB/TSTPGMSRC)
             ENDDO
 $CALL:
             OVRDBF     FILE(&TPGMD) TOFILE(&TLIB/&TPGMD) LVLCHK(*NO)
             CALL       PGM(&TLIB/&TPGM)
             DLTOVR     FILE(*ALL)

  /* TERMINATE */
             RETURN

 $ERR:       RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSGDTA) MSGID(&MSGID)
             SNDPGMMSG  MSGID(&MSGID) MSGF(*LIBL/QCPFMSG) +
                          MSGDTA(&MSGDTA) MSGTYPE(*ESCAPE)
             ENDPGM
