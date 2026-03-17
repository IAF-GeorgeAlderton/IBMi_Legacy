             PGM
             /** MSGC0 ***********************************************/
             /*  SERACH MSGW FROM WRKACTJOB                          */
             /*  ( COMMAND "MSGW" IS USING THIS CL )                 */
             /*  J.WATANABE 2025.03.06                               */
             /********************************************************/
             DCL        VAR(&WSID)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT)      TYPE(*CHAR) LEN(3)
             DCL        VAR(&CHKWPU1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&REC)     TYPE(*DEC)  LEN(10 0) VALUE(0)
             DCL        VAR(&MSG1)    TYPE(*CHAR) LEN(60)
             DCL        VAR(&MSG2)    TYPE(*CHAR) LEN(60)

             CALL       PGM(CHKCU0)

             RTVJOBA    JOB(&WSID)
             CHGVAR     VAR(&WT) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&CHKWPU1) VALUE('CHKWPU1' *CAT &WT)

             CHGVAR     VAR(&CHKWPU1) VALUE('CHKWPU1' *CAT &WT)
             CLRPFM     FILE(HWFILE1/CHKWPJ42)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(CHKWPU1) TOFILE(HWFILE1/&CHKWPU1)
             CALL       PGM(CHKRJ42)

             RTVMBRD    FILE(HWFILE1/CHKWPJ42) NBRCURRCD(&REC)
             IF         (&REC *NE 0) THEN(DO)
  /* IAF */
             SNDDST     TYPE(*FILE) +
                          TOINTNET(('KAZ.WATANABE@IAFI.com')) +
                          DSTD('** FOUND MSGW **') MSG('!! REPLY +
                          FOR MSGW !! (MSGC01)') +
                          DOCFILE(HWFILE1/CHKWPJ42) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('** MSGW **')

             CHGVAR     VAR(&MSG1) VALUE('!! "MSGW" exists in Active +
                          Jobs !!')
             CALL       PGM(UTLC97A) PARM(&MSG1 &MSG2)
             ENDDO

             DLTOVR     FILE(*ALL)

             ENDPGM
