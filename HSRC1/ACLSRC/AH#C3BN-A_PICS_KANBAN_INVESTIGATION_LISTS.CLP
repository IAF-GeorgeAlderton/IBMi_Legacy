             PGM        PARM(&PSKJY &PSKHZ &PKOHZ &PTIME &PKOME +
                          &PHHIN &PHYMD &PHBIN &PSYST &PSFLG &PRFLG +
                          &FST &OUTQ)
             /** AH#C3BN *************************************/
             /*  A-PICS KANBAN INVESTIGATION LISTS           */
             /*       I-HASADA          88.10.05             */
             /*       MSK.KUNIEDA       98.04.07             */
             /*       TCH.HYOTO  QPRINTA->QPRINTB,OMIT AFPDS */
             /*       TCH.HYOTO  LIST3,4 OMITTED             */
             /*       TCH.HYOTO  2001.01.03 ADD TEST MODE    */
             /*       TCH.AMANO  2002.08.26 CHANGE OUTQ      */
             /*********************** BASED ON AH#C31 ********/
             DCL        VAR(&ABADS1)  TYPE(*CHAR) LEN(48)
             DCL        VAR(&MCEDP01) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PSKJY)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PSKHZ)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&PKOHZ)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&PTIME)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&PKOME)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PHHIN)   TYPE(*CHAR) LEN(12)
             DCL        VAR(&PHYMD)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&PHBIN)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&PYMD1)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&PYMD2)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&PMAIS)   TYPE(*CHAR) LEN(5)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PKYM)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&PDEVT)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&FIL2)    TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL3)    TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL4)    TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL5)    TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL6)    TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL7)    TYPE(*CHAR) LEN(9)
       /* MSK 98.04.07 */
             DCL        VAR(&FIL8)    TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL9)    TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILA)    TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILB)    TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILC)    TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILD)    TYPE(*CHAR) LEN(9)

             DCL        VAR(&FILE)    TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILF)    TYPE(*CHAR) LEN(9)

             DCL        VAR(&FIL3K)   TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL3L1)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&FIL3L2)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&FIL3M)   TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL3N)   TYPE(*CHAR) LEN(9)
             DCL        VAR(&PSYST)   TYPE(*CHAR) LEN(6)
       /* MSK 98.04.07 */
             DCL        VAR(&PSFLG)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRFLG)   TYPE(*CHAR) LEN(1)
/*JW1*/      DCL        VAR(&FST  )   TYPE(*CHAR) LEN(1)
             DCL        VAR(&OUTQ)   TYPE(*CHAR) LEN(8)
       /*              */
             DCL        VAR(&WLIB)    TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WS) USER(&USER)
             RTVDTAARA  DTAARA(ABADS1) RTNVAR(&ABADS1)
             RTVDTAARA  DTAARA(MCEDP01) RTNVAR(&MCEDP01)
             CHGJOB     SWS(00000000)

             CHGVAR     VAR(&PKYM) VALUE(%SST(&ABADS1 1 6))

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             STRPRTWTR DEV(PC) OUTQ(QPRINTC) MSGQ(WBSS1)
             MONMSG    MSGID(CPF3310 CPF3396 CPF3347 CPF3363 CPF0000)

             IF         COND(&OUTQ *EQ '        ') THEN(CHGVAR +
                          VAR(&OUTQ) VALUE(QPRINTC))
             CHGVAR     VAR(&WSID) VALUE(%SST(&WS 1 2))
             CHGVAR     VAR(&FIL2) VALUE(AH#WP32 *CAT &WSID)
             CHGVAR     VAR(&FIL3) VALUE(AH#WP33 *CAT &WSID)
             CHGVAR     VAR(&FIL4) VALUE(AH#WP3A *CAT &WSID)
             CHGVAR     VAR(&FIL5) VALUE(AH#WP34 *CAT &WSID)
             CHGVAR     VAR(&FIL6) VALUE(AH#WP3B *CAT &WSID)
             CHGVAR     VAR(&FIL7) VALUE(AH#WP36 *CAT &WSID)
        /* MSK 98.04.07  */
             CHGVAR     VAR(&FIL8) VALUE(AH#WP47 *CAT &WSID)
             CHGVAR     VAR(&FIL9) VALUE(AH#WL47 *CAT &WSID)
             CHGVAR     VAR(&FILA) VALUE(AH#WP48 *CAT &WSID)
             CHGVAR     VAR(&FILB) VALUE(AH#WP49 *CAT &WSID)
             CHGVAR     VAR(&FILC) VALUE(AH#WP46 *CAT &WSID)
             CHGVAR     VAR(&FILD) VALUE(AH#WL46 *CAT &WSID)

             CHGVAR     VAR(&FILE) VALUE(AH#WP3I *CAT &WSID)
             CHGVAR     VAR(&FILF) VALUE(AH#WP3J *CAT &WSID)

             CHGVAR     VAR(&FIL3K)  VALUE(AH#WP3K  *CAT &WSID)
             CHGVAR     VAR(&FIL3L1) VALUE(AH#WP3L1 *CAT &WSID)
             CHGVAR     VAR(&FIL3L2) VALUE(AH#WP3L2 *CAT &WSID)
             CHGVAR     VAR(&FIL3M)  VALUE(AH#WP3M  *CAT &WSID)
             CHGVAR     VAR(&FIL3N)  VALUE(AH#WP3N  *CAT &WSID)
        /*               */

             CLRPFM     FILE(&FIL5)
             OVRDBF     FILE(AH#WP34) TOFILE(&FIL5)
             CALL       PGM(AH#RB3) PARM(&PSKJY &PSKHZ &PKOHZ &PTIME +
                          &PKOME &PHHIN &PHYMD &PHBIN)

         /*------------------------------------------------*/
         /*    かんばん調査表ＮＯ１作成                  */
         /*------------------------------------------------*/

             CLRPFM     FILE(&FIL6)
             OVRDBF     FILE(AH#WP3B) TOFILE(&FIL6)
             CALL       PGM(AH#R3A)

 /*JW1*/
             IF         COND(&FST *EQ 'Y') THEN(GOTO ED1)


             CLRPFM     FILE(&FIL7)
             FMTDTA     INFILE((&WLIB/&FIL6)) OUTFILE(&WLIB/&FIL7) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AH#S3A) +
                          OPTION(*NOPRT)

             CLRPFM     FILE(&FIL4)

             OVRPRTF    FILE(AH#PR3B) LPI(6) OVRFLW(65) +
                          RPLUNPRT(*YES) OUTQ(&OUTQ) +
                          FORMTYPE(K6H1)
             OVRDBF     FILE(AH#WP36) TOFILE(&FIL7)
             OVRDBF     FILE(AH#WP3A) TOFILE(&FIL4)
             CALL       PGM(AH#R3B) PARM(&USER &PKYM &PYMD1 &PYMD2 +
                          &PMAIS &MCEDP01)
             DLTOVR     FILE(AH#PR3B)

         /*------------------------------------------------*/
         /*    かんばん調査表ＮＯ２作成                  */
         /*------------------------------------------------*/

             CLRPFM     FILE(&FIL2)
             OVRDBF     FILE(AH#WP32) TOFILE(&FIL2)
             CALL       PGM(AH#R3C)

             IF         (%SWITCH(X0XXXXXX)) DO
             GOTO       NEXT1
             ENDDO

             CLRPFM     FILE(&FIL3)
             FMTDTA     INFILE((&WLIB/&FIL2)) OUTFILE(&WLIB/&FIL3) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AH#S3D) +
                          OPTION(*NOPRT)

             OVRPRTF    FILE(AH#PR3D) LPI(6) +
                          OVRFLW(56) RPLUNPRT(*YES) OUTQ(&OUTQ) +
                          FORMTYPE(K6H1)

             OVRDBF     FILE(AH#WP33) TOFILE(&FIL3)
             OVRDBF     FILE(AH#WP3A) TOFILE(&FIL4)
             CALL       PGM(AH#R3T) PARM(&USER &PYMD1 &PYMD2)

         /*------------------------------------------------*/
         /*    かんばん調査表ＮＯ３作成                  */
         /*------------------------------------------------*/
 /*                                                                   */
        /* MSK 98.04.07  */
 NEXT1:      IF         COND(&PSFLG *EQ 'Y') THEN(DO)
             DLTF       FILE(&FIL8)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FIL8) RCDLEN(108) +
                          OPTION(*NOLIST *NOSRC) SIZE(10000 1000 5) +
                          LVLCHK(*NO) AUT(*ALL)
             DLTF       FILE(&FIL9)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FIL9) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) SIZE(10000 1000 5) +
                          LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AH#WP34) TOFILE(&FIL5)
             OVRDBF     FILE(AH#WP47) TOFILE(&FIL8)
             CALL       PGM(AH#R3E) PARM(&PSYST)

             IF         COND(&PSYST *EQ 'NOTFND') THEN(DO)
             GOTO       NEXT4
             ENDDO

             FMTDTA     INFILE((&WLIB/&FIL8)) OUTFILE(&WLIB/&FIL9) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AH#S46) +
                          OPTION(*NOPRT)
             DLTF       FILE(&FILC)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILC) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) SIZE(10000 1000 5) +
                          LVLCHK(*NO) AUT(*ALL)
             DLTF       FILE(&FILD)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILD) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) SIZE(10000 1000 5) +
                          LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AH#WL47) TOFILE(&FIL9)
             OVRDBF     FILE(AH#WP46) TOFILE(&FILC)
             CALL       PGM(AH#R3F)

             FMTDTA     INFILE((&WLIB/&FILC)) OUTFILE(&WLIB/&FILD) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AH#S47) +
                          OPTION(*NOPRT)

             DLTF       FILE(&FILA)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILA) RCDLEN(108) +
                          OPTION(*NOLIST *NOSRC) SIZE(10000 1000 5) +
                          LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AH#WL46) TOFILE(&FILD)
             OVRDBF     FILE(AH#WP48) TOFILE(&FILA)
             CALL       PGM(AH#R3G)
/*                                                                    */
             DLTF       FILE(&FILB)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILB) RCDLEN(108) +
                          OPTION(*NOLIST *NOSRC) SIZE(10000 1000 5) +
                          LVLCHK(*NO) AUT(*ALL)
             FMTDTA     INFILE((&WLIB/&FILA)) OUTFILE(&WLIB/&FILB) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AH#S48) +
                          OPTION(*NOPRT)
             MONMSG     MSGID(FMT6050 FMT6040 FMT6020) EXEC(GOTO +
                          CMDLBL(ED1))

             OVRPRTF    FILE(AH#PR3H) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&OUTQ) +
                          FORMTYPE(K6H1)

             OVRDBF     FILE(AH#WP49) TOFILE(&FILB)
             CALL       PGM(AH#R3H) PARM(&USER &PMAIS)

             ENDDO
         /*------------------------------------------------*/
         /*    かんばん調査表ＮＯ４作成                  */
         /*------------------------------------------------*/
 /*                                                                   */
 NEXT4:      IF         COND(&PRFLG *EQ 'Y') THEN(DO)
             CLRPFM     FILE(&FILE)
             OVRDBF     FILE(AH#WP3I) TOFILE(&FILE)
             CALL       PGM(AH#R3I)

             IF         (%SWITCH(X0XXXXXX)) DO
             GOTO       ED1
             ENDDO

             CLRPFM     FILE(&FILF)
             FMTDTA     INFILE((&WLIB/&FILE)) OUTFILE(&WLIB/&FILF) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AH#S3J) +
                          OPTION(*NOPRT)
             MONMSG     MSGID(FMT6050 FMT6040 FMT6020) EXEC(GOTO +
                          CMDLBL(ED1))

             OVRPRTF    FILE(AH#PR3J) LPI(6) +
                          OVRFLW(56) RPLUNPRT(*YES) OUTQ(&OUTQ) +
                          FORMTYPE(K6H1)
 /*                                                                   */
             OVRDBF     FILE(AH#WP3J) TOFILE(&FILF)
             CALL       PGM(AH#R3J) PARM(&USER)
             ENDDO

 ED1:        DLTOVR     FILE(*ALL)

 END:        RETURN

             ENDPGM
