             PGM
             /** AJFCP2 **********************************************/
             /* COMPILES IAF RPG III / CL SOURCE PROGRAM             */
             /*        I-HASADA                      96.06.28        */
             /********************************************** AJFCP2 **/
             DCLF       FILE(AJFPW02)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USE5) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYP) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&@APGM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&@PGM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WCHK) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WSLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WOLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WSRC) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WER1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WER2) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WER3) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PSYS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WKUBN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WPGM1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WPGM6) TYPE(*CHAR) LEN(1)
             RTVNETA    SYSNAME(&PSYS)
             RTVJOBA    JOB(&WS) USER(&USER)

             CHGVAR     VAR(&USE5) VALUE(%SST(&USER 1 5))
             CHGVAR     VAR(&WS3) VALUE(%SST(&WS 1 3))

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYP &PRTG)

             CHGJOB     OUTQ(&PRTG)
             CHGVAR     VAR(&AI) VALUE('I')
             CHGVAR     VAR(&AR) VALUE('H')
             CHGVAR     VAR(&AY) VALUE('N')
             CHGVAR     VAR(&AJOBQ) VALUE('0')

             IF         (&USE5 *EQ 'TEST ') DO
             CHGVAR     VAR(&IN88) VALUE('1')
             ENDDO

 STP1:       SNDRCVF    RCDFMT(AJFPW021)
             IF         (&IN01 *EQ '1') GOTO END
             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN04) VALUE('0')
             CHGVAR     VAR(&IN05) VALUE('0')
             CHGVAR     VAR(&IN06) VALUE('0')
             CHGVAR     VAR(&IN07) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         ((&WER2 *EQ 'E') *OR (&WER3 *EQ 'E')) DO
             IF         COND(&WS3  *EQ 'HPI') THEN(DO)
             DSPSPLF    FILE(&APGM) SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)
             ENDDO
             GOTO       END
             ENDDO

             /*------------*/
             /*  ..HELP..  */
             /*------------*/
             IF         (&IN50 *EQ '1') DO
             SNDRCVF    RCDFMT(AJFPW022)
             GOTO       STP1
             ENDDO

             /*---------------*/
             /*  ..PGM ..     */
             /*---------------*/
             IF         (&APGM *EQ '      ') DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&AERR) VALUE('ABNRML')
             CHGVAR     VAR(&MSG) VALUE('ENTER PROGRAM NAME')
             GOTO       STP1
             ENDDO

             CHGVAR     VAR(&WKUBN) VALUE('O')
             IF         (%SST(&APGM 4 1) *EQ 'R') GOTO @OLD
             IF         (%SST(&APGM 4 1) *EQ 'C') GOTO @OLD
             IF         (%SST(&APGM 4 1) *EQ 'M') GOTO @OLD
             CHGVAR     VAR(&WKUBN) VALUE('N')

             CHGVAR     VAR(&WPGM1) VALUE(%SST(&APGM 1 1))

  /**        IF         COND(&WPGM1 *EQ 'A') THEN(GOTO CMDLBL(@CHK1))     **/
  /**        IF         COND(&WPGM1 *EQ 'B') THEN(GOTO CMDLBL(@CHK1))     **/
  /**        IF         COND(&WPGM1 *EQ 'C') THEN(GOTO CMDLBL(@CHK1))     **/
  /**        IF         COND(&WPGM1 *EQ 'D') THEN(GOTO CMDLBL(@CHK1))     **/
  /**        IF         COND(&WPGM1 *EQ 'E') THEN(GOTO CMDLBL(@CHK1))     **/
  /**        IF         COND(&WPGM1 *EQ 'F') THEN(GOTO CMDLBL(@CHK1))     **/
  /**        IF         COND(&WPGM1 *EQ 'G') THEN(GOTO CMDLBL(@CHK1))     **/
  /**        IF         COND(&WPGM1 *EQ 'I') THEN(GOTO CMDLBL(@CHK1))     **/
  /**        IF         COND(&WPGM1 *EQ 'J') THEN(GOTO CMDLBL(@CHK1))     **/
  /**        IF         COND(&WPGM1 *EQ 'K') THEN(GOTO CMDLBL(@CHK1))     **/
  /**        IF         COND(&WPGM1 *EQ 'L') THEN(GOTO CMDLBL(@CHK1))     **/
  /**        IF         COND(&WPGM1 *EQ 'M') THEN(GOTO CMDLBL(@CHK1))     **/
  /**        IF         COND(&WPGM1 *EQ 'N') THEN(GOTO CMDLBL(@CHK1))     **/
  /**        IF         COND(&WPGM1 *EQ 'O') THEN(GOTO CMDLBL(@CHK1))     **/
  /**        IF         COND(&WPGM1 *EQ 'P') THEN(GOTO CMDLBL(@CHK1))     **/
  /**        IF         COND(&WPGM1 *EQ 'R') THEN(GOTO CMDLBL(@CHK1))     **/
  /**        IF         COND(&WPGM1 *EQ 'S') THEN(GOTO CMDLBL(@CHK1))     **/
  /**        IF         COND(&WPGM1 *EQ 'T') THEN(GOTO CMDLBL(@CHK1))     **/
  /**        IF         COND(&WPGM1 *EQ 'U') THEN(GOTO CMDLBL(@CHK1))     **/
  /**        IF         COND(&WPGM1 *EQ 'W') THEN(GOTO CMDLBL(@CHK1))     **/
  /**        IF         COND(&WPGM1 *EQ 'X') THEN(GOTO CMDLBL(@CHK1))     **/
  /**        IF         COND(&WPGM1 *EQ 'Y') THEN(GOTO CMDLBL(@CHK1))     **/
  /**                                                                     **/
  /**        CHGVAR     VAR(&IN02) VALUE('1')                             **/
  /**        CHGVAR     VAR(&IN99) VALUE('1')                             **/
  /**        CHGVAR     VAR(&AERR) VALUE('ABNRML')                        **/
  /**        CHGVAR     VAR(&MSG) VALUE('THE FIRST COLUMN OF FILE +       **/
  /**                     NAME IS WRONG.')                                **/
  /**        GOTO       STP1                                              **/

@CHK1:
             CHGVAR     VAR(&WPGM6) VALUE(%SST(&APGM 6 1))

             IF         COND(&WPGM6 *EQ 'R') THEN(GOTO CMDLBL(STP3))
             IF         COND(&WPGM6 *EQ 'C') THEN(GOTO CMDLBL(STP3))
@OLD:
             /*--------------------------*/
             /*  PROGRAM HEAD 1 COLUMN   */
             /*--------------------------*/
     /**     IF         (%SST(&APGM 1 1) *EQ 'A') GOTO STP2           **/
     /**     IF         (%SST(&APGM 1 1) *EQ 'D') GOTO STP2           **/
     /**     IF         (%SST(&APGM 1 1) *EQ 'M') GOTO STP2           **/
     /**     IF         (%SST(&APGM 1 1) *EQ 'R') GOTO STP2           **/
     /**     IF         (%SST(&APGM 1 1) *EQ 'F') GOTO STP2           **/
     /**     IF         (%SST(&APGM 1 1) *EQ 'T') GOTO STP2           **/
     /**     IF         (%SST(&APGM 1 1) *EQ 'U') GOTO STP2           **/
     /**     IF         (%SST(&APGM 1 1) *EQ 'B') GOTO STP2           **/
     /**     IF         (%SST(&APGM 1 1) *EQ 'E') GOTO STP2           **/
     /**     IF         (%SST(&APGM 1 1) *EQ 'N') GOTO STP2           **/
     /**     IF         (%SST(&APGM 1 1) *EQ 'K') GOTO STP2           **/
     /**     IF         (%SST(&APGM 1 1) *EQ 'G') GOTO STP2           **/
     /**     IF         (%SST(&APGM 1 1) *EQ 'S') GOTO STP2           **/
     /**     IF         (%SST(&APGM 1 1) *EQ 'V') GOTO STP2           **/
     /**     IF         (%SST(&APGM 1 1) *EQ 'O') GOTO STP2           **/
     /**     IF         (%SST(&APGM 1 1) *EQ 'I') GOTO STP2           **/
     /**     IF         (%SST(&APGM 1 1) *EQ 'C') GOTO STP2           **/
     /**     IF         (%SST(&APGM 1 1) *EQ 'J') GOTO STP2           **/
     /**     CHGVAR     VAR(&IN02) VALUE('1')                         **/
     /**     CHGVAR     VAR(&IN99) VALUE('1')                         **/
     /**     CHGVAR     VAR(&AERR) VALUE('ABNRML')                    **/
     /**     CHGVAR     VAR(&MSG) +                                   **/
     /**                  VALUE('SOURCE FILE INSTRUCTION IS WRONG.')  **/
     /**     GOTO       STP1                                          **/

             /*--------------------------*/
             /*  PROGRAM HEAD 4 COLUMNS  */
             /*--------------------------*/
 STP2:       IF         (%SST(&APGM 4 1) *EQ 'R') GOTO STP3
             IF         (%SST(&APGM 4 1) *EQ 'C') GOTO STP3
             IF         (%SST(&APGM 4 1) *EQ 'M') GOTO STP3
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&AERR) VALUE('ABNRML')
             CHGVAR     VAR(&MSG) +
                          VALUE('ATTRIBUTE IS INVALID')
             GOTO       STP1

             /*--------------------------*/
             /*    STRUCTURED PROGRAM    */
             /*--------------------------*/
 STP3:       IF         ((&AI *NE 'K') *AND (&AI *NE 'I')) DO
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&AERR) VALUE('ABNRML')
             CHGVAR     VAR(&MSG) VALUE('SELECTION OF STRUCTURED +
                          PROGRAM LIST IS AN ERROR.')
             GOTO       STP1
             ENDDO

             /*------------------*/
             /* THE PRINT OUTPUT */
             /*------------------*/
             IF         ((&AR *NE 'R') *AND (&AR *NE 'H')) DO
             CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&AERR) VALUE('ABNRML')
             CHGVAR     VAR(&MSG) +
                          VALUE('OUTPUT IS INVALID')
             GOTO       STP1
             ENDDO

             /*------------------------*/
             /* LISTS MUTUAL REFERENCE */
             /*------------------------*/
             IF         ((&AY *NE 'Y') *AND (&AY *NE 'N')) DO
             CHGVAR     VAR(&IN05) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&AERR) VALUE('ABNRML')
             CHGVAR     VAR(&MSG) +
                          VALUE('A SELECTION OF MUTUAL CF. LIST IS AN ERROR.')
             GOTO       STP1
             ENDDO

             /*----------------------*/
             /*   JOB QUE            */
             /*----------------------*/
             IF         ((&AJOBQ *NE '0') *AND (&AJOBQ *NE '1') *AND +
                          (&AJOBQ *NE '2')) DO
             CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&AERR) VALUE('ABNRML')
             CHGVAR     VAR(&MSG) +
                          VALUE('A SELECTION OF JOB QUE IS AN ERROR.')
             GOTO       STP1
             ENDDO

             /*--------------------------------*/
             /*   PROGRAM EXISTENCE CHECK      */
             /*--------------------------------*/
             IF         (&APGM *NE &@APGM) DO
             CHGVAR     VAR(&@APGM) VALUE(&APGM)
             CHGVAR     VAR(&WCHK) VALUE(' ')
             CHGVAR     VAR(&WER1) VALUE(' ')

             CHKOBJ     OBJ(&APGM) OBJTYPE(*PGM)
             MONMSG    (CPF9801 CPF3275) *N GOTO STP4
             CHGVAR     VAR(&WER1) VALUE('Y')
             ENDDO

 STP4:       IF         (&WER1 *NE ' ') DO
             IF         ((&WCHK *NE 'C') *OR (&IN16 *NE '1')) DO
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&WCHK) VALUE('C')
             CHGVAR     VAR(&AERR) VALUE('WARNIN')
             CHGVAR     VAR(&MSG) VALUE('OBJECT EXISTS')

             GOTO       STP1
             ENDDO
             ENDDO

             /*------------------*/
             /* .SOURCE LIBRARY. */
             /*------------------*/
             CHGVAR     VAR(&WSLIB) VALUE('HSRC1   ')

             /*---------------*/
             /* .SOURCE FILE. */
             /*---------------*/
             CHGVAR     VAR(&WSRC) VALUE('        ')

             IF         COND(&WKUBN *EQ 'O') THEN(GOTO CMDLBL(@OLD2))

             IF         COND(&WPGM6 *EQ 'R') THEN(DO)
             CHGVAR     VAR(&WSRC) VALUE('ARPGSRC  ')
             ENDDO
             IF         COND(&WPGM6 *EQ 'C') THEN(DO)
             CHGVAR     VAR(&WSRC) VALUE('ACLSRC   ')
             ENDDO

             GOTO       CMDLBL(@OBJ)
@OLD2:
             CHGVAR     VAR(&@PGM) VALUE(%SST(&APGM 4 1))

             /*--------------*/
             /*  ..CL.CMD..  */
             /*--------------*/
             IF         COND((&@PGM *EQ 'C') *OR (&@PGM *EQ 'M')) +
                          THEN(DO)
             CHGVAR     VAR(&WSRC) VALUE('ACLSRC')
             ENDDO

             /*-----------*/
             /*  ..RPG..  */
             /*-----------*/
             IF         COND(&@PGM *EQ 'R') THEN(DO)
             CHGVAR     VAR(&WSRC) VALUE('ARPGSRC')
             ENDDO

@OBJ:
             /*-----------------------*/
             /*  ..OBJECT LIBRARY ..  */
             /*-----------------------*/
             CHGVAR     VAR(&WOLIB) VALUE('HOBJ1   ')

             IF         (&USE5 *EQ 'TEST ') DO
             CHGVAR     VAR(&WOLIB) VALUE('TOBJ1   ')
             ENDDO
@DLT:
             /*--------------*/
             /*  ..DLTPGM..  */
             /*--------------*/
             DLTPGM     PGM(&APGM)
             MONMSG     MSGID(CPF2105)

             IF         (&PSYS *EQ 'IAF     ') DO
             IF         (&USE5 *EQ 'QPGMR') DO

             DLTPGM     PGM(TOBJ1/&APGM)
             MONMSG     MSGID(CPF2105)

             ENDDO
             ENDDO

             /*------------*/
             /*  ..JOBQ..  */
             /*------------*/
             IF         (&AJOBQ *EQ '0') DO
             CALL       PGM(AJFCJ2) PARM(&WSLIB &WOLIB &WSRC &APGM +
                          &AI &AR &AY &AJOBQ &PRTG &WER2 &WER3)

             IF         (&WER2 *EQ 'E') DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN05) VALUE('1')
             CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&IN07) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&AERR) VALUE('ABNRML')
             CHGVAR     VAR(&MSG) VALUE('COMPILED IN ERROR')
             GOTO       STP1
             ENDDO

             IF         (&WER3 *EQ 'E') DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN05) VALUE('1')
             CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&IN07) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&AERR) VALUE('ABNRML')
             CHGVAR     VAR(&MSG) VALUE('SOURCE NOT FOUND')
             GOTO       STP1
             ENDDO

             IF         (&PSYS *EQ 'IAF     ') DO
             IF         (&USE5 *EQ 'QPGMR') DO

             IF         ((&WER2 *EQ ' ') *AND (&WER3 *EQ ' ')) DO

             CHGVAR     VAR(&WER2) VALUE(' ')
             CHGVAR     VAR(&WER3) VALUE(' ')

             CALL       PGM(AJFCK2) PARM(&WSLIB &WOLIB &WSRC &APGM +
                          &AI &AR &AY &AJOBQ &PRTG &WER2 &WER3)

             IF         (&WER2 *EQ 'E') DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN05) VALUE('1')
             CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&IN07) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&AERR) VALUE('ABNRML')
             CHGVAR     VAR(&MSG) VALUE('( TEST LIBRARY )  COPILED IN ERROR')
             GOTO       STP1
             ENDDO

             IF         (&WER3 *EQ 'E') DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN05) VALUE('1')
             CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&IN07) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&AERR) VALUE('ABNRML')
             CHGVAR     VAR(&MSG) VALUE('( TEST LIBRARY )  SOURCE NOT FOUND')
             GOTO       STP1
             ENDDO
             ENDDO
             ENDDO
             ENDDO

             CHGVAR     VAR(&AI) VALUE('I')
             CHGVAR     VAR(&AR) VALUE('H')
             CHGVAR     VAR(&AY) VALUE('N')
             CHGVAR     VAR(&AJOBQ) VALUE('0')
             CHGVAR     VAR(&APGM) VALUE('      ')
             CHGVAR     VAR(&@APGM) VALUE('      ')
             GOTO       END
             ENDDO

             IF         (&AJOBQ *EQ '1') DO
             SBMJOB     JOB(JOBQ1) JOBD(QBATCH1) JOBQ(JOBQ1) +
                          RQSDTA('CALL PGM(AJFCJ2) PARM(''' *CAT +
                          &WSLIB *CAT ''' ''' *CAT &WOLIB *CAT ''' +
                          ''' *CAT &WSRC *CAT ''' ''' *CAT &APGM +
                          *CAT ''' ''' *CAT &AI *CAT ''' ''' *CAT +
                          &AR *CAT ''' ''' *CAT &AY *CAT ''' ''' +
                          *CAT &AJOBQ *CAT ''' ''' *CAT &PRTG *CAT +
                          ''' ''' *CAT &WER2 *CAT ''' ''' *CAT +
                          &WER3 *CAT ''')')

             IF         (&PSYS *EQ 'IAF     ') DO
             IF         (&USE5 *EQ 'QPGMR') DO

             IF         ((&WER2 *EQ ' ') *AND (&WER3 *EQ ' ')) DO

             CHGVAR     VAR(&WER2) VALUE(' ')
             CHGVAR     VAR(&WER3) VALUE(' ')

             SBMJOB     JOB(JOBQ1) JOBD(QBATCH1) JOBQ(JOBQ1) +
                          RQSDTA('CALL PGM(AJFCK2) PARM(''' *CAT +
                          &WSLIB *CAT ''' ''' *CAT &WOLIB *CAT ''' +
                          ''' *CAT &WSRC *CAT ''' ''' *CAT &APGM +
                          *CAT ''' ''' *CAT &AI *CAT ''' ''' *CAT +
                          &AR *CAT ''' ''' *CAT &AY *CAT ''' ''' +
                          *CAT &AJOBQ *CAT ''' ''' *CAT &PRTG *CAT +
                          ''' ''' *CAT &WER2 *CAT ''' ''' *CAT +
                          &WER3 *CAT ''')')
             ENDDO
             ENDDO
             ENDDO
             ENDDO

             IF         (&AJOBQ *EQ '2') DO
             SBMJOB     JOB(JOBQ2) JOBD(QBATCH2) JOBQ(JOBQ2) +
                          RQSDTA('CALL PGM(AJFCJ2) PARM(''' *CAT +
                          &WSLIB *CAT ''' ''' *CAT &WOLIB *CAT ''' +
                          ''' *CAT &WSRC *CAT ''' ''' *CAT &APGM +
                          *CAT ''' ''' *CAT &AI *CAT ''' ''' *CAT +
                          &AR *CAT ''' ''' *CAT &AY *CAT ''' ''' +
                          *CAT &AJOBQ *CAT ''' ''' *CAT &PRTG *CAT +
                          ''' ''' *CAT &WER2 *CAT ''' ''' *CAT +
                          &WER3 *CAT ''')')

             IF         (&PSYS *EQ 'IAF     ') DO
             IF         (&USE5 *EQ 'QPGMR') DO

             IF         ((&WER2 *EQ ' ') *AND (&WER3 *EQ ' ')) DO

             CHGVAR     VAR(&WER2) VALUE(' ')
             CHGVAR     VAR(&WER3) VALUE(' ')

             SBMJOB     JOB(JOBQ2) JOBD(QBATCH2) JOBQ(JOBQ2) +
                          RQSDTA('CALL PGM(AJFCK2) PARM(''' *CAT +
                          &WSLIB *CAT ''' ''' *CAT &WOLIB *CAT ''' +
                          ''' *CAT &WSRC *CAT ''' ''' *CAT &APGM +
                          *CAT ''' ''' *CAT &AI *CAT ''' ''' *CAT +
                          &AR *CAT ''' ''' *CAT &AY *CAT ''' ''' +
                          *CAT &AJOBQ *CAT ''' ''' *CAT &PRTG *CAT +
                          ''' ''' *CAT &WER2 *CAT ''' ''' *CAT +
                          &WER3 *CAT ''')')
             ENDDO
             ENDDO
             ENDDO
             ENDDO

 END:        ENDPGM
