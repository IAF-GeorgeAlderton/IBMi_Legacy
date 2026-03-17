             PGM
             /* AFBC92 ****************************************/
             /* RE-CREATE BILL OF LADING                      */
             /* <LOCAL PROCURMENT SYSTEM>                     */
             /* CREATE DATE  2000.11.21                       */
             /*------------------------------------------     */
             /* TCHK1 09/07/2010 CHG OUTQ                     */
             /* JW2   08/02/2023 ADD EXCLUSIVE FLAG CHKC45O   */
             /**************************** ********************/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&ODNO)  TYPE(*DEC) LEN(5)
             DCL        VAR(&RTN1)  TYPE(*CHAR) LEN(1)

/* JW2 CHECK OTHER USER IS USING  ==================================*/
             CALL CHKC45 ('AFBC91' 'AFBC92' 'Y'  'CHK' &RTN1)
             IF         COND(&RTN1 *NE ' ') THEN(GOTO @END)
/* =================================================================*/

             RTVJOBA    JOB(&WSID)  USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHGJOB     SWS(00000000)
             CHGJOB     OUTQ(&PRTG)

             CLRPFM     FILE(*LIBL/AFAPP70)
             CLRPFM     FILE(*LIBL/AFAPP75)

/* TCHK1 */  OVRPRTF    FILE(QPRINT) PAGESIZE(66 80) OVRFLW(54) +
                          OUTQ(SAVEOUTQ) FORMTYPE(K6S1) COPIES(2)

             CALL       PGM(AFBR92) PARM(&USER)

/* JW  SAVE LOG */
             CPYF       FROMFILE(*LIBL/AFAPP70) +
                          TOFILE(*LIBL/AFAPP70S) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             CPYF       FROMFILE(*LIBL/AFAPP75) +
                          TOFILE(*LIBL/AFAPP75S) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)

     /** JW  CALL       PGM(UTLR07) PARM('AFBC92-->AFBR92 RE-CREATE B/L ')  **/
             CALL       PGM(UTLR07D) PARM('AFBR92' 'AFBC92-->AFBR92 +
                          RE-CREATE B/L ')

       /*JW2* RESET EXCLUSIVE FLAG **/
             CALL CHKC45 ('AFBC91' 'AFBC92' 'N'  '' '')

 @END:       ENDPGM
