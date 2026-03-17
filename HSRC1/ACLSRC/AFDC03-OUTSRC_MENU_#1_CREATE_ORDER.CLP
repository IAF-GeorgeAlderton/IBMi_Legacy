             PGM        PARM(&SUPP &SUPX)
             /** AFDC03 ****************************/
             /* CREATE ORDER                       */
             /* <LOCAL PROCURMENT SYSTEM>          */
             /*    CREATE DATE  2001.12.17         */
             /**************************** AFDC03 **/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&SUPP)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&SUPX)  TYPE(*CHAR) LEN(1)

             DCL        VAR(&MSG) TYPE(*CHAR) LEN(30)

             RTVJOBA    JOB(&WSID)  USER(&USER)

    /*       CHGVAR     VAR(&SUPP) VALUE('2222')  */

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)

             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CALL       PGM(AFDR03) PARM(&SUPP &SUPX)

     /* JW  SAVE LOG */
             CHGVAR     VAR(&MSG ) VALUE('AFDC03-AFDR03 : CREATE PO XXXX')
             CHGVAR     VAR(%SST(&MSG 27 4)) VALUE(&SUPP)

     /**JW   CALL       PGM(UTLR07) PARM(&MSG) **/
             CALL       PGM(UTLR07D) PARM('AFDR03' &MSG)

             ENDPGM
