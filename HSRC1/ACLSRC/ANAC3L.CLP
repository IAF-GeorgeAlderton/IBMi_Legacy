  PGM
/** ANAC3L ************************************************/
/*  ANDROID DISUSE PARTS INFORMATION                      */
/*                                                        */
/* TCHK1 08/01/06 CREATE(COPY FROM ABAC3L)                */
/**********************************************************/
             DCL        VAR(&USR)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&END) TYPE(*CHAR) LEN(1)
             RTVJOBA    JOB(&WSID) USER(&USR) NBR(&NBR)
             OVRPRTF    FILE(QPRINT2) OUTQ(FORECAST) SAVE(*YES)
             DLTF       FILE(QTEMP/PRT132)
             MONMSG     MSGID(CPF0000)
             CRTPF      FILE(QTEMP/PRT132) RCDLEN(132)

             CALL       PGM(ANAR3L) PARM(&END)
             IF         COND(&END *EQ '1') THEN(GOTO CMDLBL(@END))

             CPYSPLF    FILE(QPRINT2) TOFILE(QTEMP/PRT132) +
                          JOB(&NBR/&USR/&WSID) SPLNBR(*LAST)

             OVRDBF     FILE(PRT132) TOFILE(QTEMP/PRT132)
             CALL       PGM(AB#RW0)
             DLTOVR     FILE(PRT132)

             SNDDST     TYPE(*FILE) TOINTNET((MurrayP@iafi.com)) +
                          DSTD('ANDROID FORECAST <disuse +
                          information>') MSG('Attached please check +
                          the list of disused parts information. +
                          (ANAC3L)') DOCFILE(QTEMP/PRT132) +
                          DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD('ANDROID +
                          disused parts information')
             DLTOVR     FILE(*ALL)
  @END:

             ENDPGM
