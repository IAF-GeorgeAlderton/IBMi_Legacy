             PGM        PARM(&TYPE &FILE &LIBL &FNAM &CSV &CLN  &MSG &STMF)
   /*= APLC94 =============================================================*/
   /*  DATA TRANSFER CSV DATA TO IFS FOR CSV FORMAT WF                     */
   /*  SAME WITH APLC93, EXCEPT ADDCOLNAM(*NONE )                          */
   /*  OUTPUT TO &STMF                                                     */
   /*  J.WATANABE     2025.10.27                                           */
   /*  --------------                                                      */
   /*  PARAMETERS                                                          */
   /*  1. &TYPE(1A) = 1, ONE FIELD IN RECORD OR TEXT DATA                  */
   /*               = 2, PF (ORDINALY PF, NO COMMA SEPARATOR)              */
   /*  2. &FILE(10A)= PF NAME TO BE TRANNSFERED TO IFS                     */
   /*  3. &LIBL(10A)= PF LIBRARY NAME FOR &FILE                            */
   /*  4. &FNAM(30A)= FILE NAME OF IFS (.CSV)                              */
   /*  5. &CSV(1A)  = Y OR C, EXTENTION CODE WILL BE .CSV                  */
   /*                 T, EXTENTION CODE WILL BE .TXT                       */
   /*             NOT Y/T/C, WITH NO EXTENTION CODE (MAMIYA SAN'S REQUEST) */
   /*  6. &CLN (1A) = Y, CSV WITH FIELD NAME                               */
   /*             NOT Y, CSV W/O  FIELD NAME                               */
   /*  7. &MSG (1A) = Y, DSPLAY BREAK MSG                                  */
   /*             NOT Y, DO NOT DISPLAY BREAK MSG                          */
   /*  8. &STMF (100) = STREAM ADDRESS FOR OUTPUT                         */
   /*               EX. '/QNTC/IAF-AS400-FILE/AS400-TRANS/DOWNLOAD/I0777"  */
   /*  ---NOTE---                                                          */
   /*  IF &TYPE=1 ....... USE "HWFILE1/FILE1024" (PF) (FIXED LENGTH 1024A  */
   /*  IF &FILE='ABMWP*'. OUTPUT TO J:/Download/AUTO SETTING/YYYY_MM       */
   /*  IF &FILE='GDLWP*'. OUTPUT TO K:/Download/AS400/OUTSRC               */
   /*======================================================================*/

             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBL)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FNAM)  TYPE(*CHAR) LEN(30)
             DCL        VAR(&CSV )  TYPE(*CHAR) LEN(1)
             DCL        VAR(&CLN )  TYPE(*CHAR) LEN(1)
             DCL        VAR(&COL )  TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSG )  TYPE(*CHAR) LEN(1)
             DCL        VAR(&STMF)  TYPE(*CHAR) LEN(100)

             DCL        VAR(&DIR1)  TYPE(*CHAR) LEN(100)
             DCL        VAR(&DIR2)  TYPE(*CHAR) LEN(110)
             DCL        VAR(&DIR3)  TYPE(*CHAR) LEN(100)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS  )  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WFIL)  TYPE(*CHAR) LEN(60)
             DCL        VAR(&TEXT ) TYPE(*CHAR) LEN(100)
 RUN:
             RTVJOBA    JOB(&WS  ) USER(&USER)

             IF  COND(&CLN *EQ 'Y') THEN(CHGVAR VAR(&COL) VALUE('*SYS'))
             IF  COND(&CLN *NE 'Y') THEN(CHGVAR VAR(&COL) VALUE('*NONE'))

      /* SET FILE1 NAME */
             IF         COND((&CSV *EQ 'Y') *OR (&CSV *EQ 'C')) +
                          THEN(DO)
             CHGVAR     VAR(&WFIL) VALUE(&FNAM *TCAT '.csv')
             ENDDO

             IF         COND(&CSV *EQ 'T') THEN(DO)
             CHGVAR     VAR(&WFIL) VALUE(&FNAM *TCAT '.txt')
             ENDDO

             IF         COND((&CSV *NE 'Y') *AND (&CSV *NE 'T') *AND +
                          (&CSV *NE 'C')) THEN(DO)
             CHGVAR     VAR(&WFIL) VALUE(&FNAM)
             ENDDO

             CHGVAR     VAR(&DIR1) VALUE(&STMF)
             CRTDIR     DIR(&DIR1)
             MONMSG     MSGID(CPFA0A0)
             MONMSG     MSGID(CPFA0A9)
             CHGVAR     VAR(&DIR2) VALUE(&DIR1 *TCAT '/' *TCAT &WFIL)

      /* COPY DUMMY 0 RECORD */
             CRTDUPOBJ  OBJ(MBDWPT0) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(QTEMP/MBDWPT0)
             MONMSG     MSGID(CPF2103 CPF3261 CPF2105)

             CPYTOIMPF  FROMFILE(QTEMP/MBDWPT0) TOSTMF(&DIR2) +
                          MBROPT(*REPLACE) RCDDLM(*CRLF) +
                          RMVBLANK(*BOTH) FLDDLM(',') DATFMT(*USA) +
                          TIMFMT(*USA)
      /* ERROR MSG    */
             MONMSG     MSGID(CPF2817) EXEC(DO)
             CHGVAR     VAR(&TEXT) VALUE('Target File (.csv) Open +
                          Error! Please Check Target File and Try +
                          Again! (APLC94NS-1)')
             CALL PGM(QUILNGTX) PARM(&TEXT X'00000046' ' ' ' ' X'00000000')
             GOTO       CMDLBL(END)
             ENDDO

      /* TRANSFER 1 FOR TEXT */
             IF COND(&TYPE='1') THEN(DO)
             CPYF       FROMFILE(&LIBL/&FILE) +
                          TOFILE(HWFILE1/FILE1024) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)

             CPYTOIMPF  FROMFILE(HWFILE1/FILE1024) TOSTMF(&DIR2) +
                          MBROPT(*REPLACE) RCDDLM(*CRLF) +
                          DTAFMT(*FIXED) RMVBLANK(*BOTH) +
                          FLDDLM(',') DATFMT(*USA) TIMFMT(*USA) +
                          ADDCOLNAM(*NONE)
             MONMSG     MSGID(CPF2817) EXEC(GOTO CMDLBL(ERROR))
             ENDDO

      /* TRANSFER 2 FOR PF */
             IF COND(&TYPE='2') THEN(DO)
             CPYTOIMPF  FROMFILE(&LIBL/&FILE) TOSTMF(&DIR2) +
                          MBROPT(*REPLACE) RCDDLM(*CRLF) +
                          DTAFMT(*DLM) RMVBLANK(*BOTH) FLDDLM(',') +
                          DATFMT(*USA) TIMFMT(*USA) ADDCOLNAM(&COL)
             MONMSG     MSGID(CPF2817) EXEC(GOTO CMDLBL(ERROR))
             ENDDO

             GOTO       CMDLBL(ENDMSG)
ERROR:
             CHGVAR     VAR(&TEXT) VALUE('Target File (.csv) Open +
                          Error! Please Check Target File and Try +
                          Again! (APLC94-2)')
             CALL PGM(QUILNGTX) PARM(&TEXT X'00000046' ' ' ' ' X'00000000')
             GOTO       CMDLBL(END)

ENDMSG:
             IF         COND(&MSG  *EQ 'Y') THEN(DO)
             SNDBRKMSG  MSG('REPORT HAS BEEN CREATED IN YOUR USER +
                          DIRECTORY' *BCAT &DIR2) TOMSGQ(&WS)
             ENDDO
END:
             DLTOVR     FILE(*ALL)
             ENDPGM
