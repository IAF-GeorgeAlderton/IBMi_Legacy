             PGM        PARM(&SEU &PGM &STT)
             /** VVVC51C2 **********************************************/
             /*  COMPILE DESIGNATED SOURCE CODE                        */
             /*  JW   2026.02.13                                       */
             /**********************************************************/
             DCL        VAR(&SEU ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PGM ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&STT ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OLIB) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)

       /**   CHGVAR     VAR(&OLIB) VALUE('TOBJ2')  **/
             CHGVAR     VAR(&OLIB) VALUE('HOBJ1')

             CHGVAR     VAR(&STT ) VALUE(' ')

/* COMPILE RPG */
             IF         COND(&SEU = 'RPG') THEN(DO)
             CRTRPGPGM  PGM(&OLIB/&PGM ) SRCFILE(HSRC1/ARPGSRC) +
                          SRCMBR(&PGM ) ALWNULL(*YES)
             MONMSG     MSGID(QRG0008 QRG9001) EXEC(GOTO ERR)
             GOTO       CMDLBL(PEND)
             ENDDO

/* COMPILE CLP */
             IF         COND(&SEU = 'CLP') THEN(DO)
             CRTCLPGM   PGM(&OLIB/&PGM) SRCFILE(HSRC1/ACLSRC) +
                          SRCMBR(&PGM)
             MONMSG     MSGID(CPF0801) EXEC(GOTO ERR)
             GOTO       CMDLBL(PEND)
             ENDDO

/* COMPILE RPGLE */
             IF         COND(&SEU = 'RPGL') THEN(DO)
             CRTBNDRPG  PGM(&OLIB/&PGM) SRCFILE(HSRC1/ARPGLESRC) +
                          SRCMBR(&PGM)
             MONMSG     MSGID(RNS9310 RPG0202) EXEC(GOTO ERR)
             GOTO       CMDLBL(PEND)
             ENDDO
 ERR:
             SNDBRKMSG  MSG(&PGM *BCAT &SEU *BCAT ' was not created!!! +
                          **ERROR** ') TOMSGQ(&WSID) +
                          MSGTYPE(*INFO)
             CHGVAR     VAR(&STT ) VALUE('X')
             MONMSG     MSGID(CPF0000)
 PEND:
             ENDPGM
