             PGM        PARM(&SIRE)
             /** GDLC1G **********************************/
             /*  CREATE MATERIAL ORDER ISF.CSV           */
             /*  JW   2018.10.31                         */
             /********************************************/

             DCL        VAR(&SIRE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&TTL0) TYPE(*CHAR) LEN(30)
             DCL        VAR(&TTL1) TYPE(*CHAR) LEN(21)
             DCL        VAR(&TTL2) TYPE(*CHAR) LEN(6)

             DLTF       FILE(QTEMP/GDLWP04)
             MONMSG     MSGID(CPF2105)

             CRTDUPOBJ  OBJ(GDLWP04) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             CLRPFM     FILE(QTEMP/GDLWP04)

             CALL       PGM(GDLR1G) PARM(&SIRE)

  /* TRANSFER TO IFS */
             IF         COND(&SIRE *NE ' ') THEN(DO)
             CHGVAR     VAR(&TTL1) VALUE('MATERIAL ORDER SHEET ')
             IF COND(&SIRE *EQ '4511') THEN(CHGVAR VAR(&TTL2) VALUE('(O&K   )'))
             IF COND(&SIRE *EQ '4530') THEN(CHGVAR VAR(&TTL2) VALUE('(NSCI  )'))
             IF COND(&SIRE *EQ '4540') THEN(CHGVAR VAR(&TTL2) VALUE('(NSCI  )'))
             IF COND(&SIRE *EQ '4550') THEN(CHGVAR VAR(&TTL2) VALUE('(POSCO )'))
             IF COND(&SIRE *EQ '4560') THEN(CHGVAR VAR(&TTL2) VALUE('(TSUSHO)'))


             CHGVAR     VAR(&TTL0) VALUE(&TTL1 *BCAT &TTL2)

             CALL       PGM(APLC94) PARM('2' 'GDLWP04' 'QTEMP' &TTL0 +
                          'Y' ' ' 'N')
             ENDDO

             ENDPGM
