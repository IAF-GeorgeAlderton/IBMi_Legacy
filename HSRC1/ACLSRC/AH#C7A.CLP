 PGM
/** AH#C7A ************************************************/
/*  TOYOTA SHIP VS NOSCAN LIST                            */
/*                                                        */
/* TCHK1 08/01/07 CREATE                                  */
/**********************************************************/

             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WS) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

 STP1:       CHGJOB     OUTQ(&PRTG)

             CLRPFM     FILE(HWFILE1/AH#WP7AE)
             CLRPFM     FILE(HWFILE1/AH#WP7AW)

             OVRDBF     FILE(AH#WP7AE) TOFILE(HWFILE1/AH#WP7AE)
             OVRDBF     FILE(AH#WP7AW) TOFILE(HWFILE1/AH#WP7AW)

             CALL       PGM(AH#R7A)

             DLTOVR     FILE(*ALL)

 END:        CHGJOB     RUNPTY(20)

             ENDPGM
