             /** EJKC59 ********************************/
             /*  B2B_S  OBSERVATION FOR ABNORMAL END   */
             /*  T.SAKAKI            2016.10.12        */
             /******************************************/
             DCL        VAR(&HANT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PMSGQ) TYPE(*CHAR) LEN(10) +
                          VALUE('QSYSOPR   ')
             DCL        VAR(&PKINP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PKOUT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PTTL)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&PMSG)  TYPE(*CHAR) LEN(256)
             DCL        VAR(&JYKB) TYPE(*CHAR) LEN(2)
             DCL        VAR(&LIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DKBN) TYPE(*CHAR) LEN(3)
             DCL        VAR(&SAKI) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ERDT) TYPE(*CHAR) LEN(32)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&ERDT2) TYPE(*CHAR) LEN(8)
             DCL        VAR(&ERTM2) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PMSG2) TYPE(*CHAR) LEN(80)

 STP1:
     /*-------------------------------------*/
     /* PULL OUT EDI DATA THAT HAS AN ERROR */
     /*-------------------------------------*/
             CALL       PGM(EJKR59) PARM(&JYKB &LIBL &FILE &DKBN +
                          &SAKI &ERDT)
             IF         COND(&FILE *EQ '          ') THEN(GOTO +
                          CMDLBL(STP2))

        /* NOTIFICATION BY E-MAIL */
             CHGVAR     VAR(&PTTL) VALUE('B2B_E GOT AN ERROR OF +
                          SENDING ' *CAT &JYKB *TCAT '-' *TCAT &DKBN)
             CHGVAR     VAR(&PMSG) VALUE(&LIBL *TCAT '/' *TCAT &FILE +
                          *TCAT ' GOT AN ERROR ' *CAT '"' *TCAT +
                          &ERDT *TCAT '" WHILE SENDING TO ' *CAT +
                          &SAKI *TCAT ', PLEASE SEE EJKPL52 TO +
                          CHECK MORE DETAIL. ENTER "G" TO CONTINUE')
        /* NOTIFICATION BY E-MAIL */
             CALL       PGM(MSGC10) PARM(&PTTL &PMSG)

        /* SEND MESSAGE */
             CHGVAR     VAR(&PKINP) VALUE('G    ')
             CHGVAR     VAR(&PKOUT) VALUE(' ')
             CALL       PGM(APLC50) PARM(&PMSG &PKINP &PMSGQ &PKOUT)

 /* IF ERROR HAPPENS, PLEASE CHECK EJKPP50 */
 /* IF DATA IS NOT NEEDED -> ENTER 'D' TO DJSKJY */
 /* IF DATA HAS BEEN ENDED  -> ENTER END DATE TO DJKNHZ */


 STP2:
     /*-------------------------------------*/
     /* PULL OUT EDI DATA THAT HAS AN ERROR */
     /*-------------------------------------*/
             RTVMBRD    FILE(WEEKDLT/EJSEP01) NBRCURRCD(&REC)
             MONMSG     MSGID(CPF0000)
             IF         COND(&REC *NE 0) THEN(DO)

             OVRDBF     FILE(EJSEP01) TOFILE(WEEKDLT/EJSEP01)
             CALL       PGM(EJKR5A) PARM(&ERDT2 &ERTM2 &PMSG2)

        /* NOTIFICATION BY E-MAIL */
             CHGVAR     VAR(&PTTL) VALUE(' ')
             CHGVAR     VAR(&PTTL) VALUE('HULFT SEND GOT AN ERROR ' +
                          *CAT &ERDT2 *TCAT '-' *TCAT &ERTM2)
             CHGVAR     VAR(&PMSG) VALUE(' ')
             CHGVAR     VAR(&PMSG) VALUE(&PMSG2)

             CALL       PGM(MSGC10) PARM(&PTTL &PMSG)

        /* SEND MESSAGE */
             SNDMSG     MSG(&PMSG2) TOMSGQ(QSYSOPR)

             ENDDO

 @END:
             ENDPGM
