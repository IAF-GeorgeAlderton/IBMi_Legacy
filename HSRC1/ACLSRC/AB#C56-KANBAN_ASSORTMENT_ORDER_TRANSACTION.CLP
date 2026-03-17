             PGM
             /** AB#C55 **************************************/
             /*   KANBAN ASSORTMENT ORDER TRANSACTION..      */
             /*   I-HASADA             97.11.01              */
             /*   JW1   2019.02.19 CHG AB#WP55 TO AB#WX55    */
             /************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SR) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MBAN)    TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PFLG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FLG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE1)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE2)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE3)   TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE4)   TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE5)   TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE6)   TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILEA)   TYPE(*CHAR) LEN(9)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

 STEP1:      CHGJOB     SWS(00000000)
             CHGVAR     VAR(&SR) VALUE('TK')
             CHGVAR     VAR(&FILE5) VALUE(AB#WX55 *CAT &SR)
             CHGVAR     VAR(&FILE6) VALUE(AB#WP56 *CAT &SR)
             CHGVAR     VAR(&FILE1) VALUE(AB#WP571 *CAT &SR)
             CHGVAR     VAR(&FILE2) VALUE(AB#WP572 *CAT &SR)
             CHGVAR     VAR(&FILE3) VALUE(AB#WP20 *CAT &SR)
             CHGVAR     VAR(&FILE4) VALUE('MITANKF' *CAT &SR)
             CHGVAR     VAR(&FILEA) VALUE(AB#WP5A *CAT &SR)
             CHGVAR     VAR(&FLG) VALUE(*BLANK)

             DLTF       FILE(&FILE5)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE5) RCDLEN(128) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AB#WX55) TOFILE(&FILE5)
             CALL       PGM(AB#R55)

             IF         (%SWITCH(0XXXXXXX)) DO
             DLTF       FILE(&FILE5)
             GOTO       END
             ENDDO

             DLTF       FILE(&FILE6)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE6) RCDLEN(128) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/&FILE5)) OUTFILE(&WLIB/&FILE6) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S56) +
                          OPTION(*NOPRT)
             DLTF       FILE(&FILE5)

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE1) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          HOLD(*YES) IGCDTA(&PIGCD)

             OVRDBF     FILE(AB#WP56) TOFILE(&FILE6)
             OVRDBF     FILE(AB#WP571) TOFILE(&FILE1)

             DLTF       FILE(&FILEA)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILEA) RCDLEN(128) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AB#WP5A) TOFILE(&FILEA)
             CALL       PGM(AB#R5A) PARM(&FLG)
             IF         (%SWITCH(XX0XXXXX)) DO
             DLTF       FILE(&FILEA)
             GOTO       STEP1
             ENDDO
             CALL       PGM(AB#R5B)

             CALL       PGM(AB#R569) PARM(&USER)

 /*          IF         (%SWITCH(X0XXXXXX)) DO                      */
 STP3:
 /*          SNDPGMMSG  MSG('( G ) KANBAN ASSORTMENT DATA ALL FRS + */
 /*                      ORDER HAS BEEN PROCESSED  < G-ENTER >') +  */
 /*                      TOMSGQ(&WSID) MSGTYPE(*INQ) KEYVAR(&MBAN)  */
 /*         RCVMSG     MSGTYPE(*RPY) MSGKEY(&MBAN) WAIT(*MAX) +     */
 /*                       MSG(&KOTAE)                               */
 /*          IF         COND((&KOTAE = 'G') *OR (&KOTAE = 'g')) +   */
 /*                       THEN(GOTO CMDLBL(END))                    */
 /*          GOTO       STP3                                        */
 /*          ENDDO                                                  */

             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE2) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/&FILE1)) OUTFILE(&WLIB/&FILE2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S20) +
                          OPTION(*NOPRT)
             DLTF       FILE(&FILE1)

             DLTF       FILE(&FILE3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE3) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AB#WP20) OPTION(*NOLIST *NOSRC) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AB#WP572) TOFILE(&FILE2)
             OVRDBF     FILE(AB#WP20) TOFILE(&FILE3)
             CALL       PGM(AB#R57)

             OVRDBF     FILE(AB#WP20) TOFILE(&FILE3)
             CALL       PGM(AB#R22)

             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) HOLD(*YES)

             OVRPRTF    FILE(QPRINT2) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) HOLD(*YES)

             OVRDBF     FILE(AB#WP20) TOFILE(&FILE3)
             CALL       PGM(AB#R58) PARM('3347')

             DLTF       FILE(&FILE4)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE4) RCDLEN(300) +
                          OPTION(*NOLIST *NOSRC) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AB#WP20) TOFILE(&FILE3)
             OVRDBF     FILE(MITANKF) TOFILE(&FILE4)
             CALL       PGM(AB#R25) PARM(&PFLG)

             IF         (&PFLG *EQ '*') DO

             OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&PRTG) FORMTYPE(K6H1) +
                          HOLD(*YES) IGCDTA(&PIGCD)

             OVRDBF     FILE(MITANKF) TOFILE(&FILE4)
             CALL       PGM(AB#R26) PARM('3347')

             SNDPGMMSG  MSG('UNIT PRICES ARE NOT REGISTERED IN THE +
                          SALES UNIT PRICE MASTER FILES. UNIT PRICE +
                          MUST BE REGISTERED.') TOMSGQ(&WSID)
             ENDDO

 END:        DLTOVR     FILE(*ALL)

             ENDPGM
