             PGM
             /** AGJC30 **********************************************/
             /* INQ #OF A-PICS KANBAN (GROUPING)                     */
             /*    IWATA.           2018.05.07                       */
             /*-------------------------------------                 */
             /*  JW1    2024.07.22 CHG WLIB TO QTEMP                 */
             /********************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&DDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&WS3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PCR1) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PCB1) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PCR2) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PCB2) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PDATA) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&AGJWP30) TYPE(*CHAR) LEN(10)
             DCL        VAR(&AGJWP31) TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGVAR     VAR(&WS3) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&AGJWP30) VALUE('AGJWP30' *CAT &WS3)
             CHGVAR     VAR(&AGJWP31) VALUE('AGJWP31' *CAT &WS3)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&USER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO
 STP10:
             CALL       PGM(AGJR30) PARM(&PDATA &PCR1 &PCB1 &PCR2 +
                          &PCB2 &FILT &PCMD)
             IF         COND(&PCMD *EQ '01') THEN(GOTO CMDLBL(#END))
 STP11:
             IF         COND(&PDATA *EQ '3' *OR &PDATA *EQ '4' *OR +
                          &PDATA *EQ '5' *OR &PDATA *EQ '6') THEN(DO)
             CALL       PGM(AGJC40) PARM(&PDATA &PCR1 &PCB1 &PCR2 +
                          &PCB2 &FILT &PCMD)
             GOTO       CMDLBL(STP10)
             ENDDO
             IF         COND(&PDATA *EQ '7') THEN(DO)
             CALL       PGM(AGJC50)
             GOTO       CMDLBL(STP10)
             ENDDO
 STPA1:
             DLTF       FILE(&WLIB/&AGJWP30)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AGJWP30) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AGJWP30) OPTION(*NOLIST *NOSRC) +
                          SIZE(500000 1500 3) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(&WLIB/&AGJWP31)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&AGJWP31) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AGJWP31) OPTION(*NOLIST *NOSRC) +
                          SIZE(500000 1500 3) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AGJWP30) TOFILE(&WLIB/&AGJWP30)
             OVRDBF     FILE(AGJWP31) TOFILE(&WLIB/&AGJWP31)
             CALL       PGM(AGJR31) PARM(&PDATA &PCR1 &PCB1 &PCR2 +
                          &PCB2 &PCMD)
             OVRDBF     FILE(AGJWP30) TOFILE(&WLIB/&AGJWP30)
             OVRDBF     FILE(AGJWP31) TOFILE(&WLIB/&AGJWP31)
             CALL       PGM(AGJR32) PARM(&PDATA &PCR1 &PCB1 &PCR2 +
                          &PCB2 &PCMD)
             GOTO       CMDLBL(STP10)

 #END:       ENDPGM
