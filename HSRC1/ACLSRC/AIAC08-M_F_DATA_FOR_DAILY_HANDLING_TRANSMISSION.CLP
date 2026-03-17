             PGM
             /** AIAC08 ****************************************/
             /* || M/F DATA FOR DAILY HANDLING TRANSMISSION || */
             /* I-HASADA                        86.11.21       */
             /* -------------------------------                */
             /* JW1    2023.06.30 CHG ERROR MSG                */
             /**************************************************/
             DCL        VAR(&RPY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)

 /*JW1*/     DCL        VAR(&MSG1 ) TYPE(*CHAR) LEN(30) VALUE(' ')
             DCL        VAR(&MSG2 ) TYPE(*CHAR) LEN(30) VALUE(' ')
             DCL        VAR(&MSG3 ) TYPE(*CHAR) LEN(30) VALUE(' ')

             /*------------------------------------------------*/
             /* || M/F DATA FOR DAILY HANDLING TRANSMISSION || */
             /* CHECK                                        */
             /*------------------------------------------------*/
 STP1:       CHGJOB     SWS(00000000)

             CALL       PGM(AALR01)
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDUSRMSG  MSG('ERROR AT PGM (AALR01)! Enter R:RETRY or +
                          C:Cancel. (AIAC08)') VALUES('R' 'C') +
                          MSGTYPE(*INQ) TOMSGQ(QSYSOPR) MSGRPY(&RPY)
             IF         COND((&RPY = 'R') *OR (&RPY = 'r')) +
                          THEN(GOTO CMDLBL(STP1))
             RETURN
             ENDDO

             IF         COND(%SWITCH(XXXXX1XX)) THEN(DO)

/** STP2:    SNDPGMMSG  MSG('( G ) A-PICS M/F CONTROL FILE IS NOT +      **/
/**JW1                    TRANSMITTED. RECEIVE A-PICS DAILY MASTER, +    **/
/**                       THEN EXECUTE AGAIN.(AIAC08)') +                **/
/**                       TOMSGQ(QSYSOPR) MSGTYPE(*INQ) KEYVAR(&MBAN)    **/
/**          RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +         **/
/**                       MSG(&KOTE)                                     **/
/**          IF         COND((&KOTE *NE 'G') *AND (&KOTE *NE 'g')) +     **/
/**                       THEN(GOTO CMDLBL(STP2))                        **/

             CHGVAR VAR(&MSG1) VALUE('APICS DATA WAS NOT TRANSMITTED')
             CHGVAR VAR(&MSG2) VALUE('RECEIVE APICS DAILY MASTER!   ')
             CHGVAR VAR(&MSG3) VALUE('THEN TRY AGAIN. (AIAC80)      ')
             CALL       PGM(UTLC963) PARM(&MSG1 &MSG2 &MSG3)

             RETURN
             ENDDO

             CALL       PGM(AIAR08) PARM(' ')
             CALL       PGM(ALDC10)


             ENDPGM
