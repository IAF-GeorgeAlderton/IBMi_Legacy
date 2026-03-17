             PGM        PARM(&DATE &SFT &PTYP)
/** ALDC6F1 ***********************************************/
/*  SHIPPING # OF SHORTAGE (BY LOCATION)                  */
/*  JW   2020.03.17                                       */
/*  JW1  2020.11.10 ADD LANPRT36                          */
/**********************************************************/
             DCL        VAR(&DATE)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&SFT )  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PTYP)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRNTR) TYPE(*CHAR) LEN(10)

             IF (&PTYP  *EQ '1') CHGVAR VAR(&PRNTR) VALUE('LANPRT03')
             IF (&PTYP  *EQ '2') CHGVAR VAR(&PRNTR) VALUE('LANPRT06')
             IF (&PTYP  *EQ '3') CHGVAR VAR(&PRNTR) VALUE('LANPRT08')
             IF (&PTYP  *EQ '4') CHGVAR VAR(&PRNTR) VALUE('LANPRT04')
             IF (&PTYP  *EQ '5') CHGVAR VAR(&PRNTR) VALUE('LANPRT34')
             IF (&PTYP  *EQ '6') CHGVAR VAR(&PRNTR) VALUE('LANPRT36')
             IF (&PTYP  *EQ '9') CHGVAR VAR(&PRNTR) VALUE('EPRINT1 ')

             OVRPRTF FILE(QPRINT) PAGESIZE(66 132) OVRFLW(60) OUTQ(&PRNTR)
             OVRDBF     FILE(ALDWP6E) TOFILE(QTEMP/ALDWP6E)

             CALL       PGM(ALDR6F )  PARM(&DATE &SFT)

             ENDPGM
