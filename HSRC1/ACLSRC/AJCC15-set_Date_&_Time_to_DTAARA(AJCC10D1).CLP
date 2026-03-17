             PGM        PARM(&DATE &TIME)
             /** AJCC15 *****************************************************/
             /*  SET DATE & TIME TO DTAARA(AAJCD1)                          */
             /***************************************************************/
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&TIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DAT8) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&TIM6) TYPE(*DEC)  LEN(6 0)
             DCL        VAR(&SIGN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DAY ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&IAF ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&TGT ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OBJ ) TYPE(*CHAR) LEN(10)

             IF         COND(&DATE *EQ '        ') THEN(GOTO @END)
             IF         COND(&TIME *EQ '      ')   THEN(GOTO @END)

             CHGVAR     VAR(&OBJ) VALUE('HOBJ1')

     /* IF NOT EXIST, CREATE DTAARA */
             CHKOBJ     OBJ(&OBJ/AJCC10D1) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(&OBJ/AJCC10D1) TYPE(*CHAR) LEN(20) +
                          TEXT('SCHEDULED DATE & TIME FOR ENDING +
                          B2B JOB') AUT(*ALL)
             ENDDO

             CHGVAR VAR(&DAT8) VALUE(&DATE)
             CHGVAR VAR(&TIM6) VALUE(&TIME)

             /* SET 1 HOUR ERALIER DATE & TIME */
             IF         COND(&TIM6 >= 010000) THEN(DO)
             CHGVAR     VAR(&TIM6) VALUE(&TIM6 - 010000)
             GOTO       CMDLBL(@SET)
             ENDDO

             IF         COND(&TIM6 < 010000) THEN(DO)
             CHGVAR     VAR(&SIGN) VALUE('-')
             CHGVAR     VAR(&DAY ) VALUE('0001')
             CHGVAR     VAR(&IAF ) VALUE('N')
             CALL UTLR10  PARM(&DATE &SIGN &DAY &IAF &TGT &RTN)

             IF         COND(&RTN *NE ' ') THEN(GOTO CMDLBL(@END))

             CHGVAR     VAR(&TIM6) VALUE(&TIM6 + 240000 - 010000)
             CHGVAR     VAR(&DAT8) VALUE(&TGT)
             GOTO       CMDLBL(@SET)
             ENDDO

 @SET:
             CHGVAR VAR(&DATE) VALUE(&DAT8)
             CHGVAR VAR(&TIME) VALUE(&TIM6)
             CHGDTAARA  DTAARA(&OBJ/AJCC10D1 (01 8)) VALUE(&DATE)
             CHGDTAARA  DTAARA(&OBJ/AJCC10D1 (10 6)) VALUE(&TIME)

 @END:       ENDPGM
