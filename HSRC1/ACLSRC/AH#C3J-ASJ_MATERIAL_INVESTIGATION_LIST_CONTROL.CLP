/* TCHK1     PGM        PARM(&PKOHZ &PTIME &PKOME +
                          &PHZAIS &PHZAIK &PHYMD &PHBIN &PSYST &OUTQ) */
/* TCHK1 */  PGM        PARM(&PKOHZ &PTIME &PKOME +
/* TCHK1 */               &PHZAIS &PHZAIK &PHYMD &PHBIN &PSYST +
/* TCHK1 */               &OUTQ &PKAKE)
             /** AH#C3J ********************************************/
             /*  ASJ MAETERIAL INVESTIGATION LIST CONTROL          */
             /*                                                    */
             /*             07/20/01                               */
             /*       TCH.AMANO  2002.08.26 CHANGE OUTQ      */
             /*       TCH.AMANO  2003.02.10 CHANGE DATARA    */
             /*       TCH62      2005.05.12 ADDED PRINT OPT  */
             /*       TCHK1      2005.11.23 CHG FOR MULTI SUPPLIER */
             /******************************************************/
     /*      DCL        VAR(&ABBDS3)  TYPE(*CHAR) LEN(7)   */
             DCL        VAR(&ABADS1)  TYPE(*CHAR) LEN(48)
             DCL        VAR(&PKOME)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PKOHZ)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&PTIME)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&PHZAIS)   TYPE(*CHAR) LEN(15)
             DCL        VAR(&PHZAIK)   TYPE(*DEC)  LEN(5 2)
             DCL        VAR(&PHYMD)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&PHBIN)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&PYMD1)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&PYMD2)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&PMAIS)   TYPE(*DEC)  LEN(3 0)
             DCL        VAR(&PTSURA)   TYPE(*DEC)  LEN(4 0)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PKYM)    TYPE(*CHAR) LEN(6)
             DCL        VAR(&PSYST)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&PTOTL)   TYPE(*DEC)  LEN(3 0)
             DCL        VAR(&OUTQ)    TYPE(*CHAR) LEN(8)
/* TCHK1 */  DCL        VAR(&PKAKE)   TYPE(*CHAR) LEN(4)

             RTVJOBA    JOB(&WS) USER(&USER)

       /*    RTVDTAARA  DTAARA(ABBDS3) RTNVAR(&ABBDS3)  */
             RTVDTAARA  DTAARA(ABADS1) RTNVAR(&ABADS1)
        /*   CHGVAR     VAR(&PKYM) VALUE(%SST(&ABBDS3 1 6)) */
             CHGVAR     VAR(&PKYM) VALUE(%SST(&ABADS1 1 6))

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYPE &PRTG)

   /*TCH62   STRPRTWTR DEV(PC) OUTQ(QPRINTC) MSGQ(WBSS1)               */
   /*TCH62   MONMSG    MSGID(CPF3310 CPF3396 CPF3347 CPF3363 CPF0000)  */



   /*TCH62   OVRPRTF    FILE(AH#PR38)  LPI(6) +
                          RPLUNPRT(*YES) OUTQ(QPRINTC) +
                          FORMTYPE(K6H1) HOLD(*NO)      */
             OVRPRTF    FILE(AH#PR38)  LPI(6) +
                          RPLUNPRT(*YES) OUTQ(&OUTQ)   +
                          FORMTYPE(K6H1) HOLD(*NO)


/* TCHK1     CALL       PGM(AH#R38) PARM(&USER &PKYM &PYMD1 &PYMD2 +
                          &PMAIS &PTOTL &PTSURA &PHZAIS &PHZAIK) */
/* TCHK1 */  CALL       PGM(AH#R38) PARM(&USER &PKYM &PYMD1 &PYMD2 +
/* TCHK1 */               &PMAIS &PTOTL &PTSURA &PHZAIS &PHZAIK +
/* TCHK1 */               &PKAKE)

         /*------------------------------------------------*/
         /*    INVESTIGATION #2                            */
         /*------------------------------------------------*/


   /* TCH62  OVRPRTF    FILE(AH#PR39) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(QPRINTC) FORMTYPE(K6H1) HOLD(*NO) */
             OVRPRTF    FILE(AH#PR39) LPI(6) RPLUNPRT(*YES) +
                          OUTQ(&OUTQ)   FORMTYPE(K6H1) HOLD(*NO)

/* TCHK1     CALL       PGM(AH#R39) PARM(&USER &PYMD1 &PYMD2 &PHZAIS +
                  &PHZAIK &PMAIS &PTOTL &PTSURA) */
/* TCHK1 */  CALL       PGM(AH#R39) PARM(&USER &PYMD1 &PYMD2 &PHZAIS +
/* TCHK1 */       &PHZAIK &PMAIS &PTOTL &PTSURA &PKAKE)

             DLTOVR     FILE(*ALL)

             ENDPGM
