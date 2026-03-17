             PGM
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0) VALUE(0)
             RTVJOBA    JOB(&WSID)

             CHKOBJ     OBJ(HWFILE1/PART_NO) OBJTYPE(*FILE) AUT(*ALL)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                 SNDMSG     MSG('NOT FOUND !') TOUSR(&WSID)
                 GOTO EXIT
             ENDDO
             RTVMBRD    FILE(HWFILE1/PART_NO) NBRCURRCD(&REC)
             IF (&REC *EQ 0) DO
                 SNDMSG     MSG('NOT FOUND !') TOUSR(&WSID)
                 GOTO EXIT
             ENDDO
             OVRDBF INPUT HWFILE1/PART_NO
             CALL FCER01
             DLTOVR INPUT
             CPYF       FROMFILE(HWFILE1/PART_NO) +
                          TOFILE(HWFILE1/PART_CHK) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)

EXIT:
             ENDPGM
