             PGM
             /** AARC11 ************************************/
             /* CHUBU RIKA PLATING ACCOUNT RECEIVABLE UNIT PRICE M/F UPDATE */
             /*                              86.11.07      */
             /* JW1   2020/02/07 ADD EXCLUSIVE CONTROL     */
             /**********************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SHFLG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&BZTNKA) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&RTN1 ) TYPE(*CHAR) LEN(1)

/* JW1 CHECK OTHER USER IS USING  ==================================*/
             CALL CHKC45 ('AARC11' 'AARC11' 'Y'  'CHK' &RTN1)
             IF         COND(&RTN1 *NE ' ') THEN(GOTO END99)
/* =================================================================*/

             RTVJOBA    JOB(&WSNO) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSNO &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)

             CHGJOB     OUTQ(&PRTG)

     /*JW1   CHKOBJ     OBJ(AARC11ACT) OBJTYPE(*DTAARA)                  ***/
     /***    MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(V2))             ***/
     /***                                                                ***/
     /***    CALL       PGM(QUILNGTX) PARM('This program is used by +    ***/
     /***                 another user. please try again later...' +     ***/
     /***                 X'00000046' ' ' ' ' X'00000000')               ***/
     /***    GOTO       CMDLBL(END99)                                    ***/
     /***                                                                ***/
     /***      -----------------------------------------------------     ***/
 V2: /***    CHKOBJ     OBJ(AARC11ACT) OBJTYPE(*DTAARA)                  ***/
     /***    MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(V1))             ***/
     /***                                                                ***/
     /***    CALL       PGM(QUILNGTX) PARM('This program is used by +    ***/
     /***                 another user. please try again later...' +     ***/
     /***                 X'00000046' ' ' ' ' X'00000000')               ***/
     /***    GOTO       CMDLBL(END99)                                    ***/
     /***                                                                ***/
     /***      -----------------------------------------------------     ***/
 V1: /***    CRTDTAARA  DTAARA(AARC11ACT) TYPE(*CHAR) LEN(2) +           ***/
     /***                 VALUE('BZ')                                    ***/

             CHKOBJ     OBJ(AARWP15) OBJTYPE(*FILE)
             MONMSG MSGID(CPF9801) EXEC(GOTO CMDLBL(NOCRT)) /* +
                          APPLICABLE FILE NO EXIST */
             CLRPFM     FILE(AARWP15)
             GOTO       CMDLBL(CRT1)

 NOCRT:      CRTPF      FILE(HWFILE1/AARWP15) RCDLEN(128) +
                          SIZE(*NOMAX) LVLCHK(*NO)

 CRT1:       CHKOBJ     OBJ(AARWL15) OBJTYPE(*FILE)
             MONMSG MSGID(CPF9801) EXEC(GOTO CMDLBL(NOCRT1)) /* +
                          APPLICABLE FILE NO EXIST */
             CLRPFM     FILE(AARWL15)
             GOTO       CMDLBL(SHO)

 NOCRT1:     CRTPF      FILE(HWFILE1/AARWL15) RCDLEN(128) +
                          SIZE(*NOMAX) LVLCHK(*NO)
 SHO:        CHGVAR     VAR(&SHFLG) VALUE('9')
             CALL       PGM(AARR11) PARM(&USER &SHFLG)

             IF         COND(&SHFLG *EQ '9') THEN(GOTO CMDLBL(END))

             /* SORT */
             FMTDTA     INFILE((HWFILE1/AARWP15)) +
                          OUTFILE(HWFILE1/AARWL15) SRCFILE(FMTSRC) +
                          SRCMBR(AARS15) OPTION(*NOPRT)

             OVRPRTF    FILE(AARPR15) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(64) OUTQ(&PRTG) +
                          FORMTYPE(K6H1) IGCDTA(&PIGCD) LVLCHK(*NO)

             CALL       PGM(AARR15) PARM(&USER)

 END: /*JW1  DLTDTAARA  DTAARA(AARC11ACT)    ***/
      /***   MONMSG     MSGID(CPF2105)       ***/
             CALL CHKC45 ('AARC11' 'AARC11' 'N'  '' '')

             CHGJOB     OUTQ(&PRT)

 END99:      ENDPGM
