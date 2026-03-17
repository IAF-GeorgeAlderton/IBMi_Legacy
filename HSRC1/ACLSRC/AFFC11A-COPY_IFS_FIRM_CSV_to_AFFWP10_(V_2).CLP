             PGM        PARM(&OK)
             /** AFFC11A ***********************************/
             /*  COPY IFS.FIRM.CSV TO AFFWP10              */
             /*  JW (SRA)    2018.06.08                    */
             /**********************************************/
             DCL        VAR(&OK)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&REC)  TYPE(*DEC)  LEN(10 0)

             CHGVAR     VAR(&OK) VALUE('Y')

STP1:   /*********************************************************/
        /* upload IFS.FIRM.csv --> AS400 QTEMP/AFFWP10           */
        /*********************************************************/
             CLRPFM     FILE(QTEMP/AFFWP10)
             CPYFRMIMPF +
                          FROMSTMF('QNTC/IAF-AS400-FILE/AS400-TRANS/P+
                          C/Upload/IFS.FIRM.csv') +
                          TOFILE(QTEMP/AFFWP10) MBROPT(*REPLACE) +
                          FROMCCSID(*FILE) RCDDLM(*CRLF) +
                          STRDLM(*DBLQUOTE) DATFMT(*USA) +
                          TIMFMT(*USA) ERRRCDOPT(*REPLACE)
             MONMSG     MSGID(CPF2817) EXEC(GOTO CMDLBL(@ERR1))

STP2:   /* Check if 0 record or not */
             CHGVAR     VAR(&REC) VALUE(0)
             RTVMBRD    FILE(QTEMP/AFFWP10) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             GOTO CMDLBL(@ERR1)
             ENDDO

             GOTO CMDLBL(@EXIT)

@ERR1:
             CALL       PGM(QUILNGTX) PARM('CHECK IFS.FIRM.CSV. FILE +
                          NOT READY OR FILE IS OPENNED.' +
                          X'00000046' ' ' ' ' X'00000000')
             CHGVAR     VAR(&OK) VALUE('N')
             GOTO CMDLBL(@EXIT)

@EXIT:
             ENDPGM
