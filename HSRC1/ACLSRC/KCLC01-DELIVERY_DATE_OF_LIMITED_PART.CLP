             PGM
             /** KCLC01 **************************************/
             /*    DELIVERY DATE OF  LIMITED PART */
             /* A-IDOTA                 1987.07.03           */
             /************************************** KCLC01 **/
             DCLF       FILE(KCLPWA1)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&KOSIN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&WS) USER(&US)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

             CHGVAR     VAR(&@CODE) VALUE('0111')


 STP4:       CALL       PGM(KCLR01) PARM(&@CODE &KOSIN &US)

 END:        ENDPGM
