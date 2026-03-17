             PGM
             /** AFCC91 ****************************/
             /* FINAL ORDER CONFIRM PROCESS        */
             /* <LOCAL PROCURMENT SYSTEM>          */
             /*    CREATE DATE  2001.06.22         */
             /* JW1   04/05/2019 ADD SAVE LOG      */
             /**************************************/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&ODNO)  TYPE(*DEC) LEN(5)
             RTVJOBA    JOB(&WSID)  USER(&USER)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)

             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CLRPFM     FILE(AFAPP70)
             CLRPFM     FILE(AFAPP75)
             CLRPFM     FILE(AFCWP90)

             OVRPRTF    FILE(QPRINT) PAGESIZE(66 80) OVRFLW(56) +
                          OUTQ(LANPRT02) FORMTYPE(K6S1) COPIES(2)

             CALL       PGM(AFCR91) PARM(&USER)

/* JW  SAVE LOG */
             CPYF       FROMFILE(*LIBL/AFAPP70) +
                          TOFILE(*LIBL/AFAPP70S) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             CPYF       FROMFILE(*LIBL/AFAPP75) +
                          TOFILE(*LIBL/AFAPP75S) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)

     /**JW   CALL       PGM(UTLR07) PARM('AFCC91-->AFCR91 FINAL PO  CONF') **/
             CALL       PGM(UTLR07D) PARM('AFCR91' 'AFCC91-->AFCR91 +
                          FINAL PO  CONF')


 @END:       ENDPGM
