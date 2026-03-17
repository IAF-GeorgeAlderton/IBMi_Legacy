             PGM        PARM(&P1DNBR &P1USID &P9ERR)
             /** MRACA1 **************************************/
             /* RECEIVE FROM ASJ (SEND BACK DATA)            */
             /*    TRANCOM-ITS         2012.10.22            */
             /************************************************/
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS3)      TYPE(*CHAR) LEN(3)
             DCL        VAR(&PRT)      TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&P1DNBR)   TYPE(*DEC)  LEN(6 0)
             DCL        VAR(&P1USID)   TYPE(*CHAR) LEN(08)
             DCL        VAR(&P9ERR)    TYPE(*CHAR) LEN(01)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3)   VALUE(%SST(&WSID 1 3))

 STP00:
             CLRPFM     FILE(HFILE1/MRBPPA2)
          /* RCVNETF */

             RCVNETF    FROMFILE(MRBPPA2) TOFILE(HFILE1/MRBPPA2) +
                          NBR(&P1DNBR) USER(&P1USID)


             CHGVAR     VAR(&P9ERR) VALUE('1')

             CALL       PGM(MRAR83)
             CALL       PGM(MRAR84)
 END:
             ENDPGM
