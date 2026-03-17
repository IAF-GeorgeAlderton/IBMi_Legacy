             PGM        PARM(&PCR1 &PCB1 &PCR2 &PCB2 &PDATA &PSORT +
                          &PSHN1 &PSHN2 &PSHN3 &PCMD)
             /** ADKCB0 **********************************************/
             /*つるべ生産指示　上限カット照会                      */
             /*    2020.07.23                                        */
             /********************************************************/
             DCL        VAR(&WSID)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB)    TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLIB)    TYPE(*CHAR) LEN(8)
             DCL        VAR(&PCMD)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&WS3)     TYPE(*CHAR) LEN(3)
             DCL        VAR(&PCR1)    TYPE(*CHAR) LEN(8)
             DCL        VAR(&PCR2)    TYPE(*CHAR) LEN(8)
             DCL        VAR(&PCB1)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&PCB2)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&PDATA)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PSORT)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PCMD)    TYPE(*CHAR) LEN(2)
             DCL        VAR(&ADKWPB0) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ADKWPB5) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PSHN1)   TYPE(*CHAR) LEN(5)
             DCL        VAR(&PSHN2)   TYPE(*CHAR) LEN(5)
             DCL        VAR(&PSHN3)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&PTBOX)   TYPE(*DEC) LEN(10 2)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&ADKWPB0) VALUE('ADKWPB0' *CAT &WS3)
             CHGVAR     VAR(&ADKWPB5) VALUE('ADKWPB5' *CAT &WS3)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&USER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO
 STP10:
 STPA1:
      /* ADKWPB0のソースからADKWPB5を作成*/
      /* ADKWPB0をADKWPB5でOVRDBF */
             DLTF       FILE(&WLIB/&ADKWPB5)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&ADKWPB5) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ADKWPB0) OPTION(*NOLIST *NOSRC) +
                          SIZE(500000 1500 3) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(ADKWPB0) TOFILE(&WLIB/&ADKWPB5)
             CALL       PGM(ADKRB1) PARM(&PCR1 &PCB1 &PCR2 &PCB2 +
                          &PDATA &PSORT &PSHN1 &PSHN2 &PSHN3 &PTBOX +
                          &PCMD)

             CALL       PGM(ADKRB4)

             CALL       PGM(ADKRB5) PARM(&PCR1 &PCB1 &PCR2 &PCB2 +
                          &PDATA &PSORT &PSHN1 &PSHN2 &PSHN3 &PTBOX +
                          &PCMD)
      /* OVRDBF */
             DLTOVR     FILE(ADKWPB0)
             OVRDBF     FILE(ADKWPB0) TOFILE(&WLIB/&ADKWPB0)

 #END:       ENDPGM
