             PGM        PARM(&OK)
             /** AFFC71 ************************************/
             /*  COPY IFS.FC.HORIZONTAL.CSV TO AFFWP70     */
             /*  JW (SRA)    2024.04.29                    */
             /**********************************************/
             DCL        VAR(&OK)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&REC)  TYPE(*DEC)  LEN(10 0)
             DCL        VAR(&MSG1) TYPE(*CHAR) LEN(60)
             DCL        VAR(&MSG2) TYPE(*CHAR) LEN(60)

             CHGVAR     VAR(&OK) VALUE('Y')

STP1:   /************************************************************/
        /* upload IFS.FC_HORIZONTAL.csv --> AS400 HWFILE1/AFFWP70   */
        /************************************************************/
             CLRPFM     FILE(HWFILE1/AFFWP70)
             CPYFRMIMPF +
                          FROMSTMF('QNTC/IAF-AS400-FILE/AS400-TRANS/P+
                          C/Upload/IFS.FC.HORIZONTAL.csv') +
                          TOFILE(HWFILE1/AFFWP70) MBROPT(*REPLACE) +
                          FROMCCSID(*FILE) RCDDLM(*CRLF) +
                          STRDLM(*DBLQUOTE) DATFMT(*USA) +
                          TIMFMT(*USA) ERRRCDOPT(*REPLACE)
             MONMSG     MSGID(CPF2817) EXEC(GOTO CMDLBL(@ERR1))

STP2:   /* Check if 0 record or not */
             CHGVAR     VAR(&REC) VALUE(0)
             RTVMBRD    FILE(HWFILE1/AFFWP70) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             GOTO CMDLBL(@ERR1)
             ENDDO

             GOTO CMDLBL(@EXIT)

@ERR1:
             CHGVAR     VAR(&MSG1) VALUE('CHECK +
                          IFS.FC.HORIZONTAL.csv FILE!')
             CHGVAR     VAR(&MSG2) VALUE('IT IS NOT READY OR OPENNED!')
             CALL       PGM(UTLC97C) PARM((&MSG1) (&MSG2))
             CHGVAR     VAR(&OK) VALUE('N')
             GOTO CMDLBL(@EXIT)

@EXIT:
             ENDPGM
