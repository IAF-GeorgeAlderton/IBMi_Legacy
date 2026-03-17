             PGM        PARM(&OUTQ)

             DCL        VAR(&PRT01) TYPE(*CHAR) LEN(25)
             DCL        VAR(&PRT02) TYPE(*CHAR) LEN(25)
             DCL        VAR(&PRT03) TYPE(*CHAR) LEN(25)
             DCL        VAR(&PRT04) TYPE(*CHAR) LEN(25)
             DCL        VAR(&PRT05) TYPE(*CHAR) LEN(25)
             DCL        VAR(&PRT06) TYPE(*CHAR) LEN(25)
             DCL        VAR(&PRT07) TYPE(*CHAR) LEN(25)
             DCL        VAR(&PRT08) TYPE(*CHAR) LEN(25)
             DCL        VAR(&OUTQ)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTN )  TYPE(*CHAR) LEN(1)

/*  SET PRINTER: POS 18-25 SHOULD BE OUTQ NAME   -->        XXXXXXXX     */
             CHGVAR     VAR(&PRT01) VALUE('1.GREEN BAR......QPRINTC ')
             CHGVAR     VAR(&PRT02) VALUE('2.APICS ROOM1....LANPRT02')
             CHGVAR     VAR(&PRT03) VALUE('3.APICS ROOM2....LANPRT07')
             CHGVAR     VAR(&PRT04) VALUE('4.OFFICE.........LANPRT03')
             CHGVAR     VAR(&PRT05) VALUE('5.G/L ROOM.......LANPRT04')
             CHGVAR     VAR(&PRT06) VALUE('6.OFFICE(SALES)..LANPRT05')
             CHGVAR     VAR(&PRT07) VALUE('7.COMPUTER RM....QPRINT  ')
             CHGVAR     VAR(&PRT08) VALUE('                         ')

/*  SELECT PRINTER */
             CALL       PGM(UTLR79 ) PARM(&PRT01 &PRT02 &PRT03 &PRT04 +
                                          &PRT05 &PRT06 &PRT07 &PRT08 +
                                          &OUTQ &RTN )
             IF         COND(&RTN  *EQ '*') THEN(DO)
             CHGVAR     VAR(&OUTQ) VALUE('EPRINT1')
             ENDDO


 ENDP:       ENDPGM
