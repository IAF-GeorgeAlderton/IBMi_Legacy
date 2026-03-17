             PGM        PARM(&PSKHZ &PKOHZ &PTIME &PHHIN &PHYMD +
                          &PHBIN &AAA &BBB &EEE &FFF)
             /** BTAC3A **************************************/
             /*  A-PICS KANBAN INVESTIGATION LISTS           */
             /*********************** BASED ON AH#C31 ********/
             DCL        VAR(&ABADS1)  TYPE(*CHAR) LEN(48)
             DCL        VAR(&MCEDP01) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PSKJY)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PSKHZ)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&PKOHZ)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&PTIME)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&PKOME)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PHHIN)   TYPE(*CHAR) LEN(12)
             DCL        VAR(&PHYMD)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&PHBIN)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&PYMD1)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&PYMD2)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&PMAIS)   TYPE(*CHAR) LEN(5)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PKYM)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&PDEVT)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&AAA)   TYPE(*DEC) LEN(5 0)
             DCL        VAR(&BBB)   TYPE(*DEC) LEN(5 0)
             DCL        VAR(&EEE)   TYPE(*DEC) LEN(5 0)
             DCL        VAR(&FFF)   TYPE(*DEC) LEN(5 0)
       /*              */
             DCL        VAR(&WLIB)    TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WS) USER(&USER)
             RTVDTAARA  DTAARA(ABADS1) RTNVAR(&ABADS1)
             RTVDTAARA  DTAARA(MCEDP01) RTNVAR(&MCEDP01)
             CHGJOB     SWS(00000000)

             CHGVAR     VAR(&PKYM) VALUE(%SST(&ABADS1 1 6))

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

        /*               */

             CRTDUPOBJ  OBJ(AH#WP34) FROMLIB(HFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(QTEMP/AH#WP34)

             OVRDBF     FILE(AH#WP34) TOFILE(QTEMP/AH#WP34)
             CALL       PGM(AH#RB3) PARM(&PSKJY &PSKHZ &PKOHZ &PTIME +
                          &PKOME &PHHIN &PHYMD &PHBIN)

             CRTPF      FILE(QTEMP/AH#WP3B) RCDLEN(180)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/AH#WP3B)

             OVRDBF     FILE(AH#WP3B) TOFILE(QTEMP/AH#WP3B)
             CALL       PGM(AH#R3A)

             CRTPF      FILE(QTEMP/AH#WP36) RCDLEN(180)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/AH#WP36)

             FMTDTA     INFILE((QTEMP/AH#WP3B)) +
                          OUTFILE(QTEMP/AH#WP36) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AH#S3A) +
                          OPTION(*NOPRT)

             CRTDUPOBJ  OBJ(AH#WP3A) FROMLIB(HFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(QTEMP/AH#WP3A)

             OVRDBF     FILE(AH#WP36) TOFILE(QTEMP/AH#WP36)
             OVRDBF     FILE(AH#WP3A) TOFILE(QTEMP/AH#WP3A)
             CALL       PGM(BTAR3B)

             CRTPF      FILE(QTEMP/AH#WP32) RCDLEN(200)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/AH#WP32)

             OVRDBF     FILE(AH#WP32) TOFILE(QTEMP/AH#WP32)
             CALL       PGM(AH#R3C)


             CRTPF      FILE(QTEMP/AH#WP33) RCDLEN(200)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/AH#WP33)

             FMTDTA     INFILE((QTEMP/AH#WP32)) +
                          OUTFILE(QTEMP/AH#WP33) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AH#S3D) +
                          OPTION(*NOPRT)

             OVRDBF     FILE(AH#WP33) TOFILE(QTEMP/AH#WP33)
             OVRDBF     FILE(AH#WP3A) TOFILE(QTEMP/AH#WP3A)
             CALL       PGM(BTAR3D) PARM(&AAA &BBB &EEE &FFF)

             ENDPGM
