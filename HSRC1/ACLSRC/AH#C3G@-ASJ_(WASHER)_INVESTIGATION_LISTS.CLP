             PGM
             /** AH#C3G ********************************/
             /*  ASJ(WASHER) INVESTIGATION LIST        */
             /*                                        */
             /* TCH N.HYOTO 2001.05.09                 */
             /********************** BASE OF   AH#C3E **/
             DCL        VAR(&SFLG) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&RFLG) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&KBN)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&FIL1)   TYPE(*CHAR) LEN(9)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&TIME)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&KOTE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&INVQ)   TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WS) USER(&USER)
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&TIME)
             CHGJOB     RUNPTY(40) SWS(00000000)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

 STP1:       CHGJOB     OUTQ(&PRTG)

             CHGVAR     VAR(&WSID)   VALUE(%SST(&WS 1 2))
             CHGVAR     VAR(&KBN)    VALUE('H')
             CHGVAR     VAR(&FIL1)   VALUE(AH#WP30 *CAT &WSID)

             DLTF       FILE(&FIL1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FIL1) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AH#WP30) OPTION(*NOLIST *NOSRC) +
                          SIZE(10000 1000 3) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AH#WP30) TOFILE(&FIL1)
             CALL       PGM(AH#R3R) PARM(&USER &SFLG &RFLG &INVQ)

             IF         (%SWITCH(0XXXXXXX)) DO
             DLTF       FILE(&FIL1)
             DLTOVR     FILE(*ALL)
             GOTO       END
             ENDDO


       /*    CALL       PGM(AH#R3X) PARM(&TIME &KBN &SFLG &RFLG) */
             CALL       PGM(AH#R3W@) PARM(&TIME &KBN &SFLG &RFLG &INVQ)

             DLTOVR     FILE(*ALL)

 END:        CHGJOB     RUNPTY(20)

             ENDPGM
