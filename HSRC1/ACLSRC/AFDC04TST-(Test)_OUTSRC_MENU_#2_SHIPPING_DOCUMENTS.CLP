             PGM        PARM(&SUPP &SUPX)
             /** AFDC04 ****************************/
             /* SHIPPING DOCUMENTS                 */
             /* <LOCAL PROCURMENT SYSTEM>          */
             /*    CREATE DATE  2001.12.14         */
             /**************************** AFDC04 **/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&SUPP)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&SUPX)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&ODNO) TYPE(*DEC) LEN(6 0) VALUE(0)

             DCL        VAR(&MSG ) TYPE(*CHAR) LEN(30)

             RTVJOBA    JOB(&WSID)  USER(&USER)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     OUTQ(&PRTG)

             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             CHGVAR     VAR(&PLIB) VALUE('TFILE1')

             CLRPFM     FILE(&PLIB/AFAPP70)
             CLRPFM     FILE(&PLIB/AFAPP75)
             CLRPFM     FILE(&PLIB/AFAPP95)

             OVRDBF     FILE(AFAPP70) TOFILE(&PLIB/AFAPP70)
             OVRDBF     FILE(AFAPP75) TOFILE(&PLIB/AFAPP75)
             OVRDBF     FILE(AFAPP95) TOFILE(&PLIB/AFAPP95)

             CALL       PGM(AFDR04) PARM(&SUPP &SUPX &ODNO)

         /*  GOTO       CMDLBL(@END)  */

 /****** END TEST **********************************************/

     /* ONLY INITIAL ORDER NEEDS TO BE WRITTEN AFGPP01 */
             IF         COND(&ODNO *EQ 0) THEN(GOTO CMDLBL(@END))

     /* CREATE EDI ORDER SUMAMRY DATA  AFGPP01 */
             CALL       PGM(AFGR20) PARM(&SUPP &ODNO)

     /* JW  SAVE LOG */
        /*   CPYF       FROMFILE(&PLIB/AFAPP70) +                          */
        /*                TOFILE(*LIBL/AFAPP70S) MBROPT(*ADD) +            */
        /*                FMTOPT(*NOCHK)                                   */
        /*   CPYF       FROMFILE(&PLIB/AFAPP75) +                          */
        /*                TOFILE(*LIBL/AFAPP75S) MBROPT(*ADD) +            */
        /*                FMTOPT(*NOCHK)                                   */
     /* STAMP */
        /*   CHGVAR     VAR(&MSG ) VALUE('AFDC04-AFDR20 : SUMMARIZE XXXX') */
        /*   CHGVAR     VAR(%SST(&MSG 27 4)) VALUE(&SUPP)                  */
        /*   CALL       PGM(UTLR07) PARM(&MSG)                             */

 @END:
             ENDPGM
