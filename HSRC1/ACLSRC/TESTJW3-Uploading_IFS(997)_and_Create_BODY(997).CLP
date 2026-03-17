             PGM        PARM(&TOEMAIL &SUBJECT &STMF)

 /* SEND TO EMAIL ADDRESS **/
             DCL        VAR(&TOEMAIL) TYPE(*CHAR) LEN(256)
 /* SUBJECT OF EMAIL      **/
             DCL        VAR(&SUBJECT) TYPE(*CHAR) LEN(256)
 /* IFS ADDRESS           **/
             DCL        VAR(&STMF)    TYPE(*CHAR) LEN(1024)

             DCL        VAR(&BODY)    TYPE(*CHAR) LEN(5000)
             DCL        VAR(&LINE)    TYPE(*CHAR) LEN(200)
             DCL        VAR(&EOF)     TYPE(*LGL)  VALUE('0')
             DCL        VAR(&CURRLEN) TYPE(*DEC)  LEN(5 0) VALUE(0)
             DCL        VAR(&LINLEN)  TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&PLUSLEN) TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&CRLF)    TYPE(*CHAR) LEN(1) VALUE(X'25')

             DCLF       FILE(HFILE1/EDIBUF)

 /* COPY IFS TEXT FILE INTO THE PF AS ONE RECORD PER LINE. */
 /* RCDDLM(*ALL) HANDLES CR/LF/CRLF; ADJUST STMFCODPAG IF NEEDED. */

       /***  CPYFRMSTMF FROMSTMF(&STMF) +                             ***/
       /***             TOMBR('/QSYS.LIB/HFILE1.LIB/EDIBUF.FILE/EDIB+  ***/
       /***             UF.MBR') MBROPT(*REPLACE) STMFCODPAG(*STMF)   ***/

             CPYFRMIMPF FROMSTMF(&STMF) TOFILE(HFILE1/EDIBUF) +
                          MBROPT(*REPLACE) FROMCCSID(*FILE) +
                          RCDDLM(*CRLF) STRDLM(*DBLQUOTE) +
                          DATFMT(*USA) TIMFMT(*USA) ERRRCDOPT(*REPLACE)

             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
             MSGDTA('FAILED TO COPY STREAM FILE &STMF') MSGTYPE(*ESCAPE)
             ENDDO

             OVRDBF     FILE(EDIBUF) TOFILE(HFILE1/EDIBUF)
 /*****ﾀﾑ    DCLF       FILE(HFILE1/EDIBUF)              ****/

              CHGVAR     VAR(&BODY) VALUE('   ')

   READLOOP:  RCVF
              MONMSG     MSGID(CPF0864) EXEC(DO)  /* END OF FILE */
                CHGVAR   VAR(&EOF) VALUE('1')
              ENDDO

              IF         COND(&EOF) THEN(GOTO CMDLBL(SENDIT))
 /* &EDIBUF IS THE IMPLICIT FIELD NAME FROM DCLF; MOVE INTO &LINE  */
        /**   CHGVAR     VAR(&LINE) VALUE(&EDIBUF) **/
              CHGVAR     VAR(&LINE) VALUE(&XBUF)

 /* DETERMINE LINE LENGTH (RIGHT-TRIM BLANKS) */
        /**   CHGVAR     VAR(&LINLEN) VALUE(%SST(&LINE 1 200)) **/
              CHGVAR     VAR(&LINLEN) VALUE(78)

 /* USE %TRIMR VIA RTVJOBA? CL LACKS TRIM; EMULATE BY STRIPPING       */
 /* TRAILING BLANKS.                                                  */
 /* SIMPLE APPROACH: NOT STRICTLY NEEDED FOR FIXED COLUMNS. WE'LL     */
 /* KEEP AS-IS. */

 /* COMPUTE LENGTH IF WE ADD THIS LINE + NEWLINE (X'25') */
              CHGVAR     VAR(&PLUSLEN) VALUE(&CURRLEN + 1 + 200)

 /* SAFER PRECISE CALC: FIND LAST NON-BLANK CHAR IN &LINE TO AVOID OVERFLOW */

/* BECAUSE CL LACKS INTRINSIC TRIM LENGTH, WE'LL APPROXIMATE BY            */
/* ADDING ENTIRE 200 AND IT STILL                                          */
/* STAYS WELL UNDER 5000 FOR TYPICAL REPORTS. IF YOU HAVE VERY LONG FILES, */
/* CONSIDER TRIMMING OR REDUCING RCDLEN. */
IF         COND(&PLUSLEN *GT 5000) THEN(GOTO CMDLBL(SENDIT))

/* APPEND LINE AND NEWLINE (EBCDIC NL X'25'); SMTP WILL TRANSLATE TO CRLF */

      /***   CHGVAR     VAR(&BODY) VALUE(&BODY *CAT &LINE *TCAT &CRLF)  **/
             CHGVAR     VAR(&BODY) VALUE(&BODY *TCAT &LINE *TCAT &CRLF)

             CHGVAR     VAR(&CURRLEN) VALUE(&CURRLEN + 200 + 1)

             GOTO       CMDLBL(READLOOP)

  SENDIT:    /* SEND THE EMAIL WITH THE COLLECTED BODY CONTENT */

             SNDSMTPEMM RCP((&TOEMAIL *PRI)) +
                          SUBJECT(&SUBJECT) +
                          NOTE(&BODY) +
                          CONTENT(*PLAIN)

             DLTOVR     FILE(EDIBUF)
             ENDPGM
