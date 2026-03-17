             PGM
             /** ABHC20 *******************************************/
             /* INTRA-PROCESS KANBAN COMMUNICATION / DISKETT      */
             /*                          PUBLICATION PROCESS      */
             /* A.IDOTA                         1995.01.31        */
             /*                                                   */
             /* TCHK1 02/04/10 CHG ERROR MESSAGE                  */
             /* JW1   2019.07.17   CHG ERROR MESSAGE              */
             /* JW2   2025.09.30   REMOVE SELECTION "2" FOR &PTKB */
             /*****************************************************/
             DCLF       FILE(ABHPW20)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FIL1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FIL2) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL3) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FIL4) TYPE(*CHAR) LEN(8)
       /*JW2 DCL        VAR(&CK)   TYPE(*CHAR) LEN(1)    ****/
             DCL        VAR(&PCHEK) TYPE(*CHAR) LEN(1)

       /*JW1 DCL        VAR(&DCK2) TYPE(*CHAR) LEN(1)    ****/
             DCL        VAR(&RTN2) TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

/* CHECK OTHER USER IS USING  (JW1) ================================*/
             CALL       PGM(CHKC45) PARM('ABHC20' 'ABHC20' 'Y' 'CHK' &RTN2)
             IF         COND(&RTN2 *NE ' ') THEN(GOTO @ENDP2)
/* =================================================================*/

             CHGJOB     SWS(00000000)
             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)
             CHGVAR     VAR(&PTKB)  VALUE('1')
             CHGVAR     VAR(&PKOJO) VALUE('0111')

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(ABHPW201)

      /*JW2**IF         COND(&IN01 *EQ '1' *OR &CK *EQ '1') +     ***/

             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(END))


             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN04) VALUE('0')
             CHGVAR     VAR(&IN99) VALUE('0')

             IF         COND(&PTKB *NE '1') THEN(DO)
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
/*JW2*/      CHGVAR     VAR(&MSG) VALUE('SELECT "1"')
             GOTO       STP1
             ENDDO

     /*JW2** IF         (&PTKB *NE ' ') DO                                **/
     /**     IF         COND(&PTKB *NE '1' *AND &PTKB *NE '2') THEN(DO)   **/
     /**     CHGVAR     VAR(&IN02) VALUE('1')                             **/
     /**     CHGVAR     VAR(&IN99) VALUE('1')                             **/
     /**     CHGVAR     VAR(&MSG) VALUE('PUBLICATION INSTRUCTION IS +     **/
     /**                  <1, 2>')                                        **/
     /**     GOTO       STP1                                              **/
     /**     ENDDO                                                        **/
     /**     ENDDO                                                        **/

             IF         COND(&PKOJO *NE '0111') THEN(DO)
             CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')

      /***** CHGVAR     VAR(&MSG) VALUE('PUBLICATION DEPARTMENT ISN')     **/
/*JW2*/      CHGVAR     VAR(&MSG) VALUE('PUBLICATION DEPT MUST BE "0111"')

             GOTO       STP1
             ENDDO

      /*JW2**IF         (&IN05 *EQ '0') GOTO STP1     ****/

/*JW2*/      IF         (&IN05 *EQ '0') THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('PRESS F5 TO CREATE KANBAN...')
             GOTO       STP1
             ENDDO

             CHGVAR     VAR(&FIL1) VALUE('ABHWP' *CAT &PKOJO *CAT '1')
             CHGVAR     VAR(&FIL2) VALUE('ABHWP' *CAT &PKOJO)
             CHGVAR     VAR(&FIL3) VALUE('ABHWP' *CAT &PKOJO *CAT '2')
             CHGVAR     VAR(&FIL4) VALUE('AADT' *CAT &PKOJO)

             CALL       PGM(ABHR25) PARM(&FIL4 'C')
             IF         (%SWITCH(XXXXXXX1)) DO
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR     VAR(&MSG) VALUE('DATA OF LAST TIME HAD NOT +
                          PROCESSED BY COMMUNICATION')
             GOTO       STP1
             ENDDO

             CALL       PGM(ABHR25) PARM(&FIL4 'H')

             DLTF       FILE(&FIL1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FIL1) RCDLEN(1024) +
                          OPTION(*NOLIST) SIZE(3000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(OUTPUT1) TOFILE(&FIL1)
             CALL       PGM(ABHR20) PARM(' ' ' ' &PKOJO)
             DLTOVR     FILE(OUTPUT1)

/* KANBAN REPUBLICATION DATA ADD */
             CALL       PGM(ABHR24) PARM(&PKOJO &PCHEK)
             IF         COND(&PCHEK *EQ '*') THEN(DO)
             IF         COND(&PKOJO *EQ '0111') THEN(DO)
             CPYF       FROMFILE(ABHWPIA) TOFILE(&FIL1) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             CLRPFM     FILE(ABHWPIA)
             CPYF       FROMFILE(ABHWPIB) TOFILE(&FIL1) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             CLRPFM     FILE(ABHWPIB)
             ENDDO
             ENDDO

             IF         (%SWITCH(0XXXXXXX)) DO
             DLTF       FILE(&FIL1)
             CALL       PGM(ABHR25) PARM(&FIL4 'D')
             CHGVAR     VAR(&IN02) VALUE('1')
             CHGVAR     VAR(&IN04) VALUE('1')
             CHGVAR     VAR(&IN99) VALUE('1')
/* TCHK1 */  CHGVAR     VAR(&MSG) VALUE('THERE IS NO DATA')
             GOTO       STP1
             ENDDO

             DLTF       FILE(&FIL2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FIL2) RCDLEN(1024) +
                          OPTION(*NOLIST) SIZE(3000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/&FIL1)) +
                          OUTFILE(&WLIB/&FIL2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(ABHS20) +
                          OPTION(*NOPRT)
             DLTF       FILE(&FIL1)

             DLTF       FILE(&FIL3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FIL3) RCDLEN(1024) +
                          OPTION(*NOLIST) SIZE(3000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(OUTPUT1) TOFILE(&FIL2)
             OVRDBF     FILE(OUTPUT2) TOFILE(&FIL3)
             CALL       PGM(ABHR21) PARM(&PKOJO)
             DLTF       FILE(&FIL2)
             DLTOVR     FILE(OUTPUT1)
             DLTOVR     FILE(OUTPUT2)

             DLTF       FILE(&FIL4)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FIL4) RCDLEN(1024) +
                          OPTION(*NOLIST) SIZE(3000 1000 2) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(OUTPUT1) TOFILE(&FIL3)
             OVRDBF     FILE(OUTPUT2) TOFILE(&FIL4)
             CALL       PGM(ABHR22)

             CALL       PGM(ABHR25) PARM(&FIL4 ' ')

         /* DLTF FILE(&FIL3) */
             DLTOVR     FILE(OUTPUT1)
             DLTOVR     FILE(OUTPUT2)

 /*** JW2    IF         (&PTKB *EQ '2') DO                             ***/
 /***STEP01: SNDPGMMSG  MSG('( G )  DUETO RELEASED DATA PRESENCE +     ***/
 /***                     PROCESS KANBAN RELEASE WITH RELEASE PC. < +  ***/
 /***                     CONFIRMATION OK - G >') TOMSGQ(&WSID) +      ***/
 /***                     MSGTYPE(*INQ) KEYVAR(&MBAN)                  ***/
 /***        RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +       ***/
 /***                     MSG(&KOTAE)                                  ***/
 /***        IF         COND((&KOTAE = 'G') *OR (&KOTAE = 'g')) +      ***/
 /***                     THEN(GOTO CMDLBL(STEP02))                    ***/
 /***        GOTO       STEP01                                         ***/
 /***STEP02:  CALL       PGM(ABHR25) PARM(&FIL4 'E')                   ***/
 /***        ENDDO                                                     ***/

 /*JW1 DELETED  END:  IF         COND(&DCK2 *EQ '1') THEN(DO) */
 /*                   DLTDTAARA  DTAARA(ABHACT)               */
 /*                   ENDDO                                   */

 END:
             CALL       PGM(CHKC45) PARM('ABHC20' 'ABHC20' 'N' '' '')
 /*JW1*/
 @ENDP2:
             ENDPGM
