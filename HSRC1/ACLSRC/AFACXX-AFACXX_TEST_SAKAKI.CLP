             PGM
             /*- AFACXX ------------------------------------*/
             /*  ..A-PICS ORDERING DATA REORGANIZATIONI..   */
             /* CODING:T.SAKAKI    2015.12.08               */
             /*------------------------------------ AFACXX -*/
             DCL        VAR(&TIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WTIME) TYPE(*CHAR) LEN(2)
             DCL        VAR(&WFILE2) TYPE(*CHAR) LEN(10)
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&TIME)
             CHGVAR     VAR(&WTIME) VALUE(%SUBSTRING(&TIME 1 2))

             CHGVAR     VAR(&WFILE2) VALUE('AFAWP15' *TCAT &WTIME)

             CPYF       FROMFILE(HWFILE1/AFAWP15) +
                          TOFILE(SAKAKI/&WFILE2) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)

 SEND:       ENDPGM
