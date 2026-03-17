             PGM
             /** ATAC60 ************************************/
             /* CHUBU RIKA PLATING ACCOUNT PAYABLE DETAILS */
             /*                              86.11.07      */
             /**********************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CODE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FIL) TYPE(*CHAR) LEN(9)
             DCL        VAR(&PARM1) TYPE(*CHAR) LEN(8)
             DCL        VAR(&@SHAKO) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MIT) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSNO) USER(&USER)
     /*      CALL       PGM(KZZR00) PARM(&WSNO &PRT &TYPE &PRTG)  */
             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)
             CHGJOB     RUNPTY(40)

 STEP02:     CHGJOB     OUTQ(&PRTG)
             CHGVAR     VAR(&CODE) VALUE(%SST(&WSNO 1 2))
             CHGVAR     VAR(&FIL)  VALUE(&CODE *CAT 'ATAWP60')

             DLTF       FILE(&FIL)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&FIL) SRCFILE(ADDSSRC) +
                          SRCMBR(ATAWP60) OPTION(*NOLIST *NOSRC) +
                          LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(ATAWP60) TOFILE(&FIL)
             CALL       PGM(ATAR60) PARM(&PARM1  &@SHAKO)

             IF  (&@SHAKO  *EQ '9') DO
             DLTF       FILE(&FIL)
             DLTOVR     FILE(*ALL)
             GOTO       END
             ENDDO

             DLTF       FILE(ATAWP61)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTPF      FILE(HWFILE1/ATAWP61) RCDLEN(100) +
                          OPTION(*NOLIST *NOSRC) LVLCHK(*NO) AUT(*ALL)

             OVRPRTF    FILE(ATAPR61) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(66) OUTQ(QPRINTE) +
                          FORMTYPE(D993)
             CALL       PGM(ATAR61) PARM(&PARM1 &@SHAKO &MIT)
    /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
    /* PUBLICATION  OF UNIT PRICE NO INPUT LIST */
    /* PRODUCE BY S.OHTAKE 94.05.10 */
    /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
             IF  (&MIT  *EQ '1') DO
             OVRPRTF    FILE(ATAPR62) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(66) OUTQ(QPRINTE) +
                          FORMTYPE(K6H1)
             CALL       PGM(ATAR69) PARM(&MIT)
             ENDDO

             DLTF       FILE(&FIL)
             DLTOVR     FILE(*ALL)

 END:        CHGJOB     RUNPTY(20)

             ENDPGM
