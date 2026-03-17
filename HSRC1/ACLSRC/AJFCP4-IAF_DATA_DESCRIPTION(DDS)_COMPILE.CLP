             PGM
             /** AJFCP4 ******************************************/
             /*   IAF DATA DESCRIPTION(DDS) COMPILE.             */
             /* I-HASADA                     96.06.28            */
             /* JW1   2018.10.08 CHG FILE TO 8A                  */
             /* JW2   2020.12.14 CHG ALLOW FILE NAME WITH EP/EL  */
             /* JW3   2022.07.29 CHG ALLOW FILE NAME WITH EP/EL  */
             /* JW4   2026.01.19 STOP CHECKING FILE NAME         */
             /****************************************************/
             DCLF       FILE(AJFPW04)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USE5) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYP) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)

             DCL        VAR(&@AFILE) TYPE(*CHAR) LEN(8)

             DCL        VAR(&@FL1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&@FL42) TYPE(*CHAR) LEN(2)
             DCL        VAR(&WCHK) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WSLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WOLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WSRC) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WTXT) TYPE(*CHAR) LEN(50)
             DCL        VAR(&WSIZ1) TYPE(*CHAR) LEN(6) VALUE('999999')
             DCL        VAR(&WSIZ2) TYPE(*CHAR) LEN(5) VALUE('10000')
             DCL        VAR(&WSIZ3) TYPE(*CHAR) LEN(1) VALUE('3')
             DCL        VAR(&WRECD) TYPE(*CHAR) LEN(3) VALUE('132')
             DCL        VAR(&WER1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WER2) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WER3) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PSYS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WKUBN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WFILE1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WFILE6) TYPE(*CHAR) LEN(1)
             RTVNETA    SYSNAME(&PSYS)
             RTVJOBA    JOB(&WS) USER(&USER)
             CHGJOB     SWS(00000000)

             CHGVAR     VAR(&USE5) VALUE(%SST(&USER 1 5))

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYP &PRTG)

             CHGJOB     OUTQ(&PRTG)
             CHGVAR     VAR(&AKSN) VALUE('N')
             CHGVAR     VAR(&ALIN) VALUE('6')
             CHGVAR     VAR(&AR) VALUE('H')
             CHGVAR     VAR(&AJOBQ) VALUE('0')

             IF         (&USE5 *EQ 'TEST ') DO
             CHGVAR     VAR(&IN88) VALUE('1')
             ENDDO

 STP1:       SNDRCVF    RCDFMT(AJFPW041)
             IF         (&IN01 *EQ '1') GOTO END

             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN03) VALUE('0')
             CHGVAR     VAR(&IN04) VALUE('0')
             CHGVAR     VAR(&IN05) VALUE('0')
             CHGVAR     VAR(&IN06) VALUE('0')
             CHGVAR     VAR(&IN07) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         ((&WER2 *EQ 'E') *OR (&WER3 *EQ 'E')) DO
             GOTO       END
             ENDDO

             /*------------*/
             /*  ..HELP..  */
             /*------------*/
             IF         (&IN50 *EQ '1') DO
             SNDRCVF    RCDFMT(AJFPW042)
             GOTO       STP1
             ENDDO

             /*------------*/
             /* ..FILE .. */
             /*------------*/
             IF         (&AFILE *EQ '        ') DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&AERR) VALUE('ABNRML')
             CHGVAR     VAR(&MSG) VALUE('ENTER FILE NAME')
             GOTO       STP1
             ENDDO

             CHGVAR     VAR(&WKUBN) VALUE('O')
             IF         (%SST(&AFILE 4 2) *EQ 'PP') GOTO @OLD
             IF         (%SST(&AFILE 4 2) *EQ 'PL') GOTO @OLD
             IF         (%SST(&AFILE 4 2) *EQ 'TP') GOTO @OLD
             IF         (%SST(&AFILE 4 2) *EQ 'TL') GOTO @OLD
             IF         (%SST(&AFILE 4 2) *EQ 'WP') GOTO @OLD
             IF         (%SST(&AFILE 4 2) *EQ 'WL') GOTO @OLD
             IF         (%SST(&AFILE 4 2) *EQ 'NP') GOTO @OLD
             IF         (%SST(&AFILE 4 2) *EQ 'NL') GOTO @OLD
             IF         (%SST(&AFILE 4 2) *EQ 'PW') GOTO @OLD
             IF         (%SST(&AFILE 4 2) *EQ 'PR') GOTO @OLD
/*JW*/       IF         (%SST(&AFILE 4 2) *EQ 'EP') GOTO @OLD
/*JW*/       IF         (%SST(&AFILE 4 2) *EQ 'EL') GOTO @OLD

             CHGVAR     VAR(&WKUBN) VALUE('N')
             CHGVAR     VAR(&WFILE1) VALUE(%SST(&AFILE 1 1))
             CHGVAR     VAR(&WFILE6) VALUE(%SST(&AFILE 6 1))

 /**JW4**/   GOTO       CMDLBL(@CHK1)

       /**   IF         COND(&WFILE1 *EQ 'A') THEN(GOTO CMDLBL(@CHK1))      **/
       /**   IF         COND(&WFILE1 *EQ 'B') THEN(GOTO CMDLBL(@CHK1))      **/
       /**   IF         COND(&WFILE1 *EQ 'C') THEN(GOTO CMDLBL(@CHK1))      **/
       /**   IF         COND(&WFILE1 *EQ 'D') THEN(GOTO CMDLBL(@CHK1))      **/
       /**   IF         COND(&WFILE1 *EQ 'E') THEN(GOTO CMDLBL(@CHK1))      **/
       /**   IF         COND(&WFILE1 *EQ 'F') THEN(GOTO CMDLBL(@CHK1))      **/
       /**   IF         COND(&WFILE1 *EQ 'G') THEN(GOTO CMDLBL(@CHK1))      **/
       /**   IF         COND(&WFILE1 *EQ 'I') THEN(GOTO CMDLBL(@CHK1))      **/
       /**   IF         COND(&WFILE1 *EQ 'J') THEN(GOTO CMDLBL(@CHK1))      **/
       /**   IF         COND(&WFILE1 *EQ 'K') THEN(GOTO CMDLBL(@CHK1))      **/
       /**   IF         COND(&WFILE1 *EQ 'L') THEN(GOTO CMDLBL(@CHK1))      **/
       /**   IF         COND(&WFILE1 *EQ 'M') THEN(GOTO CMDLBL(@CHK1))      **/
       /**   IF         COND(&WFILE1 *EQ 'N') THEN(GOTO CMDLBL(@CHK1))      **/
       /**   IF         COND(&WFILE1 *EQ 'O') THEN(GOTO CMDLBL(@CHK1))      **/
       /**   IF         COND(&WFILE1 *EQ 'P') THEN(GOTO CMDLBL(@CHK1))      **/
       /**   IF         COND(&WFILE1 *EQ 'R') THEN(GOTO CMDLBL(@CHK1))      **/
       /**   IF         COND(&WFILE1 *EQ 'S') THEN(GOTO CMDLBL(@CHK1))      **/
       /**   IF         COND(&WFILE1 *EQ 'T') THEN(GOTO CMDLBL(@CHK1))      **/
       /**   IF         COND(&WFILE1 *EQ 'U') THEN(GOTO CMDLBL(@CHK1))      **/
       /**   IF         COND(&WFILE1 *EQ 'W') THEN(GOTO CMDLBL(@CHK1))      **/
       /**   IF         COND(&WFILE1 *EQ 'X') THEN(GOTO CMDLBL(@CHK1))      **/
       /**   IF         COND(&WFILE1 *EQ 'Y') THEN(GOTO CMDLBL(@CHK1))      **/
       /**                                                                  **/
       /**   CHGVAR     VAR(&IN02) VALUE('1')                               **/
       /**   CHGVAR     VAR(&IN99) VALUE('1')                               **/
       /**   CHGVAR     VAR(&AERR) VALUE('ABNRML')                          **/
       /**   CHGVAR     VAR(&MSG) VALUE('THE FIRST COLUMN OF FILE +         **/
       /**                NAME IS WRONG')                                  **/
       /**   GOTO       STP1                                                **/
@CHK1:
             IF         COND(&WFILE6 *EQ 'P') THEN(GOTO CMDLBL(STP3))
             IF         COND(&WFILE6 *EQ 'L') THEN(GOTO CMDLBL(STP3))
             IF         COND(&WFILE6 *EQ 'W') THEN(GOTO CMDLBL(STP3))
             IF         COND(&WFILE6 *EQ 'F') THEN(GOTO CMDLBL(STP3))
             IF         COND(&WFILE6 *EQ 'N') THEN(GOTO CMDLBL(STP3))
             IF         COND(&WFILE6 *EQ 'D') THEN(GOTO CMDLBL(STP3))
             IF         COND(&WFILE6 *EQ 'V') THEN(GOTO CMDLBL(STP3))
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&AERR) VALUE('ABNRML')
             CHGVAR     VAR(&MSG) VALUE('FILE NAME IS NOT ACCEPTABLE')
             GOTO       STP1
 @OLD:

             /*------------------------*/
             /*   FILE HEAD 1 COLUMN   */
             /*------------------------*/
 /**JW4**/   GOTO       CMDLBL(STP2)

      /**    IF         (%SST(&AFILE 1 1) *EQ 'A') GOTO STP2       **/
      /**    IF         (%SST(&AFILE 1 1) *EQ 'D') GOTO STP2       **/
      /**    IF         (%SST(&AFILE 1 1) *EQ 'M') GOTO STP2       **/
      /**    IF         (%SST(&AFILE 1 1) *EQ 'R') GOTO STP2       **/
      /**    IF         (%SST(&AFILE 1 1) *EQ 'F') GOTO STP2       **/
      /**    IF         (%SST(&AFILE 1 1) *EQ 'T') GOTO STP2       **/
      /**    IF         (%SST(&AFILE 1 1) *EQ 'U') GOTO STP2       **/
      /**    IF         (%SST(&AFILE 1 1) *EQ 'B') GOTO STP2       **/
      /**    IF         (%SST(&AFILE 1 1) *EQ 'E') GOTO STP2       **/
      /**    IF         (%SST(&AFILE 1 1) *EQ 'N') GOTO STP2       **/
      /**    IF         (%SST(&AFILE 1 1) *EQ 'K') GOTO STP2       **/
      /**    IF         (%SST(&AFILE 1 1) *EQ 'G') GOTO STP2       **/
      /**    IF         (%SST(&AFILE 1 1) *EQ 'S') GOTO STP2       **/
      /**    IF         (%SST(&AFILE 1 1) *EQ 'V') GOTO STP2       **/
      /**    IF         (%SST(&AFILE 1 1) *EQ 'O') GOTO STP2       **/
      /**    IF         (%SST(&AFILE 1 1) *EQ 'I') GOTO STP2       **/
      /**    IF         (%SST(&AFILE 1 1) *EQ 'C') GOTO STP2       **/
      /**    IF         (%SST(&AFILE 1 1) *EQ 'J') GOTO STP2       **/
      /**    CHGVAR     VAR(&IN02) VALUE('1')                      **/
      /**    CHGVAR     VAR(&IN99) VALUE('1')                      **/
      /**    CHGVAR     VAR(&AERR) VALUE('ABNRML')                 **/
      /**    CHGVAR     VAR(&MSG) VALUE('THE FIRST COLUMN OF FILE +**/
      /**                 NAME IS WRONG ')                         **/
      /**    GOTO       STP1                                       **/

             /*----------------------------*/
             /*   FILE HEAD 4  5 COLUMNS   */
             /*----------------------------*/
 STP2:       IF         (%SST(&AFILE 4 2) *EQ 'PP') GOTO STP3
             IF         (%SST(&AFILE 4 2) *EQ 'PL') GOTO STP3
             IF         (%SST(&AFILE 4 2) *EQ 'TP') GOTO STP3
             IF         (%SST(&AFILE 4 2) *EQ 'TL') GOTO STP3
             IF         (%SST(&AFILE 4 2) *EQ 'WP') GOTO STP3
             IF         (%SST(&AFILE 4 2) *EQ 'WL') GOTO STP3
             IF         (%SST(&AFILE 4 2) *EQ 'NP') GOTO STP3
             IF         (%SST(&AFILE 4 2) *EQ 'NL') GOTO STP3
             IF         (%SST(&AFILE 4 2) *EQ 'PW') GOTO STP3
             IF         (%SST(&AFILE 4 2) *EQ 'PR') GOTO STP3
 /*JW2*/     IF         (%SST(&AFILE 4 2) *EQ 'EP') GOTO STP3
 /*JW2*/     IF         (%SST(&AFILE 4 2) *EQ 'EL') GOTO STP3
 /*JW2*/     IF         (%SST(&AFILE 4 2) *EQ 'AP') GOTO STP3
 /*JW2*/     IF         (%SST(&AFILE 4 2) *EQ 'AL') GOTO STP3
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&AERR) VALUE('ABNRML')
             CHGVAR     VAR(&MSG) VALUE('4 OR 5 COLUMNS OF THE FILE +
                          NAME IS NOT ACCEPTABLE ')
             GOTO       STP1

             /*--------------------------*/
             /*  APPOINTED SCREEN WITH RULED LINE    */
             /*--------------------------*/
 STP3:       IF         ((&AKSN *NE 'Y') *AND (&AKSN *NE 'N')) DO
             CHGVAR     VAR(&IN07) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&AERR) VALUE('ABNRML')
             CHGVAR     VAR(&MSG) VALUE('APPOINTED SCREEN WITH RULED +
                          LINE IS AN ERROR ')
             GOTO       STP1
             ENDDO

             /*------------------------------------*/
             /* APPOINTED  PRINT DEVICE FILE LINE */
             /*------------------------------------*/
             IF         ((&ALIN *NE '6') *AND (&ALIN *NE '8')) DO
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&AERR) VALUE('ABNRML')
             CHGVAR     VAR(&MSG) VALUE('APPOINTED PRINT DEVICE FILE +
                          LINE IS AN ERROR ')
             GOTO       STP1
             ENDDO

             /*------------------*/
             /* THE PRINT OUTPUT */
             /*------------------*/
             IF         ((&AR *NE 'R') *AND (&AR *NE 'H')) DO
             CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&AERR) VALUE('ABNRML')
             CHGVAR     VAR(&MSG) VALUE('A SELECTION OF PRINT OUTPUT +
                          IS AN ERROR ')
             GOTO       STP1
             ENDDO

             /*----------------------*/
             /*   JOB QUE            */
             /*----------------------*/
             IF         ((&AJOBQ *NE '0') *AND (&AJOBQ *NE '1') *AND +
                          (&AJOBQ *NE '2')) DO
             CHGVAR     VAR(&IN05) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&AERR) VALUE('ABNRML')
             CHGVAR     VAR(&MSG) VALUE('A SELECTION OF JOB QUE IS +
                          AN ERROR ')
             GOTO       STP1
             ENDDO

             /*----------------------------*/
             /*   FILE NAME M/F   */
             /*----------------------------*/
             CALL       PGM(AJFR07) PARM(&AFILE &WSIZ1 &WSIZ2 &WSIZ3 +
                          &WRECD &WTXT)
             IF         (%SWITCH(1XXXXXXX)) DO
    /*       CHGVAR     VAR(&IN02) VALUE('1')                          */
    /*       CHGVAR     VAR(&IN99) VALUE('1')                          */
    /*       CHGVAR     VAR(&AERR) VALUE('ABNRML')                     */
    /*       CHGVAR     VAR(&MSG) +                                    */
    /*                    VALUE('THERE IS NOT IT IN FILE NAME M/F ')   */
    /*       GOTO STP1                                                 */
             ENDDO

             /*------------------------------*/
             /*   FILE EXISTENCE CHECK       */
             /*------------------------------*/
             IF         (&AFILE *NE &@AFILE) DO
             CHGVAR     VAR(&@AFILE) VALUE(&AFILE)
             CHGVAR     VAR(&WCHK) VALUE(' ')
             CHGVAR     VAR(&WER1) VALUE(' ')

             CHKOBJ     OBJ(&AFILE) OBJTYPE(*FILE)
             MONMSG    (CPF9801 CPF3275) *N GOTO STP4
             CHGVAR     VAR(&WER1) VALUE('Y')
             ENDDO

 STP4:       IF         (&WER1 *NE ' ') DO
             IF         ((&WCHK *NE 'C') *OR (&IN16 *NE '1')) DO
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&WCHK) VALUE('C')
             CHGVAR     VAR(&AERR) VALUE('WARNIN')
             CHGVAR     VAR(&MSG) VALUE('THE OBJECT EXIST. F16 FOR +
                          GOING AHEAD.')
             GOTO       STP1
             ENDDO
             ENDDO

             CHGVAR     VAR(&@FL1) VALUE(%SST(&AFILE 1 1))
             CHGVAR     VAR(&@FL42) VALUE(%SST(&AFILE 4 2))

             CHGVAR     VAR(&WSRC) VALUE('        ')
             CHGVAR     VAR(&WSLIB) VALUE('HSRC1   ')
             CHGVAR     VAR(&WOLIB) VALUE('        ')

             IF         COND(&WKUBN *EQ 'O') THEN(GOTO CMDLBL(@OLD2))

             CHGVAR     VAR(&WSRC) VALUE('QDDSSRC ')
             CHGVAR     VAR(&WOLIB) VALUE('HFILE1    ')

             IF         COND(&WFILE6 *EQ 'D') THEN(DO)
             CHGVAR     VAR(&WSRC) VALUE('QDSPSRC ')
             CHGVAR     VAR(&WOLIB) VALUE('HOBJ1     ')
             ENDDO

             IF         COND(&WFILE6 *EQ 'V') THEN(DO)
             CHGVAR     VAR(&WSRC) VALUE('QPRTSRC ')
             CHGVAR     VAR(&WOLIB) VALUE('HOBJ1     ')
             ENDDO

             IF         COND(&WFILE6 *EQ 'W') THEN(DO)
             CHGVAR     VAR(&WOLIB) VALUE('HWFILE1   ')
             ENDDO
             IF         COND(&WFILE6 *EQ 'F') THEN(DO)
             CHGVAR     VAR(&WOLIB) VALUE('HWFILE1   ')
             ENDDO
             IF         COND(&WFILE6 *EQ 'N') THEN(DO)
             CHGVAR     VAR(&WOLIB) VALUE('HWFILE1   ')
             ENDDO

             GOTO       CMDLBL(@DLTF)
@OLD2:
             /*---------------*/
             /*..SOURCE FILE..*/
             /*---------------*/
             /*-------------------------------*/
             /*  ..PP.PL.TP.TL.NP.NL.WP.WL..  */
             /*-------------------------------*/
             IF         COND((&@FL42 *EQ 'PP') *OR (&@FL42 *EQ 'PL') +
                          *OR (&@FL42 *EQ 'TP') *OR (&@FL42 *EQ +
                          'TL') *OR (&@FL42 *EQ 'NP') *OR (&@FL42 +
                          *EQ 'NL') *OR (&@FL42 *EQ 'WP') *OR +
                          (&@FL42 *EQ 'WL') *OR +
                          (&@FL42 *EQ 'AP') *OR +
                          (&@FL42 *EQ 'AL') *OR +
                          (&@FL42 *EQ 'EP') *OR (&@FL42 *EQ 'EL')) THEN(DO)

     /**JW4  CHGVAR     VAR(&WSRC) VALUE(%SST(&AFILE 1 1) *CAT +     **/
     /**                  'DDSSRC ')                                 **/
             CHGVAR     VAR(&WSRC) VALUE('ADDSSRC')
             ENDDO

             /*----------*/
             /*  ..PR..  */
             /*----------*/
             IF         COND(&@FL42 *EQ 'PR') THEN(DO)

             CHGVAR     VAR(&WSRC) VALUE('APRTSRC')

             ENDDO

             /*-----------*/
             /*  ..DSP..  */
             /*-----------*/
             IF         COND(&@FL42 *EQ 'PW') THEN(DO)

             CHGVAR     VAR(&WSRC) VALUE('ADDSSRC')

             ENDDO

             /*-----------------------*/
             /*  ..OBJECT LIBRARY ..  */
             /*-----------------------*/
             /*-------------------*/
             /*  ..PP.PL.TP.TL..  */
             /*-------------------*/
             IF         COND((&@FL42 *EQ 'PP') *OR (&@FL42 *EQ 'PL') +
                          *OR (&@FL42 *EQ 'TP') *OR (&@FL42 *EQ 'TL') +
                          *OR (&@FL42 *EQ 'EP') *OR (&@FL42 *EQ 'EL') +
                          *OR (&@FL42 *EQ 'AP') *OR (&@FL42 *EQ 'AL')) +
                          THEN(DO)

             CHGVAR     VAR(&WOLIB) VALUE('HFILE1  ')

             IF         (&USE5 *EQ 'TEST ') DO
             CHGVAR     VAR(&WOLIB) VALUE('TFILE1  ')
             ENDDO

             ENDDO

             /*-------------------*/
             /*  ..NP.NL.WP.WL..  */
             /*-------------------*/
             IF         COND((&@FL42 *EQ 'NP') *OR (&@FL42 *EQ 'NL') +
                          *OR (&@FL42 *EQ 'WP') *OR (&@FL42 *EQ +
                          'WL')) THEN(DO)

             CHGVAR     VAR(&WOLIB) VALUE('HWFILE1 ')

             IF         (&USE5 *EQ 'TEST ') DO
             CHGVAR     VAR(&WOLIB) VALUE('TWFILE1 ')
             ENDDO

             ENDDO

             /*-------------*/
             /*  ..PR.PW..  */
             /*-------------*/
             IF         COND((&@FL42 *EQ 'PR') *OR (&@FL42 *EQ +
                          'PW')) THEN(DO)

             CHGVAR     VAR(&WOLIB) VALUE('HOBJ1   ')

             IF         (&USE5 *EQ 'TEST ') DO
             CHGVAR     VAR(&WOLIB) VALUE('TOBJ1   ')
             ENDDO

             ENDDO
@DLTF:
             /*------------*/
             /*  ..DLTF..  */
             /*------------*/
             DLTF       FILE(&AFILE)
             MONMSG     MSGID(CPF2105)

             MONMSG     MSGID(CPF3202 CPF0610) EXEC(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&AERR) VALUE('ABNRML')
             CHGVAR     VAR(&MSG) VALUE('FILE OPENS, SO THAT IT CAN +
                          NOT BE DELETED ')
             GOTO       STP1
             ENDDO

             MONMSG     MSGID(CPF3219) EXEC(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&AERR) VALUE('ABNRML')
             CHGVAR     VAR(&MSG) VALUE('LOGICAL F WHICH ACCOMPANIES +
                          WITH PHYSICAL FILE SHOULD DELETE ')
             GOTO       STP1
             ENDDO

             IF         (&PSYS *EQ 'IAF     ') DO
             IF         (&USE5 *EQ 'QPGMR') DO

             IF         (&WOLIB *EQ 'HOBJ1   ') DO
             CHGVAR     VAR(&TOLIB) VALUE('TOBJ1   ')
             ENDDO

             IF         (&WOLIB *EQ 'HFILE1  ') DO
             CHGVAR     VAR(&TOLIB) VALUE('TFILE1  ')
             ENDDO

             IF         (&WOLIB *EQ 'HWFILE1 ') DO
             CHGVAR     VAR(&TOLIB) VALUE('TWFILE1 ')
             ENDDO


             DLTF       FILE(&TOLIB/&AFILE)
             MONMSG     MSGID(CPF2105)

             MONMSG     MSGID(CPF3202 CPF0610) EXEC(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&AERR) VALUE('ABNRML')
             CHGVAR     VAR(&MSG) VALUE('( TEST LIBRARY )  FILE +
                          OPENS, SO THAT IT CAN NOT BE DELETED ')
             GOTO       STP1
             ENDDO

             MONMSG     MSGID(CPF3219) EXEC(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&AERR) VALUE('ABNRML')
             CHGVAR     VAR(&MSG) VALUE('( TEST LIBRARY )  LOGICAL F +
                          WHICH ACCOMPANIES WITH PHYSICAL FILE +
                          SHOULD DELETE ')
             GOTO       STP1
             ENDDO
             ENDDO
             ENDDO

             /*------------*/
             /*  ..JOBQ..  */
             /*------------*/
             IF         (&AJOBQ *EQ '0') DO
             CALL       PGM(AJFCJ4) PARM(&WSLIB &WOLIB &WSRC &AFILE +
                          &AKSN &ALIN &AR &PRTG &WSIZ1 &WSIZ2 +
                          &WSIZ3 &WRECD &WER2 &WER3 &WTXT)

             IF         (&WER2 *EQ 'E') DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN05) VALUE('1')
             CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&AERR) VALUE('ABNRML')
             CHGVAR     VAR(&MSG) VALUE('IT IS ABNORMAL THAT BEING +
                          COMPILED ')
             GOTO       STP1
             ENDDO

             IF         (&WER3 *EQ 'E') DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN05) VALUE('1')
             CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&AERR) VALUE('ABNRML')
             CHGVAR     VAR(&MSG) VALUE('THE SOURCE FILE CANNOT +
                          FOUND ')
             GOTO       STP1
             ENDDO

             IF         (&PSYS *EQ 'IAF     ') DO
             IF         (&USE5 *EQ 'QPGMR') DO

             IF         ((&WER2 *EQ ' ') *AND (&WER3 *EQ ' ')) DO

             CHGVAR     VAR(&WER2) VALUE(' ')
             CHGVAR     VAR(&WER3) VALUE(' ')

             CALL       PGM(AJFCK4) PARM(&WSLIB &WOLIB &WSRC &AFILE +
                          &AKSN &ALIN &AR &PRTG &WSIZ1 &WSIZ2 +
                          &WSIZ3 &WRECD &WER2 &WER3 &WTXT)

             IF         (&WER2 *EQ 'E') DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN05) VALUE('1')
             CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&AERR) VALUE('ABNRML')
             CHGVAR     VAR(&MSG) VALUE('(TEST LIBRARY)  COMPILING +
                          FAILED ')
             GOTO       STP1
             ENDDO

             IF         (&WER3 *EQ 'E') DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN03) VALUE('1')
             CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN05) VALUE('1')
             CHGVAR     VAR(&IN06) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&AERR) VALUE('ABNRML')
             CHGVAR     VAR(&MSG) VALUE('(TEST LIBRARY)  THE FILE IS +
                          NOT EXIST ')
             GOTO       STP1
             ENDDO
             ENDDO
             ENDDO
             ENDDO

             CHGVAR     VAR(&AFILE) VALUE('       ')
             CHGVAR     VAR(&AKSN) VALUE('N')
             CHGVAR     VAR(&ALIN) VALUE('6')
             CHGVAR     VAR(&AR) VALUE('H')
             CHGVAR     VAR(&AJOBQ) VALUE('0')
             CHGVAR     VAR(&@AFILE) VALUE('       ')
             CHGVAR     VAR(&IN99) VALUE('0')
             GOTO       END
             ENDDO

             IF         (&AJOBQ *EQ '1') DO
             SBMJOB     JOB(JOBQ1) JOBD(QBATCH1) JOBQ(JOBQ1) +
                          RQSDTA('CALL PGM(AJFCJ4) PARM(''' *CAT +
                          &WSLIB *CAT ''' ''' *CAT &WOLIB *CAT ''' +
                          ''' *CAT &WSRC *CAT ''' ''' *CAT &AFILE +
                          *CAT ''' ''' *CAT &AKSN *CAT ''' ''' *CAT +
                          &ALIN *CAT ''' ''' *CAT &AR *CAT ''' ''' +
                          *CAT &PRTG *CAT ''' ''' *CAT &WSIZ1 *CAT +
                          ''' ''' *CAT &WSIZ2 *CAT ''' ''' *CAT +
                          &WSIZ3 *CAT ''' ''' *CAT &WRECD *CAT ''' +
                          ''' *CAT &WER2 *CAT ''' ''' *CAT &WER3 +
                          *CAT ''' ''' *CAT &WTXT *CAT ''')')

             IF         (&PSYS *EQ 'IAF     ') DO
             IF         (&USE5 *EQ 'QPGMR') DO

             IF         ((&WER2 *EQ ' ') *AND (&WER3 *EQ ' ')) DO

             CHGVAR     VAR(&WER2) VALUE(' ')
             CHGVAR     VAR(&WER3) VALUE(' ')

             SBMJOB     JOB(JOBQ1) JOBD(QBATCH1) JOBQ(JOBQ1) +
                          RQSDTA('CALL PGM(AJFCK4) PARM(''' *CAT +
                          &WSLIB *CAT ''' ''' *CAT &WOLIB *CAT ''' +
                          ''' *CAT &WSRC *CAT ''' ''' *CAT &AFILE +
                          *CAT ''' ''' *CAT &AKSN *CAT ''' ''' *CAT +
                          &ALIN *CAT ''' ''' *CAT &AR *CAT ''' ''' +
                          *CAT &PRTG *CAT ''' ''' *CAT &WSIZ1 *CAT +
                          ''' ''' *CAT &WSIZ2 *CAT ''' ''' *CAT +
                          &WSIZ3 *CAT ''' ''' *CAT &WRECD *CAT ''' +
                          ''' *CAT &WER2 *CAT ''' ''' *CAT &WER3 +
                          *CAT ''' ''' *CAT &WTXT *CAT ''')')
             ENDDO
             ENDDO
             ENDDO
             ENDDO

             IF         (&AJOBQ *EQ '2') DO
             SBMJOB     JOB(JOBQ2) JOBD(QBATCH2) JOBQ(JOBQ2) +
                          RQSDTA('CALL PGM(AJFCJ4) PARM(''' *CAT +
                          &WSLIB *CAT ''' ''' *CAT &WOLIB *CAT ''' +
                          ''' *CAT &WSRC *CAT ''' ''' *CAT &AFILE +
                          *CAT ''' ''' *CAT &AKSN *CAT ''' ''' *CAT +
                          &ALIN *CAT ''' ''' *CAT &AR *CAT ''' ''' +
                          *CAT &PRTG *CAT ''' ''' *CAT &WSIZ1 *CAT +
                          ''' ''' *CAT &WSIZ2 *CAT ''' ''' *CAT +
                          &WSIZ3 *CAT ''' ''' *CAT &WRECD *CAT ''' +
                          ''' *CAT &WER2 *CAT ''' ''' *CAT &WER3 +
                          *CAT ''' ''' *CAT &WTXT *CAT ''')')

             IF         (&PSYS *EQ 'IAF     ') DO
             IF         (&USE5 *EQ 'QPGMR') DO

             IF         ((&WER2 *EQ ' ') *AND (&WER3 *EQ ' ')) DO

             CHGVAR     VAR(&WER2) VALUE(' ')
             CHGVAR     VAR(&WER3) VALUE(' ')

             SBMJOB     JOB(JOBQ2) JOBD(QBATCH2) JOBQ(JOBQ2) +
                          RQSDTA('CALL PGM(AJFCK4) PARM(''' *CAT +
                          &WSLIB *CAT ''' ''' *CAT &WOLIB *CAT ''' +
                          ''' *CAT &WSRC *CAT ''' ''' *CAT &AFILE +
                          *CAT ''' ''' *CAT &AKSN *CAT ''' ''' *CAT +
                          &ALIN *CAT ''' ''' *CAT &AR *CAT ''' ''' +
                          *CAT &PRTG *CAT ''' ''' *CAT &WSIZ1 *CAT +
                          ''' ''' *CAT &WSIZ2 *CAT ''' ''' *CAT +
                          &WSIZ3 *CAT ''' ''' *CAT &WRECD *CAT ''' +
                          ''' *CAT &WER2 *CAT ''' ''' *CAT &WER3 +
                          *CAT ''' ''' *CAT &WTXT *CAT ''')')
             ENDDO
             ENDDO
             ENDDO
             ENDDO

 END:        ENDPGM
