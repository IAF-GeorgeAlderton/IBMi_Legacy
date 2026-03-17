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

             CLRPFM     FILE(&PLIB/AFAPP70)
             CLRPFM     FILE(&PLIB/AFAPP75)
             CLRPFM     FILE(&PLIB/AFAPP95)

             CALL       PGM(AFDR04) PARM(&SUPP &SUPX &ODNO)

     /* ONLY INITIAL ORDER NEEDS TO BE WRITTEN AFGPP01 */
             IF         COND(&ODNO *EQ 0) THEN(GOTO CMDLBL(@END))

     /* CREATE EDI ORDER SUMAMRY DATA  AFGPP01 */
             CALL       PGM(AFGR20) PARM(&SUPP &ODNO)

     /* JW  SAVE LOG */
             CPYF       FROMFILE(&PLIB/AFAPP70) +
                          TOFILE(*LIBL/AFAPP70S) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             CPYF       FROMFILE(&PLIB/AFAPP75) +
                          TOFILE(*LIBL/AFAPP75S) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             CPYF       FROMFILE(&PLIB/AFAPP95) +
                          TOFILE(*LIBL/AFAPP95S) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)

             CHGVAR     VAR(&MSG ) VALUE('AFDC04-AFGR20 : SUMMARIZE XXXX')
             CHGVAR     VAR(%SST(&MSG 27 4)) VALUE(&SUPP)

     /**JW   CALL       PGM(UTLR07) PARM(&MSG)   **/
             CALL       PGM(UTLR07D) PARM('AFGR20' &MSG)

 @END:
             ENDPGM
