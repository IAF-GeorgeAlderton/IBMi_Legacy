             PGM        PARM(&USER &DIRA &DIRB)
   /*= SPLC80 =============================================================*/
   /*  GET DIRECTORY BY USER ID                                            */
   /*  J.WATANABE     2023.02.24                                           */
   /*  -----------------------------                                       */
   /*  PARAMETERS                                                          */
   /*  1. &USER (10A) = USER ID                                            */
   /*  2. &DIRA (100A)= DIRECTORY QNTC  (ADDRESS FOR AS400)                */
   /*  2. &DIRB (100A)= DIRECTORY J/L/K (ADDRESS FOR WINDOWS)              */
   /*  -----------------------------                                       */
   /*  EX.                                                                 */
   /*  &USER   ='I0777'                                                    */
   /*  &DIRA   ='/QNTC/IAF-AS400-FILE/AS400-TRANS/PC/DOWNLOAD/I0777/'      */
   /*  &DIRB   ='PC/AS400 XFER PC(J:)/DOWNLOAD/I0777/' - WINDOWS DISPLAY   */
   /*======================================================================*/

             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&DIRA)  TYPE(*CHAR) LEN(100)
             DCL        VAR(&DIRB)  TYPE(*CHAR) LEN(100)

             DCL        VAR(&FILE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&FIL5)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&YYMM)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&DEPT)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&DEPN)  TYPE(*CHAR) LEN(15)
             DCL        VAR(&DIR1)  TYPE(*CHAR) LEN(100)
             DCL        VAR(&DIR2)  TYPE(*CHAR) LEN(100)
             DCL        VAR(&DIRN)  TYPE(*CHAR) LEN(20)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS  )  TYPE(*CHAR) LEN(10)

             DCL        VAR(&DATE6) TYPE(*CHAR) LEN(6)
             DCL        VAR(&I2   ) TYPE(*CHAR) LEN(2)

 RUN:
             RTVJOBA    JOB(&WS  )
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&DATE6)

             CHGVAR     VAR(&DIRA) VALUE(' ')
             CHGVAR     VAR(&DIRB) VALUE(' ')
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
                          VALUE('/QNTC/IAF-AS400-FILE/AS400-TRANS/' +
                          *TCAT &DEPN *TCAT '/Download/' *CAT &USER)
             CHGVAR     VAR(&DIR2) VALUE(&DEPN *TCAT '/' *CAT &DIRN +
                          *TCAT '/Download/' *TCAT &USER)
                        ENDDO
      /* &DEPT=5         */
             IF         COND(&DEPT *EQ '5') THEN(DO)
             CHGVAR     VAR(&DIR1) +
                          VALUE('/QNTC/IAF-AS400-FILE/AS400-TRANS/' +
                          *TCAT &DEPN *TCAT '/Download/AUTO +
                          SETTING/' *CAT &YYMM)
             CHGVAR     VAR(&DIR2) VALUE(&DEPN *TCAT '/' *CAT &DIRN +
                          *TCAT '/Download/AUTO SETTING/' *CAT &YYMM)
                        ENDDO
      /* &DEPT=6         */
             IF         COND(&DEPT *EQ '6') THEN(DO)
             CHGVAR     VAR(&DIR1) +
                          VALUE('/QNTC/IAF-AS400-FILE/AS400-TRANS/' +
                          *TCAT &DEPN *TCAT '/Download/AS400/OUTSRC')
             CHGVAR     VAR(&DIR2) VALUE(&DEPN *TCAT '/' *CAT &DIRN +
                          *TCAT '/Download/AS400/OUTSRC')
                        ENDDO

             CRTDIR     DIR(&DIR1)
             MONMSG     MSGID(CPFA0A0)
             MONMSG     MSGID(CPFA0A9)

             CHGVAR     VAR(&DIRA) VALUE(&DIR1 *TCAT '/')
             CHGVAR     VAR(&DIRB) VALUE(&DIR2 *TCAT '/')

             DLTOVR     FILE(*ALL)
             ENDPGM
