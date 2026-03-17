             PGM
             /** AB#C2C ***********************************************/
             /*  ..PRINT AGAI LABEL              .                    */
             /*                                                       */
             /*     TCH 2001.01.01                                    */
             /*     TCH 2001.01.22 ADD TMMK                           */
             /*     TCH 2001.02.20 ADD SERVICE PART                   */
             /*     TCH 2001.03.13 ADD ARVIN SANGO                    */
             /*     TCH 2001.03.20 ADD GENERAL FASTNERS,HOLLINGSWORTH */
             /*     TCH 2002.03.20 ADD MASTER LABEL FILE              */
             /*     TCH 2002.06.03 ADD MASTER LABEL FILE              */
             /*     TCH 2003.06.23 SORT TOYOTA DATA                   */
             /*     TCH 2003.09.03 ADD DMAX 2D DATA                   */
             /*     TCH 2004.12.20 ADD DTR                            */
             /*   TCHK1 2005.12.21 ADD TMI(3540) & AMI(0987)          */
             /*   TCHK2 2006.04.11 ADD OHASHI,etc Mixed Pallet        */
             /*   TCHK3 2007.01.02 ADD TAKATA Mixed Pallet            */
             /*   TCHK4 2007.11.21 ADD KHMCA MANIFEST/SKID LABEL      */
             /*   TCHK5 2008.01.24 ADD TTC ORDER#='J?????' PROCESS    */
             /*                                   'X?????'            */
             /*   TCHK6 2012.12.14 ADD ACZ                            */
             /*   TCHK7 2014.07.27 ADD FIELD TO AB#WP2I               */
             /*   JW1   2016.02.15 ADD HITACHI(5810) PROCESS          */
             /*   JW2   2017.07.28 ADD AB#WP2IE FOR TEMA              */
             /*   JW3   2020.05.28 ADD SAVE AB#WP2I TO AB#WP2IZ       */
             /*   JW4   2020.11.01 ADD AB#C2C9 (TTAI)                 */
             /*   JW4   2021.04.01 REMOVE AB#C2C9 (TTAI)              */
             /*   JW5   2023.01.16 ADD AB#C2C3D FOR ADJ OTICS PALLET# */
             /***************************** AB#C2C ********************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WKSID)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&SRVF)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WKSID) VALUE(%SUBSTRING(&WSID 1 3))
             CHGVAR     VAR(&SRVF) VALUE(' ')

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CHKOBJ     OBJ(AB#WP2L) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2L) +
                          MBR(&WKSID))

             CHKOBJ     OBJ(AB#WP2H) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2H) +
                          MBR(&WKSID))

             CHKOBJ     OBJ(AB#WP2K) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2K) +
                          MBR(&WKSID))

             CHKOBJ     OBJ(AB#WP2M) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2M) +
                          MBR(&WKSID))

             CHKOBJ     OBJ(AB#WP2I) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2I) +
                          MBR(&WKSID))

             CHKOBJ     OBJ(AB#WP2N) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2N) +
                          MBR(&WKSID))

             CHKOBJ     OBJ(AB#WP2P) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2P) +
                          MBR(&WKSID))

             CHKOBJ     OBJ(AB#WP2T) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2T) +
                          MBR(&WKSID))

             CHKOBJ     OBJ(AB#WP2J) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2J) +
                          MBR(&WKSID))
             CHKOBJ     OBJ(AB#WP2JN) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2JN) +
                          MBR(&WKSID))
             CHKOBJ     OBJ(AB#WP2Z) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2Z) +
                          MBR(&WKSID))

             CHKOBJ     OBJ(AB#WP2O) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2O) +
                          MBR(&WKSID))

             CHKOBJ     OBJ(AB#WP2G) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2G) +
                          MBR(&WKSID))

             CHKOBJ     OBJ(AB#WP2E) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2E) +
                          MBR(&WKSID))

             CHKOBJ     OBJ(AB#WP2F) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2F) +
                          MBR(&WKSID))

             CHKOBJ     OBJ(AB#WP2IA) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2IA) +
                          MBR(&WKSID))
             CHKOBJ     OBJ(AB#WP2OA) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2OA) +
                          MBR(&WKSID))
             CHKOBJ     OBJ(AB#WP2Y) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2Y) +
                          MBR(&WKSID))
             CHKOBJ     OBJ(AB#WP2ID) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2ID) +
                          MBR(&WKSID))

             CHKOBJ     OBJ(AB#WP43) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP43) +
                          MBR(&WKSID))

/* TCHK1 */  CHKOBJ     OBJ(AB#WP2IB) OBJTYPE(*FILE) MBR(&WKSID)
/* TCHK1 */  MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2IB) +
/* TCHK1 */               MBR(&WKSID))
/* TCHK1 */  CHKOBJ     OBJ(AB#WP2IC) OBJTYPE(*FILE) MBR(&WKSID)
/* TCHK1 */  MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2IC) +
/* TCHK1 */               MBR(&WKSID))

/* TCHK5 */  CHKOBJ     OBJ(AB#WP2IQ) OBJTYPE(*FILE) MBR(&WKSID)
/* TCHK5 */  MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2IQ) +
/* TCHK5 */               MBR(&WKSID))
/* TCHK5 */  CHKOBJ     OBJ(AB#WP2IR) OBJTYPE(*FILE) MBR(&WKSID)
/* TCHK5 */  MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2IR) +
/* TCHK5 */               MBR(&WKSID))

/* JW1   */  CHKOBJ     OBJ(AB#WP2IH) OBJTYPE(*FILE) MBR(&WKSID)
/* JW1   */  MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2IH) +
/* JW1   */               MBR(&WKSID))

/* JW2   */  CHKOBJ     OBJ(AB#WP2IE) OBJTYPE(*FILE) MBR(&WKSID)
/* JW2   */  MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2IE) +
/* JW2   */               MBR(&WKSID))

             CHKOBJ     OBJ(AB#WPGF) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WPGF) +
                          MBR(&WKSID))

             CHKOBJ     OBJ(AB#WPFF) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WPFF) +
                          MBR(&WKSID))

             CLRPFM     FILE(AB#WP2L) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2H) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2K) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2M) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2I) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2N) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2P) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2T) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2J) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2JN) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2Z) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2O) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2G) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2E) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2F) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2IA) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2OA) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2Y) MBR(&WKSID)
             CLRPFM     FILE(AB#WP2ID) MBR(&WKSID)
             CLRPFM     FILE(AB#WP43) MBR(&WKSID)
/* TCHK1 */  CLRPFM     FILE(AB#WP2IB) MBR(&WKSID)
/* TCHK1 */  CLRPFM     FILE(AB#WP2IC) MBR(&WKSID)
/* TCHK5 */  CLRPFM     FILE(AB#WP2IQ) MBR(&WKSID)
/* TCHK5 */  CLRPFM     FILE(AB#WP2IR) MBR(&WKSID)

/* JW1   */  CLRPFM     FILE(AB#WP2IH) MBR(&WKSID)
/* JW2   */  CLRPFM     FILE(AB#WP2IE) MBR(&WKSID)

             CLRPFM     FILE(AB#WPGF) MBR(&WKSID)
             CLRPFM     FILE(AB#WPFF) MBR(&WKSID)

             OVRDBF     FILE(AB#WP2L) TOFILE(AB#WP2L) MBR(&WKSID)
             OVRDBF     FILE(AB#WP2H) TOFILE(AB#WP2H) MBR(&WKSID)
             OVRDBF     FILE(AB#WP2K) TOFILE(AB#WP2K) MBR(&WKSID)
             OVRDBF     FILE(AB#WP2M) TOFILE(AB#WP2M) MBR(&WKSID)
             OVRDBF     FILE(AB#WP2I) TOFILE(AB#WP2I) MBR(&WKSID)
             OVRDBF     FILE(AB#WP2N) TOFILE(AB#WP2N) MBR(&WKSID)
             OVRDBF     FILE(AB#WP2P) TOFILE(AB#WP2P) MBR(&WKSID)
             OVRDBF     FILE(AB#WP2T) TOFILE(AB#WP2T) MBR(&WKSID)
             OVRDBF     FILE(AB#WP2J) TOFILE(AB#WP2J) MBR(&WKSID)
             OVRDBF     FILE(AB#WP2JN) TOFILE(AB#WP2JN) MBR(&WKSID)
             OVRDBF     FILE(AB#WP2Z) TOFILE(AB#WP2Z) MBR(&WKSID)
             OVRDBF     FILE(AB#WP2O) TOFILE(AB#WP2O) MBR(&WKSID)
             OVRDBF     FILE(AB#WP2G) TOFILE(AB#WP2G) MBR(&WKSID)
             OVRDBF     FILE(AB#WP2E) TOFILE(AB#WP2E) MBR(&WKSID)
             OVRDBF     FILE(AB#WP2F) TOFILE(AB#WP2F) MBR(&WKSID)
             OVRDBF     FILE(AB#WP2IA) TOFILE(AB#WP2IA) MBR(&WKSID)
             OVRDBF     FILE(AB#WP2OA) TOFILE(AB#WP2OA) MBR(&WKSID)
             OVRDBF     FILE(AB#WP2Y) TOFILE(AB#WP2Y) MBR(&WKSID)
             OVRDBF     FILE(AB#WP2ID) TOFILE(AB#WP2ID) MBR(&WKSID)
             OVRDBF     FILE(AB#WP43) TOFILE(AB#WP43) MBR(&WKSID)
/* TCHK1 */  OVRDBF     FILE(AB#WP2IB) TOFILE(AB#WP2IB) MBR(&WKSID)
/* TCHK1 */  OVRDBF     FILE(AB#WP2IC) TOFILE(AB#WP2IC) MBR(&WKSID)
/* TCHK5 */  OVRDBF     FILE(AB#WP2IQ) TOFILE(AB#WP2IQ) MBR(&WKSID)
/* TCHK5 */  OVRDBF     FILE(AB#WP2IR) TOFILE(AB#WP2IR) MBR(&WKSID)

/* JW1   */  OVRDBF     FILE(AB#WP2IH) TOFILE(AB#WP2IH) MBR(&WKSID)
/* JW2   */  OVRDBF     FILE(AB#WP2IE) TOFILE(AB#WP2IE) MBR(&WKSID)

             CALL       PGM(AB#R2C) PARM(&USER &SRVF)

/*JW4 ADJUST AB#WP2O FOR TTAI(3556) */
         /*JW4 REMOVE CALL PGM(AB#R2C9)  ***/

/*JW3 SAVE AB#WP2I --> AB#WP2IZ */
             CALL       PGM(ESVR01)
/*JW3 SAVE AB#WP2O --> AB#WP2OZ */
             CALL       PGM(ESVR02)

   /* AMBRAKE */
         /*  IF         (&SRVF *EQ 'A') DO                          */
         /*                                                         */
         /*  DLTF       FILE(QTEMP/WFILEA)                          */
         /*  MONMSG     MSGID(CPF3261 CPF2105)                      */
         /*  CRTPF      FILE(QTEMP/WFILEA) RCDLEN(211) +            */
         /*               OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)     */
         /*                                                         */
         /*  FMTDTA     INFILE((AB#WP2I &WKSID)) +                  */
         /*               OUTFILE(QTEMP/WFILEA) +                   */
         /*               SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S3C) +    */
         /*               OPTION(*NOPRT)                            */
         /*                                                         */
         /*  CLRPFM     FILE(AB#WP2I) MBR(&WKSID)                   */
         /*  CPYF       FROMFILE(QTEMP/WFILEA) TOFILE(AB#WP2I) +    */
         /*               TOMBR(&WKSID) MBROPT(*ADD) FMTOPT(*NOCHK) */
         /*                                                         */
         /*  ENDDO                                                  */
   /* TOYOTA  */
             IF         (&SRVF *EQ 'T') DO

             RTVMBRD    FILE(AB#WP2I) MBR(&WKSID) NBRCURRCD(&REC)

             IF         (&REC *GT 0) THEN(DO)
             DLTF       FILE(QTEMP/WFILEB)
             MONMSG     MSGID(CPF3261 CPF2105)
/* TCHK7     CRTPF      FILE(QTEMP/WFILEB) RCDLEN(241) + */
/* TCHK7 */  CRTPF      FILE(QTEMP/WFILEB) RCDLEN(413) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((AB#WP2I &WKSID)) +
                          OUTFILE(QTEMP/WFILEB) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S3D) +
                          OPTION(*NOPRT)

             CLRPFM     FILE(AB#WP2I) MBR(&WKSID)
             CPYF       FROMFILE(QTEMP/WFILEB) TOFILE(AB#WP2I) +
                          TOMBR(&WKSID) MBROPT(*ADD) FMTOPT(*NOCHK)

/* TCHK5 */  CALL       PGM(AB#R2C5)

             ENDDO
             RTVMBRD    FILE(AB#WP2N) MBR(&WKSID) NBRCURRCD(&REC)

             IF         (&REC *GT 0) THEN(DO)
             DLTF       FILE(QTEMP/WFILEC)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/WFILEC) RCDLEN(229) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((AB#WP2N &WKSID)) +
                          OUTFILE(QTEMP/WFILEC) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S3E) +
                          OPTION(*NOPRT)

             CLRPFM     FILE(AB#WP2N) MBR(&WKSID)
             CPYF       FROMFILE(QTEMP/WFILEC) TOFILE(AB#WP2N) +
                          TOMBR(&WKSID) MBROPT(*ADD) FMTOPT(*NOCHK)

             ENDDO
             ENDDO
 /* TMMC */
             IF         (&SRVF *EQ 'C') DO

             RTVMBRD    FILE(AB#WP2I) MBR(&WKSID) NBRCURRCD(&REC)

             IF         (&REC *GT 0) THEN(DO)
             DLTF       FILE(QTEMP/WFILEB)
             MONMSG     MSGID(CPF3261 CPF2105)
/* TCHK7     CRTPF      FILE(QTEMP/WFILEB) RCDLEN(241) + */
/* TCHK7 */  CRTPF      FILE(QTEMP/WFILEB) RCDLEN(413) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((AB#WP2I &WKSID)) +
                          OUTFILE(QTEMP/WFILEB) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S3F) +
                          OPTION(*NOPRT)

             CLRPFM     FILE(AB#WP2I) MBR(&WKSID)
             CPYF       FROMFILE(QTEMP/WFILEB) TOFILE(AB#WP2I) +
                          TOMBR(&WKSID) MBROPT(*ADD) FMTOPT(*NOCHK)

             ENDDO
             RTVMBRD    FILE(AB#WP2N) MBR(&WKSID) NBRCURRCD(&REC)

             IF         (&REC *GT 0) THEN(DO)
             DLTF       FILE(QTEMP/WFILEC)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/WFILEC) RCDLEN(229) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((AB#WP2N &WKSID)) +
                          OUTFILE(QTEMP/WFILEC) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S3G) +
                          OPTION(*NOPRT)

             CLRPFM     FILE(AB#WP2N) MBR(&WKSID)
             CPYF       FROMFILE(QTEMP/WFILEC) TOFILE(AB#WP2N) +
                          TOMBR(&WKSID) MBROPT(*ADD) FMTOPT(*NOCHK)

             ENDDO
             ENDDO

/* TCHK2 S */
   /* NIFAST,ETC */
             IF         (&SRVF *EQ 'M') DO

             DLTF       FILE(QTEMP/AB#WP2IM)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(QTEMP/AB#WP2IN)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTDUPOBJ  OBJ(AB#WP2IM) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/AB#WP2IM)
             CPYF       FROMFILE(AB#WP2I)        +
                          TOFILE(QTEMP/AB#WP2IM) +
                          FROMMBR(&WKSID)        +
                          MBROPT(*ADD) FMTOPT(*NOCHK)

             CRTDUPOBJ  OBJ(AB#WP2IN) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/AB#WP2IN)

             OVRDBF     FILE(AB#WP2IM) TOFILE(QTEMP/AB#WP2IM)
             OVRDBF     FILE(AB#WP2IN) TOFILE(QTEMP/AB#WP2IN)

             CALL       PGM(AB#R2C1)

             CLRPFM     FILE(AB#WP2I) MBR(&WKSID)
             CPYF       FROMFILE(QTEMP/AB#WP2IN) TOFILE(AB#WP2I) +
                          TOMBR(&WKSID) MBROPT(*ADD) FMTOPT(*NOCHK)

             ENDDO
/* TCHK2 E */
/* TCHK3 S */
   /* TAKATA(2D) */
             IF         (&SRVF *EQ 'K') DO

/*  LEC --  New Takata container label sort....                   */

  /* process label wf --- sort sequence   create ab#wpff          */
             CALL       PGM(AB#R2T2)

             RTVMBRD    FILE(AB#WPFF) MBR(&WKSID) NBRCURRCD(&REC)

             IF         (&REC *GT 0) THEN(DO)

  /*  clear original workfile...                                 */
             CLRPFM     FILE(AB#WP2F) MBR(&WKSID)

  /*  copy location sequence workfile into original workfile...  */
             CPYF       FROMFILE(AB#WPFF) TOFILE(AB#WP2F) +
                           FROMMBR(&WKSID) TOMBR(&WKSID) +
                           MBROPT(*ADD) FMTOPT(*MAP *DROP)

             ENDDO

  /*  assign pallet# to container labels...                      */
             CALL       PGM(AB#R2C3B)

             ENDDO
/* TCHK3 E */

 /********************************************************************/
 /* OHASHI     */
             IF         (&SRVF *EQ 'O') DO

/*  LEC --  New Ohashi container label sort....                   */

  /* process label wf --- sort sequence   create ab#wpff          */
             CALL       PGM(AB#R2O2)

             RTVMBRD    FILE(AB#WPCF) MBR(&WKSID) NBRCURRCD(&REC)

             IF         (&REC *GT 0) THEN(DO)

  /*  clear original workfile...                                 */
             CLRPFM     FILE(AB#WP2I) MBR(&WKSID)

  /*  copy location sequence workfile into original workfile...  */
             CPYF       FROMFILE(AB#WPCF) TOFILE(AB#WP2I) +
                           FROMMBR(&WKSID) TOMBR(&WKSID) +
                           MBROPT(*ADD) FMTOPT(*MAP *DROP)

             ENDDO

  /*  assign pallet# to container labels...                      */
             CALL       PGM(AB#R2C3C)

             ENDDO

 /********************************************************************/
/* TCHK4 S */
   /* KHMCA */
             IF         (&SRVF *EQ 'H') DO

             DLTF       FILE(QTEMP/AB#WP2IP)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTDUPOBJ  OBJ(AB#WP2IP) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/AB#WP2IP)
             CPYF       FROMFILE(AB#WP2I)        +
                          TOFILE(QTEMP/AB#WP2IP) +
                          FROMMBR(&WKSID)        +
                          MBROPT(*ADD) FMTOPT(*NOCHK)

             OVRDBF     FILE(AB#WP2IP) TOFILE(QTEMP/AB#WP2IP)

             CALL       PGM(AB#R2C4)

             ENDDO
/* TCHK4 E */
/* TCHK6 S */
   /* ACZ   */
             IF         (&SRVF *EQ 'Z') DO

             DLTF       FILE(QTEMP/AB#WP2IS)
             MONMSG     MSGID(CPF3261 CPF2105)

             DLTF       FILE(QTEMP/AB#WP2IS)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTDUPOBJ  OBJ(AB#WP2IS) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/AB#WP2IS)

             CRTDUPOBJ  OBJ(AB#WP2IT) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/AB#WP2IT)

             CPYF       FROMFILE(AB#WP2I)        +
                          TOFILE(QTEMP/AB#WP2IS) +
                          FROMMBR(&WKSID)        +
                          MBROPT(*ADD) FMTOPT(*NOCHK)

             OVRDBF     FILE(AB#WP2IS) TOFILE(QTEMP/AB#WP2IS)
             OVRDBF     FILE(AB#WP2IT) TOFILE(QTEMP/AB#WP2IT)

             CALL       PGM(AB#R2C6)

             CLRPFM     FILE(AB#WP2I) MBR(&WKSID)

             CALL       PGM(AB#R2C7)

             ENDDO
/* TCHK4 E */

/*  IF SUBARU*/
             IF         (&SRVF *EQ 'B') DO

 /*  assign pallet#, total pallets */
             CALL       PGM(RTVR01)

             RTVMBRD    FILE(AB#WP2L) MBR(&WKSID) NBRCURRCD(&REC)

             IF         (&REC *GT 0) THEN(DO)
             DLTF       FILE(QTEMP/AB#WP2LXX)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTPF      FILE(QTEMP/AB#WP2LXX) RCDLEN(171) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((AB#WP2L &WKSID)) +
                          OUTFILE(QTEMP/AB#WP2LXX) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S3S) +
                          OPTION(*NOPRT)

             CLRPFM     FILE(AB#WP2L) MBR(&WKSID)

             CPYF       FROMFILE(QTEMP/AB#WP2LXX) TOFILE(AB#WP2L) +
                          TOMBR(&WKSID) MBROPT(*ADD) FMTOPT(*NOCHK)

 /*  create workfile for subaru skid manifest    */
             CALL       PGM(RCRR01)

             ENDDO
             ENDDO

/*  IF AWNC  */
             IF         (&SRVF *EQ 'W') DO

 /* process label wf --- sort sequence   create ab#wpgf          */
             CALL       PGM(AB#R2A2)

             RTVMBRD    FILE(AB#WPGF) MBR(&WKSID) NBRCURRCD(&REC)

             IF         (&REC *GT 0) THEN(DO)

  /*  clear original workfile...                                 */
             CLRPFM     FILE(AB#WP2G) MBR(&WKSID)

  /*  copy location sequence workfile into original workfile...  */
             CPYF       FROMFILE(AB#WPGF) TOFILE(AB#WP2G) +
                           FROMMBR(&WKSID) TOMBR(&WKSID) +
                           MBROPT(*ADD) FMTOPT(*MAP *DROP)

             ENDDO
             ENDDO

  /*JW5  assign pallet# to container labels (OTICS)                 */
             CALL       PGM(AB#C2C3D)

  /* send label workfiles to SQL01 via RDB for current workstation  */
             CALL       PGM(RDBC2C) PARM(&WKSID)

  END:
             ENDPGM
