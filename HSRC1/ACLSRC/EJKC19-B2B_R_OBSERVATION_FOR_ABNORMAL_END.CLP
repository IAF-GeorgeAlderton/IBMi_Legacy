             /** EJKC19 ********************************/
             /*  B2B_R  OBSERVATION FOR ABNORMAL END   */
             /*  T.SAKAKI            2016.10.24        */
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
             DCL        VAR(&ERDT) TYPE(*CHAR) LEN(30)

     /*-------------------------------------*/
     /* PULL OUT EDI DATA THAT HAS AN ERROR */
     /*-------------------------------------*/
             CALL       PGM(EJKR19) PARM(&JYKB &LIBL &FILE &DKBN +
                          &SAKI &ERDT)
             IF         COND(&FILE *EQ '          ') THEN(GOTO +
                          CMDLBL(@END))


        /* NOTIFICATION BY E-MAIL */
             CHGVAR     VAR(&PTTL) VALUE('AS/400 B2B_E GOT AN ERROR +
                          OF RECEIVING ' *CAT &JYKB *TCAT '-' *TCAT +
                          &DKBN)
             CHGVAR     VAR(&PMSG) VALUE(&LIBL *TCAT '/' *TCAT &FILE +
                          *TCAT ' GOT AN ERROR ' *CAT '"' *TCAT +
                          &ERDT *TCAT '" AFTER RECEIVED FROM ' *CAT +
                          &SAKI *TCAT ', PLEASE SEE EJKPL01 TO +
                          CHECK MORE DETAIL. ENTER "G" TO CONTINUE')
        /* NOTIFICATION BY E-MAIL */
             CALL       PGM(MSGC10) PARM(&PTTL &PMSG)

        /* SEND MESSAGE */
             CHGVAR     VAR(&PKINP) VALUE('G    ')
             CHGVAR     VAR(&PKOUT) VALUE(' ')
             CALL       PGM(APLC50) PARM(&PMSG &PKINP &PMSGQ &PKOUT)

 /* IF ERROR HAPPENS, PLEASE CHECK EJKPP01 */
 /* IF DATA IS NOT NEEDED -> ENTER 'D' TO DJSKJY */
 /* IF DATA HAS BEEN ENDED  -> ENTER END DATE TO DJKNHZ */

 @END:
             ENDPGM
