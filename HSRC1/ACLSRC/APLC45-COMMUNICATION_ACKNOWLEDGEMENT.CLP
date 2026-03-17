             PGM        PARM(&IPAD &TCPFLG)
             /** APLC45 ***************************************/
             /*  COMMUNICATION ACKNOWLEDGEMENT                */
             /*   PARAMETER IS IP ADDRESS AS 10 DIGITS      */
             /*      T.SAKAKI              2016.10.12         */
             /*************************************** APLC45 **/
             DCL        VAR(&IPAD) TYPE(*CHAR) LEN(10)
             DCL        VAR(&IPAD2) TYPE(*CHAR) LEN(15)
             DCL        VAR(&TCPFLG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RETRY) TYPE(*DEC) LEN(1)

             /**************************************************/
             /* IT CAN BE REACHED AT LEAST ONCE -- SET TO '0'  */
             /* IT CANNOT BE REACHED 5 TIMES    -- SET TO '1'  */
             /**************************************************/

             CHGVAR     VAR(&IPAD2) VALUE(&IPAD)

             CHGVAR     VAR(&RETRY) VALUE(0)
             CHGVAR     VAR(&TCPFLG) VALUE('0')
 STP2:       IF         COND(&RETRY *NE 5) THEN(DO)
             VFYTCPCNN  RMTSYS(&IPAD2) MSGMODE(*QUIET *ESCAPE) +
                          WAITTIME(10)
             MONMSG     MSGID(TCP3202) EXEC(DO)
             CHGVAR     VAR(&TCPFLG) VALUE('1')
             GOTO       CMDLBL(#END)
             ENDDO

             MONMSG     MSGID(TCP3210) EXEC(GOTO STP1)
             GOTO       CMDLBL(#END)

 STP1:       CHGVAR     VAR(&RETRY) VALUE(&RETRY + 1)
             GOTO       STP2
             ENDDO

             CHGVAR     VAR(&TCPFLG) VALUE('1')

 #END:       ENDPGM
