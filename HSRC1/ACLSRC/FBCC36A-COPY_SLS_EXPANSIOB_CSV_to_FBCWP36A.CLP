             PGM        PARM(&OK)
             /** AFFC11 ************************************/
             /*  COPY SLS-EXPANSION.CSV TO FBCWP36A        */
             /*  JW (SRA)    2021.05.20                    */
             /**********************************************/
             DCL        VAR(&OK)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&REC)  TYPE(*DEC)  LEN(10 0)

             CHGVAR     VAR(&OK) VALUE('Y')

STP1:   /*********************************************************/
        /* upload SLS-EXPANSION.csv --> AS400 HWFILE1/FBCWP36A   */
        /*********************************************************/
             CLRPFM     FILE(HWFILE1/FBCWP36A)
             CPYFRMIMPF +
                          FROMSTMF('QNTC/IAF-AS400-FILE/AS400-TRANS/S+
                          ales/Upload/SLS-EXPANSION.csv') +
                          TOFILE(HWFILE1/FBCWP36A) MBROPT(*REPLACE) +
                          FROMCCSID(*FILE) RCDDLM(*CRLF) +
                          STRDLM(*DBLQUOTE) DATFMT(*USA) +
                          TIMFMT(*USA) ERRRCDOPT(*REPLACE)
             MONMSG     MSGID(CPF2817) EXEC(GOTO CMDLBL(@ERR1))

STP2:   /* Check if 0 record or not */
             CHGVAR     VAR(&REC) VALUE(0)
             RTVMBRD    FILE(HWFILE1/FBCWP36A) NBRCURRCD(&REC)
             IF         COND(&REC *NE 0) THEN(DO)
             GOTO CMDLBL(@EXIT)
             ENDDO
@ERR1:
             CALL       PGM(QUILNGTX) PARM('CHECK SLS-EXPANSION.CSV. FILE +
                          NOT READY OR FILE IS OPENNED.' +
                          X'00000046' ' ' ' ' X'00000000')
             CHGVAR     VAR(&OK) VALUE('N')
             GOTO CMDLBL(@EXIT)
@EXIT:
             ENDPGM
