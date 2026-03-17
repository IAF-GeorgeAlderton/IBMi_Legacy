             PGM
             /*- AFACXX ------------------------------------*/
             /*  ..A-PICS ORDERING DATA REORGANIZATIONI..   */
             /* CODING:T.SAKAKI    2015.12.08               */
             /*------------------------------------ AFACXX -*/
             DCL        VAR(&TIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WTIME) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WFILE1) TYPE(*CHAR) LEN(10)
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&TIME)
             CHGVAR     VAR(&WTIME) VALUE(%SUBSTRING(&TIME 1 4))

             CHGVAR     VAR(&WFILE1) VALUE('AGAP31' *TCAT &WTIME)

             CPYF       FROMFILE(HFILE1/AGAPP31) +
                          TOFILE(SAKAKI/&WFILE1) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)

 SEND:       ENDPGM
