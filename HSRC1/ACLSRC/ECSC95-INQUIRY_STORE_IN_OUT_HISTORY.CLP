             PGM
             /*** ECSC95 *****************************************/
             /* INQUIRY STORE IN/OUT HISTORY                     */
             /*     Y.MAEDA           2017.10.13                 */
             /********************************** ECSC95 **********/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&P1YMD1) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&P1TIM1) TYPE(*DEC) LEN(4 0)
             DCL        VAR(&P1YMD2) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&P1TIM2) TYPE(*DEC) LEN(4 0)
             DCL        VAR(&P1DIE1) TYPE(*CHAR) LEN(2)
             DCL        VAR(&P1DIE2) TYPE(*CHAR) LEN(4)
             DCL        VAR(&P1DIE3) TYPE(*CHAR) LEN(1)
             DCL        VAR(&P1DIE4) TYPE(*CHAR) LEN(1)
             DCL        VAR(&P1RIYU) TYPE(*CHAR) LEN(1)
             DCL        VAR(&P1MSNO) TYPE(*CHAR) LEN(3)
             DCL        VAR(&P1IOKB) TYPE(*CHAR) LEN(1)
             DCL        VAR(&P1GSKB) TYPE(*CHAR) LEN(1)
             DCL        VAR(&P1JUDG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FKEY) TYPE(*CHAR) LEN(2)
             DCL        VAR(&WS3)      TYPE(*CHAR) LEN(3)
             DCL        VAR(&ECSWP95)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&ECSWP97)  TYPE(*CHAR) LEN(10)

             DCL        VAR(&OUTR)     TYPE(*DEC)  LEN(5 0)
             DCL        VAR(&FRLB)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&FRFL)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&HOST)     TYPE(*CHAR) LEN(8)
             DCL        VAR(&TOFL)     TYPE(*CHAR) LEN(52)
             DCL        VAR(&TOFT)     TYPE(*CHAR) LEN(2)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGVAR     VAR(&WS3)     VALUE(%SST(&WSID 1 3))
             CHGJOB     OUTQ(&PRTG)

             CHGVAR     VAR(&ECSWP95) VALUE('ECSWP95' *CAT &WS3)
             CHGVAR     VAR(&ECSWP97) VALUE('ECSWP97' *CAT &WS3)

 STEP1:      DLTF       FILE(&ECSWP95)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&ECSWP95) +
                        SRCFILE(HSRC1/ADDSSRC) SRCMBR(ECSWP95) +
                        OPTION(*NOLIST *NOSRC) +
                        SIZE(*NOMAX) LVLCHK(*NO)

             OVRDBF     FILE(ECSWP95) TOFILE(&ECSWP95)
             CALL       PGM(ECSR95) PARM(&P1YMD1 &P1TIM1 &P1YMD2 +
                          &P1TIM2 &P1DIE1 &P1DIE2 &P1DIE3 &P1DIE4 +
                          &P1RIYU &P1MSNO &P1IOKB &P1GSKB &P1JUDG +
                          &FKEY)
             DLTOVR     FILE(ECSWP95)

             IF         COND(&FKEY *EQ '01') THEN(DO)
             GOTO       CMDLBL(@END)
             ENDDO

        /* SHOW DISPLAY */
             IF         COND(&FKEY *EQ '05') THEN(DO)
             OVRDBF     FILE(ECSWP95) TOFILE(&ECSWP95)
             CALL       PGM(ECSR96) PARM(&P1YMD1 &P1TIM1 &P1YMD2 +
                          &P1TIM2 &P1DIE1 &P1DIE2 &P1DIE3 &P1DIE4 +
                          &P1RIYU &P1MSNO &P1IOKB &P1GSKB &P1JUDG)
             DLTOVR     FILE(ECSWP95)
             GOTO       CMDLBL(STEP1)
             ENDDO

        /* CREATE CSV DATA */
             IF         COND(&FKEY *EQ '12') THEN(DO)
             DLTF       FILE(HWFILE1/&ECSWP97)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/&ECSWP97) RCDLEN(1024) +
                          OPTION(*NOLIST *NOSRC) SIZE(50000 5000 3) +
                          LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(ECSWP95) TOFILE(&ECSWP95)
             OVRDBF     FILE(ECSWP97) TOFILE(&ECSWP97)
             CALL       PGM(ECSR97)
             DLTOVR     FILE(ECSWP95)
             DLTOVR     FILE(ECSWP97)

            /* DATA TRANCFER */
             CHGVAR     VAR(&FRLB) VALUE('HWFILE1')
             CHGVAR     VAR(&FRFL) VALUE(&ECSWP97)
             RTVNETA    SYSNAME(&HOST)
             CHGVAR     VAR(&TOFL) +
                          VALUE('C:/AS400/DATA/DIE_INOUT_DATA.CSV')
             CHGVAR     VAR(&TOFT) VALUE(' 1')

             CALL       PGM(APLC98) PARM(&FRLB &FRFL &HOST &TOFL &TOFT)

             GOTO       CMDLBL(STEP1)
             ENDDO

 @END:       ENDPGM
