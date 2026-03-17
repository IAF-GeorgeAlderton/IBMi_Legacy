             PGM
             /** AB#CBG ***********************************************/
             /*  ..PRINT TMS CASE LABEL                               */
             /*                                                       */
             /*                                                       */
             /***************************** AB#CBG ********************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)    TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             OVRDBF     FILE(AB#NP31) TOFILE(TFILE1/AB#NP31)
             OVRDBF     FILE(AB#PL76) TOFILE(HFILE1/AB#PL76)
             OVRDBF     FILE(AB#PL1A) TOFILE(HFILE1/AB#PL1A)
             OVRDBF     FILE(AB#PP70) TOFILE(TFILE1/AB#PP70)
             OVRDBF     FILE(AB#PL67) TOFILE(TFILE1/AB#PL67)
             OVRDBF     FILE(AB#PP44) TOFILE(HFILE1/AB#PP44)
             OVRDBF     FILE(AB#WP2Q) TOFILE(TWFILE1/AB#WP2Q)

             OVRDBF     FILE(AB#PWBG) TOFILE(TOBJ1/AB#PWBG)

             CLRPFM     FILE(TWFILE1/AB#WP2Q)

             CALL       PGM(TOBJ1/AB#RBG)

             ENDPGM
