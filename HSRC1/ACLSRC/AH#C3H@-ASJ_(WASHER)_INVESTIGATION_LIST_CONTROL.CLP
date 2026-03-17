             PGM        PARM(&PSKJY &PSKHZ &PKOHZ &PTIME &PKOME +
                          &PHHIN &PHYMD &PHBIN &PSYST &PSFLG &PRFLG +
                          &INVQ)
             /** AH#C3F ********************************************/
             /*  ASJ (WASHER) INVESTIGATION LIST CONTROL           */
             /*                                                    */
             /*  TCH.HYOTO  2001.05.09                             */
             /********************************** BASED ON AH#C3F ***/
             DCL        VAR(&ABBDS3)  TYPE(*CHAR) LEN(7)
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
             DCL        VAR(&PMAIS)   TYPE(*DEC)  LEN(3 0)
             DCL        VAR(&PTSURA)   TYPE(*DEC)  LEN(4 0)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PKYM)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&PDEVT)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&PSYST)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&PTOTL)   TYPE(*DEC)  LEN(3 0)
             DCL        VAR(&PSFLG)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRFLG)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&INVQ)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WKSID)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&FIL1)    TYPE(*CHAR) LEN(9)

             RTVJOBA    JOB(&WS) USER(&USER)
             RTVDTAARA  DTAARA(ABBDS3) RTNVAR(&ABBDS3)
             RTVDTAARA  DTAARA(MCEDP01) RTNVAR(&MCEDP01)
             CHGJOB     SWS(00000000)

             CHGVAR     VAR(&PKYM) VALUE(%SST(&ABBDS3 1 6))
             CHGVAR     VAR(&WKSID) VALUE(%SUBSTRING(&WS 1 3))

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGVAR     VAR(&WSID) VALUE(%SST(&WS 1 2))
             CHGVAR     VAR(&FIL1) VALUE(AH#WP30 *CAT &WSID)
             OVRDBF     FILE(AH#WP30) TOFILE(&FIL1)

    /*       OVRPRTF    FILE(AH#PR3P)  LPI(6) +
                          RPLUNPRT(*YES) OUTQ(QPRINTB) +
                          FORMTYPE(K6H1) HOLD(*NO)  */

 /*                                                                    */
 /*          CHKOBJ     OBJ(AH#WP3P) OBJTYPE(*FILE) MBR(&WKSID)        */
 /*          MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AH#WP3P) +     */
 /*                       MBR(&WKSID))                                 */
 /*          CLRPFM     FILE(AH#WP3P) MBR(&WKSID)                      */
 /*          OVRDBF     FILE(AH#WP3P) TOFILE(AH#WP3P) MBR(&WKSID)      */

             CALL       PGM(AH#R3P) PARM(&USER &PKYM &PYMD1 &PYMD2 +
                          &PMAIS &PTOTL &PTSURA &PHHIN)

         /*------------------------------------------------*/
         /*    かんばん調査表ＮＯ２作成                  */
         /*------------------------------------------------*/


    /*       OVRPRTF    FILE(AH#PR3Q) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(QPRINTB) FORMTYPE(K6H1) HOLD(*NO) */

             CALL       PGM(AH#R3Q) PARM(&USER &PYMD1 &PYMD2 &PHHIN +
                          &PMAIS &PTOTL &PTSURA &INVQ)

             DLTOVR     FILE(*ALL)

             ENDPGM
