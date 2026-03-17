             PGM
             /** AFFC61 ************************************/
             /*  COPY TMQTY.CSV TO AFFWP60 AND AFFWP61     */
             /*  JW (SRA)    2024.03.18                    */
             /**********************************************/
             DCL        VAR(&REC)  TYPE(*DEC)  LEN(10 0)

STP1:   /*********************************************************/
        /* upload TMQTY.CSV --> AS400 HWFILE1/AFFWP60            */
        /*********************************************************/
             CLRPFM     FILE(HWFILE1/AFFWP60)
             CPYFRMIMPF +
                          FROMSTMF('QNTC/IAF-AS400-FILE/AS400-TRANS/A+
                          ccounting/Upload/TMQTY.csv') +
                          TOFILE(HWFILE1/AFFWP60) MBROPT(*REPLACE) +
                          FROMCCSID(*FILE) RCDDLM(*CRLF) +
                          STRDLM(*DBLQUOTE) DATFMT(*USA) +
                          TIMFMT(*USA) ERRRCDOPT(*REPLACE)
             MONMSG     MSGID(CPF2817) EXEC(GOTO CMDLBL(@ERR1))

STP2:   /* Check if 0 record or not */
             CHGVAR     VAR(&REC) VALUE(0)
             RTVMBRD    FILE(HWFILE1/AFFWP60) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             GOTO CMDLBL(@ERR1)
             ENDDO

             GOTO CMDLBL(@NEXT)

@ERR1:
             CALL       PGM(QUILNGTX) PARM('CHECK TMQTY.CSV. FILE +
                          NOT READY OR FILE IS OPENNED.' +
                          X'00000046' ' ' ' ' X'00000000')
             GOTO CMDLBL(@NEXT)

@NEXT:
             CALL       PGM(AFFC61B)

             ENDPGM
