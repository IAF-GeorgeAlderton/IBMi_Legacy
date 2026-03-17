             PGM
      /**    PGM        PARM(&OK)    **/
             /** AFFC41 ************************************/
             /*  COPY TMPRICE.CSV TO AFFWP40               */
             /*  JW (SRA)    2022.02.16                    */
             /**********************************************/
         /** DCL        VAR(&OK)   TYPE(*CHAR) LEN(1) **/
             DCL        VAR(&REC)  TYPE(*DEC)  LEN(10 0)

         /** CHGVAR     VAR(&OK) VALUE('Y') **/

STP1:   /*********************************************************/
        /* upload TMPRICE.csv --> AS400 HWFILE1/AFFWP40          */
        /*********************************************************/
             CLRPFM     FILE(HWFILE1/AFFWP40)
             CPYFRMIMPF +
                          FROMSTMF('QNTC/IAF-AS400-FILE/AS400-TRANS/A+
                          ccounting/Upload/TMPRICE.csv') +
                          TOFILE(HWFILE1/AFFWP40) MBROPT(*REPLACE) +
                          FROMCCSID(*FILE) RCDDLM(*CRLF) +
                          STRDLM(*DBLQUOTE) DATFMT(*USA) +
                          TIMFMT(*USA) ERRRCDOPT(*REPLACE)
             MONMSG     MSGID(CPF2817) EXEC(GOTO CMDLBL(@ERR1))

STP2:   /* Check if 0 record or not */
             CHGVAR     VAR(&REC) VALUE(0)
             RTVMBRD    FILE(HWFILE1/AFFWP40) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             GOTO CMDLBL(@ERR1)
             ENDDO

             GOTO CMDLBL(@NEXT)

@ERR1:
             CALL       PGM(QUILNGTX) PARM('CHECK TMPRICE.CSV. FILE +
                          NOT READY OR FILE IS OPENNED.' +
                          X'00000046' ' ' ' ' X'00000000')
        /**  CHGVAR     VAR(&OK) VALUE('N')  **/
             GOTO CMDLBL(@NEXT)

@NEXT:
             CALL       PGM(AFFC41B)

             ENDPGM
