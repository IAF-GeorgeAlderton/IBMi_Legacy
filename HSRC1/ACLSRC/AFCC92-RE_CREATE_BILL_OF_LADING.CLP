             PGM
             /** AFCC92 ****************************/
             /* RE-CREATE BILL OF LADING           */
             /*  <LOCAL PROCURMENT SYSTEM>         */
             /*  N.HYOTO 2001.06.25                */
             /* JW1   04/05/19 ADD SAVE LOG        */
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

             CLRPFM     FILE(*LIBL/AFAPP70)
             CLRPFM     FILE(*LIBL/AFAPP75)
             CLRPFM     FILE(*LIBL/AFCWP90)

             OVRPRTF    FILE(QPRINT) PAGESIZE(66 80) OVRFLW(54) +
                          OUTQ(LANPRT02) FORMTYPE(K6S1) COPIES(2)

             CALL       PGM(AFCR92) PARM(&USER)

/* JW  SAVE LOG */
             CPYF       FROMFILE(*LIBL/AFAPP70) +
                          TOFILE(*LIBL/AFAPP70S) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             CPYF       FROMFILE(*LIBL/AFAPP75) +
                          TOFILE(*LIBL/AFAPP75S) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)

     /**JW   CALL       PGM(UTLR07) PARM('AFCC92-->AFCR92 RE-CREATE B/L ')  **/
             CALL       PGM(UTLR07D) PARM('AFCR92' 'AFCC92-->AFCR92 +
                          RE-CREATE B/L ')


 @END:       ENDPGM
