             PGM
             /** AB#C62 **********************************************/
             /*  ..ACCOUNTS RECEIVABLE DETAIL LIST..                 */
             /*    I-HASADA               97.08.12                   */
             /*    GBC           99.09.06 (9999-FOR ALL USERS)       */
             /*    K.KASHIWAGI   01.03.15 REPLACE AB#R70 WITH AB#R80 */
             /*    H.AMANO       01.08.10 ADD OPTION FOR LIST ONLY   */
             /*       OPTIN : BLANK=BOTH  1=LIST ONLY  2=EDI ONLY    */
             /*                                                      */
             /*    H.AMANO       02.04.17  LIST ONLY                 */
             /*                                                      */
             /* TCHK1 11/19/08 CHG HOLD ALL LIST                     */
             /* JW1   2022.03.02 CHG AB#WP62                         */
             /********************************************** AB#C62 **/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PNONY) TYPE(*CHAR) LEN(4)
             DCL        VAR(&ZNONY) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PNOYM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PER) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&XNONY) TYPE(*CHAR) LEN(4)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&OPT) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&US)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&US &WLIB)

             DLTF       FILE(QTEMP/AB#WP62)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP62) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(200000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(AB#WP621)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AB#WP621) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(200000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(AB#R62) PARM(&PNONY &PNOYM)

             IF         COND(%SWITCH(0XXXXXXX)) THEN(DO)
             DLTF       FILE(QTEMP/AB#WP62)
             DLTF       FILE(AB#WP621)
             GOTO       CMDLBL(END)
             ENDDO

             IF         COND(%SWITCH(X0XXXXXX)) THEN(DO)
             DLTF       FILE(QTEMP/AB#WP62)
             DLTF       FILE(AB#WP621)
             SNDPGMMSG  MSG('NO DATA AVAILABLE') TOMSGQ(&WSID)
             GOTO       CMDLBL(END)
             ENDDO

             IF         COND(%SWITCH(XX1XXXXX)) THEN(DO)
             SNDPGMMSG  MSG('UNIT PRICES ARE NOT REGISTERED') +
                          TOMSGQ(&WSID)
             ENDDO

             /*--------------------------------------------*/
             /* ..EDI FIXED ORDER DATA NOT ON SALES LIST.. */
             /*--------------------------------------------*/

             DLTF       FILE(AB#WP69)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AB#WP69) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(200000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(AB#R69) PARM(&PNONY &PNOYM &PER)

             IF         COND(&PER *EQ '*') THEN(DO)

             SNDPGMMSG  MSG('EDI FIXED ORDER DATA NOT ON SALES LIST +
                          EXIST') TOMSGQ(&WSID)

             DLTF       FILE(AB#WP80)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AB#WP80) RCDLEN(128) +
                          OPTION(*NOLIST) SIZE(200000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(AB#R80)
             CHGVAR     VAR(&REC) VALUE('0')
             RTVMBRD    FILE(AB#WP80) NBRCURRCD(&REC)
             IF         COND(&REC *NE 0) THEN(DO)

             DLTF       FILE(AB#WP81)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AB#WP81) RCDLEN(128) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/AB#WP80)) +
                          OUTFILE(&WLIB/AB#WP81) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S80) +
                          OPTION(*NOPRT)

     /*JW    OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(LANPRT50) FORMTYPE(K6H1) HOLD(*YES) +
                          SAVE(*YES) IGCDTA(&PIGCD)       JW */

             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(EPRINT1 ) FORMTYPE(K6H1) HOLD(*YES) +
                          SAVE(*YES) IGCDTA(&PIGCD) /*JW*/

             OVRDBF     FILE(AB#WP81) TOFILE(AB#WP81)
             CALL       PGM(AB#R81)

             DLTOVR     FILE(*ALL)

             ENDDO
             ENDDO
             ELSE       CMD(DO)

             DLTF       FILE(AB#WP69)
             ENDDO

             /*------------*/
             /*  ..TMMK..  */
             /*------------*/
             /*  LIST      */

             DLTF       FILE(AB#WP62S)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AB#WP62S) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(200000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             CHGVAR     VAR(&PNONY) VALUE('3348')
             CPYF       FROMFILE(QTEMP/AB#WP62) TOFILE(AB#WP62S) +
                          MBROPT(*ADD) INCCHAR(*RCD 5 *EQ &PNONY) +
                          FMTOPT(*NOCHK)

             CHGVAR     VAR(&PNONY) VALUE('3347')
             CPYF       FROMFILE(QTEMP/AB#WP62) TOFILE(AB#WP62S) +
                          MBROPT(*ADD) INCCHAR(*RCD 5 *EQ &PNONY) +
                          FMTOPT(*NOCHK)

             RTVMBRD    FILE(AB#WP62S) NBRCURRCD(&REC)

             IF         (&REC *NE 0 ) DO

             CHGVAR     VAR(&XNONY) VALUE(&PNONY)

             DLTF       FILE(AB#WP63)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AB#WP63) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(200000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/AB#WP62S)) +
                          OUTFILE(&WLIB/AB#WP63) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S63) +
                          OPTION(*NOPRT)
             DLTF       FILE(AB#WP62S)

             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(LANPRT50) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD) /* TCHK1 */
             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(EPRINT1) FORMTYPE(K6H1) HOLD(*YES) +
                          IGCDTA(&PIGCD) /*JW*/
             CALL       PGM(AB#R63) PARM(&PNONY)
             DLTF       FILE(AB#WP63)

             ENDDO

             /*-------------*/
             /*  ..NUMMI..  */
             /*-------------*/


             CHGVAR     VAR(&PNONY) VALUE('0541')
             DLTF       FILE(AB#WP62S)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AB#WP62S) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(200000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             CPYF       FROMFILE(QTEMP/AB#WP62) TOFILE(AB#WP62S) +
                          MBROPT(*ADD) INCCHAR(*RCD 5 *EQ &PNONY) +
                          FMTOPT(*NOCHK)

             RTVMBRD    FILE(AB#WP62S) NBRCURRCD(&REC)

             IF         COND(&REC *NE 0) THEN(DO)

             CHGVAR     VAR(&XNONY) VALUE(&PNONY)

             DLTF       FILE(AB#WP64)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AB#WP64) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(200000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/AB#WP62S)) +
                          OUTFILE(&WLIB/AB#WP64) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S64) +
                          OPTION(*NOPRT)
             DLTF       FILE(AB#WP62S)

             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(LANPRT50) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD) /* TCHK1 */
             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(EPRINT1) FORMTYPE(K6H1) HOLD(*YES) +
                          IGCDTA(&PIGCD) /*JW*/
             CALL       PGM(AB#R64) PARM(&XNONY)
             DLTF       FILE(AB#WP64)
             DLTOVR     FILE(*ALL)

             ENDDO


             /*------------*/
             /*  ..TMMC..  */
             /*------------*/


             CHGVAR     VAR(&PNONY) VALUE('3503')
             DLTF       FILE(AB#WP62S)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTPF      FILE(&WLIB/AB#WP62S) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(200000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             CPYF       FROMFILE(QTEMP/AB#WP62) TOFILE(AB#WP62S) +
                          MBROPT(*ADD) INCCHAR(*RCD 5 *EQ &PNONY) +
                          FMTOPT(*NOCHK)
             RTVMBRD    FILE(AB#WP62S) NBRCURRCD(&REC)

             IF         COND(&REC *NE 0) THEN(DO)

             CHGVAR     VAR(&XNONY) VALUE(&PNONY)

             DLTF       FILE(AB#WP66)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AB#WP66) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(200000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/AB#WP62S)) +
                          OUTFILE(&WLIB/AB#WP66) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S66) +
                          OPTION(*NOPRT)
             DLTF       FILE(AB#WP62S)

             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(LANPRT50) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD) /* TCHK1 */
             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(EPRINT1) FORMTYPE(K6H1) HOLD(*YES) +
                          IGCDTA(&PIGCD) /*JW*/
             CALL       PGM(AB#R66) PARM(&XNONY)
             DLTF       FILE(AB#WP66)
             DLTOVR     FILE(*ALL)

             ENDDO

             /*-----------------*/
             /*  ..SIA ISUZU..  */
             /*-----------------*/

             CHGVAR     VAR(&PNONY) VALUE('0506')
             DLTF       FILE(AB#WP62S)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AB#WP62S) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(200000 10000) +
                          LVLCHK(*NO) AUT(*ALL)


             CPYF       FROMFILE(QTEMP/AB#WP62) TOFILE(AB#WP62S) +
                          MBROPT(*ADD) INCCHAR(*RCD 5 *EQ '0437') +
                          FMTOPT(*NOCHK)
             CPYF       FROMFILE(QTEMP/AB#WP62) TOFILE(AB#WP62S) +
                          MBROPT(*ADD) INCCHAR(*RCD 5 *EQ '0506') +
                          FMTOPT(*NOCHK)

             RTVMBRD    FILE(AB#WP62S) NBRCURRCD(&REC)

             IF         COND(&REC *NE 0) THEN(DO)

             DLTF       FILE(AB#WP71)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AB#WP71) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(200000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/AB#WP62S)) +
                          OUTFILE(&WLIB/AB#WP71) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S71) +
                          OPTION(*NOPRT)

             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(LANPRT50) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD) /* TCHK1 */
             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(EPRINT1) FORMTYPE(K6H1) HOLD(*YES) +
                          IGCDTA(&PIGCD) /*JW*/

             CALL       PGM(AB#R71) PARM(&PNONY)
             DLTF       FILE(AB#WP71)

             MONMSG     MSGID(CPF3261 CPF2105)

             DLTOVR     FILE(*ALL)

             ENDDO

             /*------------------------------------*/
             /*  ..NO TMMC TMMK NUMMI SIA ISUZU..  */
             /*------------------------------------*/

             DLTF       FILE(AB#WP62S)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AB#WP62S) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(200000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             CPYF       FROMFILE(QTEMP/AB#WP62) TOFILE(AB#WP62S) +
                          MBROPT(*ADD) INCCHAR(*RCD 77 *EQ '1') +
                          FMTOPT(*NOCHK)
                                        /* AB#R62 .COL-77 SET '1' */

             RTVMBRD    FILE(AB#WP62S) NBRCURRCD(&REC)

             IF         COND(&REC *NE 0) THEN(DO)

             DLTF       FILE(AB#WP68)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AB#WP68) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(200000 10000) +
                          LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/AB#WP62S)) +
                          OUTFILE(&WLIB/AB#WP68) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S68) +
                          OPTION(*NOPRT)
             DLTF       FILE(AB#WP62S)

             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(LANPRT50) FORMTYPE(K6H1) +
                          IGCDTA(&PIGCD) /* TCHK1 */
             OVRPRTF    FILE(QPRINT) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(EPRINT1) FORMTYPE(K6H1) HOLD(*YES) +
                          IGCDTA(&PIGCD) /*JW*/
             CALL       PGM(AB#R68) PARM(&PNONY)
             DLTF       FILE(AB#WP68)
             DLTOVR     FILE(*ALL)

             ENDDO


             DLTF       FILE(QTEMP/AB#WP62)
             DLTF       FILE(AB#WP621)

 END:        ENDPGM
