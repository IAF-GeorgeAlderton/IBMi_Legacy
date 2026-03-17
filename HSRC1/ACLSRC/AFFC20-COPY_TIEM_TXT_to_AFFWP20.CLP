             PGM
             /** AFFC20 ************************************/
             /*  CREATE TIEM LABEL WORKFILE - AFFWP20B     */
             /*  LEC         2020.04.24                    */
             /**********************************************/
             DCL        VAR(&REC)  TYPE(*DEC)  LEN(10 0)

             CLRPFM     FILE(HWFILE1/AFFWP20)
             CLRPFM     FILE(HWFILE1/AFFWP20B)
             CLRPFM     FILE(HWFILE1/AFFWP20F)

STP1:   /*********************************************************/
        /* upload TIEM.TXT --> AS400 HWFILE1/AFFWP20             */
        /*********************************************************/
             CPYFRMIMPF +
                          FROMSTMF('/QNTC/IAF-AS400-FILE/AS400-TRANS/+
                          PC/Upload/TIEM +
                          Labels/TIEM-Label-Data.txt') +
                          TOFILE(HWFILE1/AFFWP20) MBROPT(*REPLACE) +
                          FROMCCSID(*FILE) RCDDLM(*CRLF) +
                          DTAFMT(*DLM) STRDLM(*DBLQUOTE) +
                          RMVBLANK(*NONE) FLDDLM('|') DATFMT(*USA) +
                          TIMFMT(*USA) ERRRCDOPT(*REPLACE)
             MONMSG     MSGID(CPF2817) EXEC(GOTO CMDLBL(@ERR1))

STP2:   /* Check if 0 record or not */
             CHGVAR     VAR(&REC) VALUE(0)
             RTVMBRD    FILE(HWFILE1/AFFWP20) NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(DO)
             GOTO CMDLBL(@ERR1)
             ENDDO

STP3:   /* Process uploaded file.      AFFWP20 --> AFFWP20B    */
             CALL       PGM(AFFR020)

STP4:   /* Sort file into Reverse Pull Sequence, last to first */
        /*                          AFFWP20B  -->  AFFWP20F    */
             CALL       PGM(AFFR20)

STP5:   /* Clear original output file and copy sorted file back in */
        /*                          AFFWP20F  -->  AFFWP20B    */
             CLRPFM     FILE(AFFWP20B)
             CPYF       FROMFILE(AFFWP20F) TOFILE(AFFWP20B) +
                          MBROPT(*ADD) FMTOPT(*MAP *DROP)

        /***************************************************************/
STP6:   /* Copy sorted output file back to IFS directory to be printed */
        /* download AS400 HWFILE1/AFFWP20B  ---> TIEM-Label-Data.txt   */
        /***************************************************************/
             CPYTOIMPF  FROMFILE(HWFILE1/AFFWP20B) +
                          TOSTMF('/QNTC/IAF-AS400-FILE/AS400-TRANS/PC+
                          /Download/TIEM +
                          Labels/TIEM-Label-Data.txt') +
                          MBROPT(*REPLACE) RCDDLM(*CRLF) +
                          RMVBLANK(*BOTH) FLDDLM(',') DATFMT(*USA) +
                          TIMFMT(*USA)
             MONMSG     MSGID(CPF0000)

             CPYTOIMPF  FROMFILE(HWFILE1/AFFWP20B) +
                          TOSTMF('/QNTC/IAF-AS400-FILE/AS400-TRANS/PC+
                          /Download/TIEM +
                          Labels/TIEM-Label-Data.txt') +
                          MBROPT(*REPLACE) RCDDLM(*CRLF) +
                          RMVBLANK(*BOTH) FLDDLM(',') DATFMT(*USA) +
                          TIMFMT(*USA)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(QUILNGTX) PARM('PROCESS COMPLETE - +
                          J:Download/TIEM Labels/TIEM-Label-Data.txt +
                          is Ready.' X'00000046' ' ' +
                          ' ' X'00000000')

             GOTO CMDLBL(@EXIT)

@ERR1:
             CALL       PGM(QUILNGTX) PARM('CHECK +
                          J:upload/TIEM-Label-Data.txt. FILE NOT +
                          READY OR FILE IS OPENED.' X'00000046' ' ' +
                          ' ' X'00000000')
             GOTO CMDLBL(@EXIT)

@EXIT:
             ENDPGM
