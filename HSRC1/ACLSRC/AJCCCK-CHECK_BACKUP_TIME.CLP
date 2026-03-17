             PGM        PARM(&JIKN)
             /** AJCCCK ************************************************/
             /*  CHECK BACKUP TIME                                     */
             /* ------------------------------------------------------ */
             /*  JW    2026.01.26 CHG SKIP CHECKING TIME               */
             /**********************************************************/

             DCL        VAR(&JIKN) TYPE(*CHAR) LEN(6)

             DCL        VAR(&NOWT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&CHKT) TYPE(*DEC) LEN(6)

             DCL        VAR(&PMSG) TYPE(*CHAR) LEN(256)
             DCL        VAR(&PKINP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PMSGQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PKOUT) TYPE(*CHAR) LEN(1)

             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&NOWT)

   /**JW     IF         COND(&NOWT *GE '095900') THEN(DO)       **/
   /**       GOTO       CMDLBL(@CHK)                            **/
   /**       ENDDO                                              **/

             GOTO       CMDLBL(@CHK)

             IF         COND(&NOWT *LE &JIKN) THEN(DO)
             GOTO       CMDLBL(@CHK)
             ENDDO
@DLY:
             DLYJOB     RSMTIME(100000)
@CHK:
             CHKTAP     DEV(TAP01)
             MONMSG     MSGID(CPC6778) EXEC(DO)
             GOTO       CMDLBL(@OK)
             ENDDO
@NG:
/* SEND MESSAGE */
             SNDDST     TYPE(*LMSG) +
                          TOINTNET(('AS400-System@iafi.com')) +
                          DSTD('WARNING SET TAPE') LONGMSG('PLEASE +
                          SET BACKUP TAPE AND RESPOND MESSAGE IN +
                          QSYSOPR. (AJCCCK)') DOCD('WARNING AS400 +
                          BACKUP TAPE')

             CHGVAR     VAR(&PMSG) VALUE('SET TAPE AND ENTER (G)')
             CHGVAR     VAR(&PKINP) VALUE('G    ')
             CHGVAR     VAR(&PMSGQ) VALUE('QSYSOPR')
             CHGVAR     VAR(&PKOUT) VALUE(' ')

             CALL       PGM(APLC50) PARM(&PMSG &PKINP &PMSGQ &PKOUT)

@OK:
             ENDPGM
