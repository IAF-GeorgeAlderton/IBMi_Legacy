             PGM
             /** MRAC00 **************************************/
             /* NEW PRODUCTION CONTROL                       */
             /*    TRANCOM ITS.        2012.09.11            */
             /************************************************/
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3)     TYPE(*CHAR) LEN(3)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&P1NO1)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&P1NO2)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PCMD)    TYPE(*CHAR) LEN(2)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3)   VALUE(%SST(&WSID 1 3))
 STP00:
             CALL       PGM(MRAR00) PARM(&P1NO1 &P1NO2 &PCMD)
             IF         COND(&PCMD *EQ '01') THEN(GOTO CMDLBL(END))

        /* INPUT NEW PRODUCTION INFORMATION */
             IF         COND(&P1NO1 *EQ '1') THEN(GOTO CMDLBL(STP01))
        /* RECEIVE FROM ASJ                 */
             IF         COND(&P1NO1 *EQ '2') THEN(GOTO CMDLBL(STP50))

 STP01:
 STP011:
        /* INPUT NEW PRODUCTION INFORMATION */
             IF         COND(&P1NO2 *EQ '1') THEN(DO)
             CALL       PGM(MRAC01)
             GOTO       CMDLBL(STP00)
             ENDDO
 STP012:
        /* MODIFY INFORMATION               */
             IF         COND(&P1NO2 *EQ '2') THEN(DO)
             CALL       PGM(MRAC05)
             GOTO       CMDLBL(STP00)
             ENDDO
 STP013:
        /* QUERY  INFORMATION               */
             IF         COND(&P1NO2 *EQ '3') THEN(DO)
             CALL       PGM(MRAC08)
             GOTO       CMDLBL(STP00)
             ENDDO
 STP014:
        /* TRANSMIT TO ASJ                  */
             IF         COND(&P1NO2 *EQ '4') THEN(DO)
             CALL       PGM(MRAC11)
             GOTO       CMDLBL(STP00)
             ENDDO

 STP50:
          /*-------------------------------*/
          /* ACCEPT NEW PART DATA FROM ASJ */
          /*-------------------------------*/
             IF         COND(&P1NO2 *EQ '1') THEN(DO)
             CALL       PGM(MRAC50)
             GOTO       CMDLBL(STP00)
             ENDDO

          /*-------------------------------*/
          /* QUERY  INFORMATION            */
          /*-------------------------------*/
             IF         COND(&P1NO2 *EQ '2') THEN(DO)
             CALL       PGM(MRAC55)
             GOTO       CMDLBL(STP00)
             ENDDO

 END:
             ENDPGM
