             PGM        PARM(&PIPGMN &COUT &POSTTS)
             /** EJKC70 ********************************/
             /* CHECK PREVIOUS RECEPTION OF HULFT      */
             /*    **ORIGINAL IS JK920C FROM ASJ**     */
             /*  T.SAKAKI            2016.10.13        */
             /**************************** JK910C ***/
             DCL        VAR(&PIPGMN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POUSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&POKONA) TYPE(*CHAR) LEN(15)
             DCL        VAR(&POSTTS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&COUT)   TYPE(*DEC)  LEN(3)
             DCL        VAR(&DLY)    TYPE(*DEC)  LEN(3)
             DCL        VAR(&PTTL)   TYPE(*CHAR) LEN(50)
             DCL        VAR(&PMSG)   TYPE(*CHAR) LEN(256)
             DCL        VAR(&PMSGQ) TYPE(*CHAR) LEN(10) +
                          VALUE('QSYSOPR   ')
             DCL        VAR(&PKINP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PKOUT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID)

 STEP01:
          /*----------------------------------------------------*/
          /* CHECK MULTIPLE PROCESS CONTROL FILE                */
          /*     POSTTS = '1'  OK- CAN PROCESS                  */
          /*----------------------------------------------------*/
             CALL       PGM(APLR85) PARM(&PIPGMN &POUSID &POKONA +
                          &POSTTS)
             IF         COND(&POSTTS *EQ '1') THEN(DO)
             GOTO       @END
             ENDDO
          /*----------------------------------------------------*/
          /*     DLY                                            */
          /*----------------------------------------------------*/
             CHGVAR     VAR(&DLY)   VALUE(&DLY + 1)
             IF         COND(&DLY *LE &COUT) THEN(DO)
                        DLYJOB     DLY(1)
                        GOTO CMDLBL(STEP01)
             ENDDO

          /*----------------------------------------------------*/
          /* SEND MESSAGE                                       */
          /*----------------------------------------------------*/

          /***  SKIP TO END ***/
                        GOTO CMDLBL(@END)
          /***  SKIP TO END ***/

             IF         COND(&POSTTS *EQ '2') THEN(DO)
             CHGVAR     VAR(&PTTL) VALUE('HULFT_SND GOT AN ERROR +
                          WHILE SENDING ' *TCAT &PIPGMN)
             CHGVAR     VAR(&PMSG) VALUE('HULFT_SND WAS FAILED. +
                          PLEASE CHECK AND TAKE CARE OF IT. FILE IS  +
                          ' *TCAT &PIPGMN *TCAT ' -> AND +
                          THEN,UNLOCK MULTIPLE PROCESS CONTROL FILE +
                          BY CALL APLR84 AND REPLY TO QSYSOPR WITH +
                          "G" TO RETRY')
          /* BY E-MAIL */
             CALL       PGM(MSGC10) PARM(&PTTL &PMSG)

             CHGVAR     VAR(&PKINP) VALUE('G    ')
             CHGVAR     VAR(&PKOUT) VALUE(' ')
             CALL       PGM(APLC50) PARM(&PMSG &PKINP &PMSGQ &PKOUT)
             GOTO       CMDLBL(@END)
             ENDDO

@END:        ENDPGM
