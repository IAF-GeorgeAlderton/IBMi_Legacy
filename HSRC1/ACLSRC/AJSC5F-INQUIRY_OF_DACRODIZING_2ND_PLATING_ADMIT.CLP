             PGM    /*  PARM(&MACH &SHZ &STM &EHZ &ETM)  */
             /*** AJSC5F *********************************************/
             /* INQUIRY OF DACRODIZING 2ND PLATING ADMIT RESULTS DATA*/
             /*   KIRI  2015/07/07                                   */
             /********************************************* AJSC5F ***/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)  TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)

             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MACH) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SHZ)  TYPE(*DEC)  LEN(8 0)
             DCL        VAR(&STM)  TYPE(*DEC)  LEN(4 0)
             DCL        VAR(&EHZ)  TYPE(*DEC)  LEN(8 0)
             DCL        VAR(&ETM)  TYPE(*DEC)  LEN(4 0)

             CHGVAR     VAR(&MACH) VALUE('02')
             CHGVAR     VAR(&SHZ)  VALUE(20150601)
             CHGVAR     VAR(&STM)  VALUE(0800)
             CHGVAR     VAR(&EHZ)  VALUE(20150610)
             CHGVAR     VAR(&ETM)  VALUE(9999)

             RTVJOBA    JOB(&WSNO) USER(&USER)
             CHGJOB     SWS(00000000)

             CALL       AGAR00 PARM(&WSNO &PRT &TYPE &PRTG)

 STEP02:     CHGJOB     OUTQ(&PRTG)
             CHGVAR     VAR(&FILE) VALUE('AJSWP5F' *CAT %SST(&WSNO 1 +
                          3))

             DLTF       FILE(HWFILE1/&FILE)
             MONMSG     MSGID(CPF2105 CPF3261)
             CRTPF      FILE(HWFILE1/&FILE) RCDLEN(1024) +
                          OPTION(*NOLIST *NOSRC) SIZE(50000 2000 5) +
                          LVLCHK(*NO)

             OVRDBF     FILE(AJSWP5F) TOFILE(HWFILE1/&FILE)

             CALL       PGM(AJSR5F) PARM(&MACH &SHZ &STM &EHZ &ETM)

             DLTOVR     FILE(AJSWP5F)

 END:        ENDPGM
