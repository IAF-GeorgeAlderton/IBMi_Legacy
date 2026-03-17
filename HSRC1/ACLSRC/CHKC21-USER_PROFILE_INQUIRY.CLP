             PGM
             /** CHKC21 *****************************/
             /* USER PROFILE INQUIRY     　　　　 */
             /*             T.SAKAKI   2015.11.11   */
             /***************************** CHKC21 **/
             DCLF       FILE(CHKPW21)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0) VALUE(0)
             DCL        VAR(&SW1) TYPE(*CHAR) LEN(1)

    /*SEND MAIL SET */
             DCL        VAR(&TO1)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&SUB)  TYPE(*CHAR) LEN(30)
             DCL        VAR(&FNAME)  TYPE(*CHAR) LEN(30)

             RTVJOBA    JOB(&WS)

             CHGVAR     VAR(&TO1) VALUE('JONATHON.JULSON@IAFI.COM')
             CHGVAR     VAR(&SUB) VALUE('AS400 USER ID LIST')
             CHGVAR     VAR(&FNAME) VALUE('AS400_USER_ID.CSV')


 STP1:       SNDRCVF  DEV(&WS) RCDFMT(CHKPW211)
             CHGVAR     VAR(&IN99) VALUE('0')
             CHGVAR     VAR(&MSG) +
                          VALUE('                                     -
                       ')
             IF         (&IN01 *EQ '1') GOTO END

       /* INQUIRY */
             IF         (&IN12 *EQ '1') THEN(DO)

             DLTF       FILE(HWFILE1/CHKWP21)
             MONMSG     MSGID(CPF2103 CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/CHKWP21) RCDLEN(32) +
                          OPTION(*NOLIST) SIZE(1000 100 9) +
                          LVLCHK(*NO) AUT(*ALL)
             CALL       PGM(CHKR21) PARM(&SW1)

       /* SEND MAIL */
             IF         COND(&SW1 *EQ '1') THEN(DO)
             RTVMBRD    FILE(HWFILE1/CHKWP21) NBRCURRCD(&REC)
             IF         COND(&REC *GT 1) THEN(DO)

             CALL       PGM(APLC30) PARM(&TO1 &SUB 'HWFILE1' +
                          'CHKWP21' &FNAME)

             ENDDO

             ENDDO

             GOTO       STP1
             ENDDO

             IF         (&USER *EQ '          ') THEN(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR VAR(&MSG) +
                          VALUE(' INPUT USER ID ')
             GOTO       STP1
             ENDDO

             DSPUSRPRF  USRPRF(&USER)
             MONMSG     MSGID(CPF2204) EXEC(DO)
             CHGVAR     VAR(&IN99) VALUE('1')
             CHGVAR VAR(&MSG) +
                          VALUE(' NOT IN MASTER ')
             GOTO       STP1
             ENDDO
             CHGVAR     VAR(&USER) VALUE('       ')
             GOTO       STP1

 END:        ENDPGM
