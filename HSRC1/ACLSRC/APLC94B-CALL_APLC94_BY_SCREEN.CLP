             PGM        PARM(&TYPE &FILE &LIBL &FNAM &CSV &ADDR &MSG)
   /*= APLC94 =============================================================*/
   /*  DATA TRANSFER CSV DATA TO IFS FOR CSV FORMAT WF                     */
   /*  J.WATANABE     2018.10.31                                           */
   /*                                                                      */
   /*  JW1            2018.08.23 ADD &ADDR                                 */
   /*  JW2            2018.10.31 ADD &MSG                                  */
   /*  JW3            2018.12.12 CHG SNDPGMMSG TO CALL QUILNGTX            */
   /*  --------------                                                      */
   /*  PARAMETERS                                                          */
   /*  1. &TYPE(1A) = 1, ONE FIELD / RECORD (TXT DATA WITH COMMA)          */
   /*               = 2, PF (ORDINALY PF, NO COMMA)                        */
   /*  2. &FILE(10A)= PF NAME TO BE TRANNSFERED TO IFS                     */
   /*  3. &LIBL(10A)= PF LIBRARY NAME FOR &FILE                            */
   /*  4. &FNAM(30A)= FILE NAME OF IFS (.CSV)                              */
   /*  5. &CSV(1A)  = Y, EXTENTION CODE WILL BE .CSV                       */
   /*             NOT Y, WITH NO EXTENTION CODE (MAMIYA SAN'S REQUEST)     */
   /*  6. &ADDR(1A) = Y, SEND CSV BY MAIL WITH ADDRESS                     */
   /*             NOT Y, DO NOT SEND CSV BY MAIL                           */
   /*  7. &MSG (1A) = Y, DSPLAY BREAK MSG                                  */
   /*             NOT Y, DO NOT DISPLAY BREAK MSG                          */
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
             DCL        VAR(&ADDR)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG )  TYPE(*CHAR) LEN(1)

             DCL        VAR(&FIL5)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&YYMM)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&DEPT)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&DEPN)  TYPE(*CHAR) LEN(15)
             DCL        VAR(&DIR1)  TYPE(*CHAR) LEN(100)
             DCL        VAR(&DIR2)  TYPE(*CHAR) LEN(110)
             DCL        VAR(&DIR3)  TYPE(*CHAR) LEN(100)
             DCL        VAR(&DIRN)  TYPE(*CHAR) LEN(20)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS  )  TYPE(*CHAR) LEN(10)

             DCL        VAR(&WFIL)  TYPE(*CHAR) LEN(60)

             DCL        VAR(&DATE6) TYPE(*CHAR) LEN(6)

             DCL        VAR(&I2   ) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MBAN ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&ANS  ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TEXT ) TYPE(*CHAR) LEN(100)
             DCL        VAR(&PSYS) TYPE(*CHAR) LEN(8)

 RUN:
             RTVJOBA    JOB(&WS  ) USER(&USER)
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&DATE6)
             RTVNETA    SYSNAME(&PSYS)

             IF         COND(&PSYS *EQ 'IAFAYM  ') THEN(GOTO +
                          CMDLBL(END)) /* ASJ TEST ENVIRONMENT */

             CHGVAR     VAR(&I2)   VALUE(%SST(&USER 1 2))
             CHGVAR     VAR(&FIL5) VALUE(%SST(&FILE 1 5))
             CHGVAR     VAR(&YYMM) VALUE('20' *CAT %SST(&DATE6 1 2) +
                          *CAT '_' *CAT %SST(&DATE6 3 2))

 /*========================================================*/
 /*   SET DEPARTMENT CODE                                  */
 /*========================================================*/
      /**DEFAULT*/
             CHGVAR     VAR(&DEPT) VALUE('3')
      /**ACCOUNTING */
             IF         COND(&I2 *EQ 'I4') THEN(DO)
             CHGVAR     VAR(&DEPT) VALUE('1')
             ENDDO
      /*MANUFACTURING*/
             IF         COND(&I2 *EQ 'I1') THEN(DO)
             CHGVAR     VAR(&DEPT) VALUE('2')
             ENDDO
      /**PC */
             IF         COND(&I2 *EQ 'I0') THEN(DO)
             CHGVAR     VAR(&DEPT) VALUE('3')
             ENDDO
      /* TEST */
             IF         COND(&I2 *EQ 'TE') THEN(DO)
             CHGVAR     VAR(&DEPT) VALUE('3')
             ENDDO
      /*SALES*/
             IF         COND(&I2 *EQ 'I3') THEN(DO)
             CHGVAR     VAR(&DEPT) VALUE('4')
             ENDDO
      /*ABMWP*/
             IF         COND(&FIL5 *EQ 'ABMWP') THEN(DO)
             CHGVAR     VAR(&DEPT) VALUE('5')
             ENDDO
      /*GDLWP*/
             IF         COND(&FIL5 *EQ 'GDLWP') THEN(DO)
             CHGVAR     VAR(&DEPT) VALUE('6')
             ENDDO

 /*========================================================*/
 /*   TO QNTC/IAF-AS400-FILE/AS400-TRANS/XX/DOWNLOAD       */
 /*========================================================*/

      /* ADD TIME STAMP */
             IF         COND(&CSV *EQ 'Y') THEN(DO)
             CHGVAR     VAR(&WFIL) VALUE(&FNAM *BCAT &DATE6 *CAT +
                          '.csv')
             ENDDO
             IF         COND(&CSV *NE 'Y') THEN(DO)
             CHGVAR     VAR(&WFIL) VALUE(&FNAM *BCAT &DATE6)
             ENDDO

      /* GET DEPARTMENT NAME */
             IF         COND(&DEPT *EQ '1') THEN(DO)
             CHGVAR     VAR(&DEPN) VALUE('ACCOUNTING     ')
             CHGVAR     VAR(&DIRN) VALUE('AS400 Xfer AC(K:)')
             ENDDO
             IF         COND(&DEPT *EQ '2') THEN(DO)
             CHGVAR     VAR(&DEPN) VALUE('MANUFACTURING  ')
             CHGVAR     VAR(&DIRN) VALUE('AS400 Xfer MF(M:)')
             ENDDO
             IF         COND(&DEPT *EQ '3') THEN(DO)
             CHGVAR     VAR(&DEPN) VALUE('PC             ')
             CHGVAR     VAR(&DIRN) VALUE('AS400 Xfer PC(J:)')
             ENDDO
             IF         COND(&DEPT *EQ '4') THEN(DO)
             CHGVAR     VAR(&DEPN) VALUE('SALES          ')
             CHGVAR     VAR(&DIRN) VALUE('AS400 Xfer SA(L:)')
             ENDDO
             IF         COND(&DEPT *EQ '5') THEN(DO)
             CHGVAR     VAR(&DEPN) VALUE('PC             ')
             CHGVAR     VAR(&DIRN) VALUE('AS400 Xfer PC(J:)')
             ENDDO
             IF         COND(&DEPT *EQ '6') THEN(DO)
             CHGVAR     VAR(&DEPN) VALUE('ACCOUNTING     ')
             CHGVAR     VAR(&DIRN) VALUE('AS400 Xfer PC(K:)')
             ENDDO

      /* CREATE DIRECTRY */
      /* DEFAULT */
             IF         COND((&DEPT *NE '5') *AND (&DEPT *NE '6')) +
                          THEN(DO)
             CHGVAR     VAR(&DIR1) +
                          VALUE('QNTC/IAF-AS400-FILE/AS400-TRANS/' +
                          *TCAT &DEPN *TCAT '/Download/' *CAT &USER)
                        ENDDO
      /* &DEPT=5         */
             IF         COND(&DEPT *EQ '5') THEN(DO)
             CHGVAR     VAR(&DIR1) +
                          VALUE('QNTC/IAF-AS400-FILE/AS400-TRANS+
                          /' *TCAT &DEPN *TCAT '/Download/AUTO +
                          SETTING/' *CAT &YYMM)
                        ENDDO
      /* &DEPT=6         */
             IF         COND(&DEPT *EQ '6') THEN(DO)
             CHGVAR     VAR(&DIR1) +
                          VALUE('QNTC/IAF-AS400-FILE/AS400-TRANS/' +
                          *TCAT &DEPN *TCAT '/Download/AS400/OUTSRC')
                        ENDDO

             CRTDIR     DIR(&DIR1)
             MONMSG     MSGID(CPFA0A0)
             MONMSG     MSGID(CPFA0A9)
             CHGVAR     VAR(&DIR2) VALUE(&DIR1 *TCAT '/' *TCAT &WFIL)

      /* COPY DUMMY 0 RECORD */
             CRTDUPOBJ  OBJ(MBDWPT5) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(QTEMP/MBDWPT5)
             MONMSG     MSGID(CPF2103 CPF3261 CPF2105)

             CPYTOIMPF  FROMFILE(QTEMP/MBDWPT5) TOSTMF(&DIR2) +
                          MBROPT(*REPLACE) RCDDLM(*CRLF) +
                          RMVBLANK(*BOTH) FLDDLM(',') DATFMT(*USA) +
                          TIMFMT(*USA)
      /* ERROR MSG    */
             MONMSG     MSGID(CPF2817) EXEC(DO)
         /** SNDPGMMSG  MSG('TARGET FILE OPEN ERROR! CHECK IF TARGET +  **/
         /**              FILE (.csv) CAN OPEN. PRESS C TO END OR G +   **/
         /**              TO RUN AGAIN... (APLC97-1)') TOMSGQ(&WS) +    **/
         /**              MSGTYPE(*INQ) KEYVAR(&MBAN)                   **/
         /** RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +        **/
         /**              MSG(&ANS)                                     **/
         /** IF COND((&ANS='G') *OR (&ANS= 'g')) THEN(GOTO CMDLBL(RUN)) **/
         /** GOTO       CMDLBL(END)                                     **/

             CHGVAR     VAR(&TEXT) VALUE('Target File (.csv) Open +
                          Error! Please Check Target File and Try +
                          Again! (APLC94-1)')
             CALL PGM(QUILNGTX) PARM(&TEXT X'00000046' ' ' ' ' X'00000000')
             GOTO       CMDLBL(END)
             ENDDO

      /* TRANSFER 1...*/
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

      /* TRANSFER 2...*/
             IF COND(&TYPE='2') THEN(DO)
             CPYTOIMPF  FROMFILE(&LIBL/&FILE) TOSTMF(&DIR2) +
                          MBROPT(*REPLACE) RCDDLM(*CRLF) +
                          DTAFMT(*DLM) RMVBLANK(*BOTH) FLDDLM(',') +
                          DATFMT(*USA) TIMFMT(*USA) ADDCOLNAM(*NONE)
             MONMSG     MSGID(CPF2817) EXEC(GOTO CMDLBL(ERROR))
             ENDDO

             GOTO       CMDLBL(ENDMSG)
ERROR:
      /* ERROR MSG    */
         /** SNDPGMMSG  MSG('TARGET FILE COPY ERROR! CHECK IF TARGET + **/
         /**              FILE (.csv) CAN ALLOCATE. PRESS C TO END +   **/
         /**              OR G TO RUN AGAIN... (APLC97-2)') +          **/
         /**              TOMSGQ(&WS) MSGTYPE(*INQ) KEYVAR(&MBAN)      **/
         /** RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +       **/
         /**              MSG(&ANS)                                    **/
         /** IF COND((&ANS='G') *OR (&ANS= 'g')) THEN(GOTO CMDLBL(RUN))**/
         /** GOTO       CMDLBL(END)                                    **/

             CHGVAR     VAR(&TEXT) VALUE('Target File (.csv) Open +
                          Error! Please Check Target File and Try +
                          Again! (APLC94-2)')
             CALL PGM(QUILNGTX) PARM(&TEXT X'00000046' ' ' ' ' X'00000000')
             GOTO       CMDLBL(END)

ENDMSG:
             IF         COND(&MSG  *EQ 'Y') THEN(DO)

             IF         COND(&DEPT *NE '5') THEN(DO)
             CHGVAR     VAR(&DIR3) VALUE(&DIRN *CAT '/Download/' +
                          *CAT &USER *TCAT '/' *TCAT &WFIL)
             ENDDO
             IF         COND(&DEPT *EQ '5') THEN(DO)
             CHGVAR     VAR(&DIR3) VALUE(&DIRN *CAT '/Download/AUTO +
                          SETTING/' *CAT &YYMM *TCAT '/' *TCAT &WFIL)
             ENDDO

             IF         COND(&DEPT *NE '5') THEN(DO)
             SNDBRKMSG  MSG('REPORT HAS BEEN CREATED IN YOUR USER +
                          DIRECTORY' *BCAT &DIR3) TOMSGQ(&WS)
             ENDDO

             ENDDO

END:
             DLTOVR     FILE(*ALL)
             ENDPGM
