             PGM        PARM(&PSKJY &PSKHZ &PKOHZ &PTIME &PKOME +
                          &PHHIN &PHYMD &PHBIN &PTTTT)
             /** AH#C3B **************************************/
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
             DCL        VAR(&PSKJY)   TYPE(*CHAR) LEN(2)
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
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
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
       /*              */
             DCL        VAR(&WLIB)    TYPE(*CHAR) LEN(8)
             DCL        VAR(&OUTQ)    TYPE(*CHAR) LEN(8)
             DCL        VAR(&PTTTT) TYPE(*DEC) LEN(10 1)

             RTVJOBA    JOB(&WS) USER(&USER)
             RTVDTAARA  DTAARA(ABADS1) RTNVAR(&ABADS1)
             RTVDTAARA  DTAARA(MCEDP01) RTNVAR(&MCEDP01)
             CHGJOB     SWS(00000000)

           /*--------------------------------------------*/
           /*    CHECK ENVIRONMENT                        */
           /*--------------------------------------------*/
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             CHGVAR     VAR(&PKYM) VALUE(%SST(&ABADS1 1 6))

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

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
             DLTF       FILE(&FIL5)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FIL5) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AH#WP34) OPTION(*NOLIST *NOSRC) +
                          SIZE(10000 1000 3) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&FIL6)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FIL6) RCDLEN(180) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&FIL7)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FIL7) RCDLEN(180) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

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

             CLRPFM     FILE(&FIL7)
             FMTDTA     INFILE((&WLIB/&FIL6)) OUTFILE(&WLIB/&FIL7) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AH#S3A) +
                          OPTION(*NOPRT)

             DLTF       FILE(&FIL4)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FIL4) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AH#WP3A) OPTION(*NOLIST *NOSRC) +
                          SIZE(10000 1000 3) LVLCHK(*NO) AUT(*ALL)

             CLRPFM     FILE(&FIL4)

             OVRPRTF    FILE(AH#PR3B) LPI(6) OVRFLW(65) +
                          RPLUNPRT(*YES) OUTQ(&OUTQ) FORMTYPE(K6H1) +
                          HOLD(*YES)
             OVRDBF     FILE(AH#WP36) TOFILE(&FIL7)
             OVRDBF     FILE(AH#WP3A) TOFILE(&FIL4)
             CALL       PGM(AH#R3B) PARM(&USER &PKYM &PYMD1 &PYMD2 +
                          &PMAIS &MCEDP01)
             DLTOVR     FILE(AH#PR3B)
             DLTSPLF    FILE(AH#PR3B) SPLNBR(*LAST)

         /*------------------------------------------------*/
         /*    かんばん調査表ＮＯ２作成                  */
         /*------------------------------------------------*/
             DLTF       FILE(&FIL2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FIL2) RCDLEN(200) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&FIL3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FIL3) RCDLEN(200) +
                          OPTION(*NOLIST) SIZE(10000 1000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             CLRPFM     FILE(&FIL2)
             OVRDBF     FILE(AH#WP32) TOFILE(&FIL2)
             CALL       PGM(AH#R3C)

             IF         (%SWITCH(X0XXXXXX)) DO
             GOTO       ED1
             ENDDO

             CLRPFM     FILE(&FIL3)
             FMTDTA     INFILE((&WLIB/&FIL2)) OUTFILE(&WLIB/&FIL3) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AH#S3D) +
                          OPTION(*NOPRT)

             OVRPRTF    FILE(AH#PR3D) LPI(6) OVRFLW(56) +
                          RPLUNPRT(*YES) OUTQ(&OUTQ) FORMTYPE(K6H1) +
                          HOLD(*YES)

             OVRDBF     FILE(AH#WP33) TOFILE(&FIL3)
             OVRDBF     FILE(AH#WP3A) TOFILE(&FIL4)
             CALL       PGM(ANYR3T) PARM(&USER &PYMD1 &PYMD2 &PTTTT)
             DLTSPLF    FILE(AH#PR3D) SPLNBR(*LAST)

 ED1:        DLTOVR     FILE(*ALL)
 END:        RETURN

             ENDPGM
