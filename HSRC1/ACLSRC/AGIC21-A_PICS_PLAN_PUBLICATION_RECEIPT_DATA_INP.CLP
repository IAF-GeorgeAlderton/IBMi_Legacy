             PGM        PARM(&HHMM)
             /*** AGIC21 ***********************************/
             /* A-PICS SORT                                */
             /*  ITS.              2013.11.25              */
             /**********************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&DDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&AGIWP08) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AGIWP31) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&HHMM) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))

             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO

             CHGJOB     OUTQ(&PRTG)
 #STP10:
        /*   CPYF       FROMFILE(AGIWP30) TOFILE(HOTTA/AGIWP30) +
                          MBROPT(*ADD) CRTFILE(*YES)  */
        /*   MONMSG     MSGID(CPF0000)                */
        /*   CPYF       FROMFILE(AGIWP31) TOFILE(HOTTA/AGIWP30) +
                          MBROPT(*ADD) CRTFILE(*YES)    */
        /*   MONMSG     MSGID(CPF0000)                  */

             CLRPFM     FILE(AGIWP08)
             CLRPFM     FILE(AGIWP11)
             CLRPFM     FILE(AGIWP30)
             CLRPFM     FILE(AGIWP31)
             CALL       PGM(AGIR08) PARM(&HHMM)
        /*   CALL       PGM(AGIR21)  */

 END:
             ENDPGM
