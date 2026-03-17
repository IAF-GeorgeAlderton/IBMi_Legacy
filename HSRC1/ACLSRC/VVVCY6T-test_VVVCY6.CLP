             PGM        PARM(&PGM)
             /** VVVCY6T *********************************/
             /*  TEST VVVCY6                             */
             /********************************************/
             DCL        VAR(&PGM)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&OBJLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&OBJATR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TEXT)    TYPE(*CHAR) LEN(50)
             DCL        VAR(&OBJCRT)  TYPE(*CHAR) LEN(13)
             DCL        VAR(&USEDATE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&USECNT)  TYPE(*DEC ) LEN(5 0)
             DCL        VAR(&SRCF)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRCFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRCMBR)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRCDATE) TYPE(*CHAR) LEN(13)
             DCL        VAR(&SRCCHGD) TYPE(*CHAR) LEN(13)

             DCL        VAR(&SRCDATE) TYPE(*CHAR) LEN(13)
             DCL        VAR(&SRCTYPE) TYPE(*CHAR) LEN(10)

             RTVOBJD    OBJ(*LIBL/&PGM) OBJTYPE(*PGM) +
                          RTNLIB(&OBJLIB) OBJATR(&OBJATR) +
                          TEXT(&TEXT) CRTDATE(&OBJCRT) +
                          USEDATE(&USEDATE) USECOUNT(&USECNT) +
                          SRCF(&SRCF) SRCFLIB(&SRCFLIB) +
                          SRCMBR(&SRCMBR) SRCDATE(&SRCDATE)
             MONMSG     MSGID(CPF9999)

             IF         COND(&SRCF *EQ '          ') THEN(DO)
             CALL       PGM(VVVC99) PARM(&PGM 'HOBJ1     ' &SRCF +
                          &SRCFLIB &SRCMBR &SRCDATE)
             ENDDO

             CALL       PGM(VVVCY1) PARM(&SRCFLIB &SRCF &SRCMBR +
                          &SRCCHGD &SRCTYPE)

             ENDPGM
