             PGM
             /** SNDC25  *********************************************/
             /*  SET SPOOL FL AND SEND BODY(997) BY MAIL USING PF    */
             /*  (PF: SPLPP01)                                       */
             /*  J.W  2025.10.28                                     */
             /* (FLOW) ----------------------------------------------*/
             /*  (1) SET PARAMETERS                                  */
             /*  (2) CHANGE SPOOL TO PF                              */
             /*  (3) MAKE BODY FROM PF                               */
             /*  (4) SEND EMAIL WITH BODY                            */
             /********************************************************/

             DCL        VAR(&TOEMAIL) TYPE(*CHAR) LEN(100)
             DCL        VAR(&SUBJECT) TYPE(*CHAR) LEN(100)

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)

             DCL        VAR(&BODY)    TYPE(*CHAR) LEN(5000)
             DCL        VAR(&LINE)    TYPE(*CHAR) LEN(132)
             DCL        VAR(&CURRLEN) TYPE(*DEC)  LEN(5 0) VALUE(0)
             DCL        VAR(&LINLEN)  TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&PLUSLEN) TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&CRLF)    TYPE(*CHAR) LEN(1) VALUE(X'25')

             DCLF       FILE(HFILE1/SPLPP01)

/* (1) SET PARAMETERS  ****************************************************/
/*     SET EMAIL ADDRESS                                                  */
             CHGVAR     VAR(&TOEMAIL) VALUE('AS400-SYSTEM@IAFI.COM')
/*     SET SUBJECT                                                        */
             CHGVAR     VAR(&SUBJECT) VALUE('EDI (FORD997) OK - GENTRAN')

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

 /* (2) TRANSFER QPRINT TO PF (HFILE1/SPLPP01 ) ***************************/

             CLRPFM     FILE(HFILE1/SPLPP01)
             CPYSPLF    FILE(QPRINT) TOFILE(HFILE1/SPLPP01) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)

             DLTSPLF    FILE(QPRINT) JOB(&NBR/&USER/&WSID) +
                          SPLNBR(*LAST)

             CHGVAR     VAR(&BODY) VALUE('   ')

 /* (3) CREATE EMAIL BODY WITH CRLF(X'25') FROM PF ************************/

   READLOOP: RCVF

 /* END OF FILE                                                    */
             MONMSG     MSGID(CPF0864) EXEC(DO)
             GOTO CMDLBL(SENDIT)
             ENDDO

             CHGVAR     VAR(&LINE) VALUE(&PLIN01)
             CHGVAR     VAR(&LINLEN) VALUE(132)

 /* COMPUTE LENGTH IF WE ADD THIS LINE + NEWLINE (X'25')                   */
              CHGVAR     VAR(&PLUSLEN) VALUE(&CURRLEN + 1 + &LINLEN)

 /* AVOID OVERFLOW                                                         */
             IF         COND(&PLUSLEN *GT 5000) THEN(GOTO CMDLBL(SENDIT))

/* APPEND LINE AND NEWLINE (X'25')                                         */
             CHGVAR     VAR(&BODY) VALUE(&BODY *TCAT &LINE *TCAT &CRLF)
             CHGVAR     VAR(&CURRLEN) VALUE(&CURRLEN + 1 + &LINLEN)
             GOTO       CMDLBL(READLOOP)

 /* (4) SEND EMAIL WITH BOBY ***********************************************/

  SENDIT:
             SNDSMTPEMM RCP(&TOEMAIL ) +
                          SUBJECT(&SUBJECT) NOTE(&BODY) CONTENT(*PLAIN)

             ENDPGM
