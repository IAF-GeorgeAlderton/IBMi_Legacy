             PGM
             /** AH#C3E *************************************/
             /* A-PICS KANBAN INVESTIGATION LISTS(ASJ) PART */
             /*                                             */
             /* TCH N.HYOTO 2000.0919                       */
             /* H.ITO       2000.12.14                      */
             /********************** BASE OF   AH#C3A *******/
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
             DCL        VAR(&FIL2)   TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL3)   TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL4)   TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL5)   TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL6)   TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL7)   TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL8)   TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL9)   TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILA)   TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILB)   TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILC)   TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILD)   TYPE(*CHAR) LEN(9)
             DCL        VAR(&TIME)   TYPE(*CHAR) LEN(6)

             DCL        VAR(&FILE)   TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILF)   TYPE(*CHAR) LEN(9)

             DCL        VAR(&FIL3K)  TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL3L1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FIL3L2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FIL3M)  TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL3N)  TYPE(*CHAR) LEN(9)
       /* MSK 00.12.05 */
             DCL        VAR(&SFLG) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&RFLG) TYPE(*CHAR) LEN(1) VALUE('N')
       /*              */

             RTVJOBA    JOB(&WS) USER(&USER)
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&TIME)
             CHGJOB     RUNPTY(40) SWS(00000000)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

 STP1:       CHGJOB     OUTQ(&PRTG)

             CHGVAR     VAR(&WSID)   VALUE(%SST(&WS 1 2))
             CHGVAR     VAR(&KBN)    VALUE('1')
             CHGVAR     VAR(&FIL1)   VALUE(AH#WP30 *CAT &WSID)
             CHGVAR     VAR(&FIL2)   VALUE(AH#WP32 *CAT &WSID)
             CHGVAR     VAR(&FIL3)   VALUE(AH#WP33 *CAT &WSID)
             CHGVAR     VAR(&FIL4)   VALUE(AH#WP3A *CAT &WSID)
             CHGVAR     VAR(&FIL5)   VALUE(AH#WP34 *CAT &WSID)
             CHGVAR     VAR(&FIL6)   VALUE(AH#WP3B *CAT &WSID)
             CHGVAR     VAR(&FIL7)   VALUE(AH#WP36 *CAT &WSID)
             CHGVAR     VAR(&FIL8)   VALUE(AH#WP47 *CAT &WSID)
             CHGVAR     VAR(&FIL9)   VALUE(AH#WL47 *CAT &WSID)
             CHGVAR     VAR(&FILA)   VALUE(AH#WP48 *CAT &WSID)
             CHGVAR     VAR(&FILB)   VALUE(AH#WP49 *CAT &WSID)
             CHGVAR     VAR(&FILC)   VALUE(AH#WP46 *CAT &WSID)
             CHGVAR     VAR(&FILD)   VALUE(AH#WL46 *CAT &WSID)

             CHGVAR     VAR(&FILE)   VALUE(AH#WP3I *CAT &WSID)
             CHGVAR     VAR(&FILF)   VALUE(AH#WP3J *CAT &WSID)

             CHGVAR     VAR(&FIL3K)  VALUE(AH#WP3K  *CAT &WSID)
             CHGVAR     VAR(&FIL3L1) VALUE(AH#WP3L1 *CAT &WSID)
             CHGVAR     VAR(&FIL3L2) VALUE(AH#WP3L2 *CAT &WSID)
             CHGVAR     VAR(&FIL3M)  VALUE(AH#WP3M  *CAT &WSID)
             CHGVAR     VAR(&FIL3N)  VALUE(AH#WP3N  *CAT &WSID)
        /*               */

             DLTF       FILE(&FIL1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(TWFILE1/&FIL1) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AH#WP30) OPTION(*NOLIST *NOSRC) +
                          SIZE(10000 1000 3) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AH#WP30) TOFILE(&FIL1)
             CALL       PGM(AH#R3L) PARM(&USER &SFLG &RFLG)

             IF         (%SWITCH(0XXXXXXX)) DO
             DLTF       FILE(&FIL1)
             DLTOVR     FILE(*ALL)
             GOTO       END
             ENDDO


             DLTF       FILE(&FIL2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(TWFILE1/&FIL2) RCDLEN(200) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&FIL3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(TWFILE1/&FIL3) RCDLEN(200) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&FIL4)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(TWFILE1/&FIL4) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AH#WP3A) OPTION(*NOLIST *NOSRC) +
                          SIZE(10000 1000 3) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&FIL5)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(TWFILE1/&FIL5) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AH#WP34) OPTION(*NOLIST *NOSRC) +
                          SIZE(10000 1000 3) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&FIL6)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(TWFILE1/&FIL6) RCDLEN(180) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&FIL7)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(TWFILE1/&FIL7) RCDLEN(180) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&FIL8)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(TWFILE1/&FIL8) RCDLEN(108) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&FIL9)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(TWFILE1/&FIL9) RCDLEN(108) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&FILA)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(TWFILE1/&FILA) RCDLEN(118) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&FILB)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(TWFILE1/&FILB) RCDLEN(108) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&FILC)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(TWFILE1/&FILC) RCDLEN(108) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&FILD)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(TWFILE1/&FILD) RCDLEN(108) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&FILE)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(TWFILE1/&FILE) RCDLEN(120) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&FILF)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(TWFILE1/&FILF) RCDLEN(120) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&FIL3K)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(TWFILE1/&FIL3K) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&FIL3L1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(TWFILE1/&FIL3L1) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&FIL3L2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(TWFILE1/&FIL3L2) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&FIL3M)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(TWFILE1/&FIL3M) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&FIL3N)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(TWFILE1/&FIL3N) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(AH#R3X@) PARM(&TIME &KBN &SFLG &RFLG)

             DLTOVR     FILE(*ALL)

 END:        CHGJOB     RUNPTY(20)

             ENDPGM
