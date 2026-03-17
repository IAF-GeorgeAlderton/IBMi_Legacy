             PGM    /*  PARM(&MACH &SHZ &STM &EHZ &ETM)  */
             /*** AJSC5D *********************************************/
             /* INQUIRY OF PLATING DISCHARGE RESULT DATA (MACHINE NO)*/
             /*   KIRI  2015/07/07                                   */
             /********************************************* AJSC5D ***/
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

             CHGVAR     VAR(&MACH) VALUE('32')
             CHGVAR     VAR(&SHZ)  VALUE(20150601)
             CHGVAR     VAR(&STM)  VALUE(0800)
             CHGVAR     VAR(&EHZ)  VALUE(20150610)
             CHGVAR     VAR(&ETM)  VALUE(9999)

             RTVJOBA    JOB(&WSNO) USER(&USER)
             CHGJOB     SWS(00000000)

             CALL       AGAR00 PARM(&WSNO &PRT &TYPE &PRTG)

 STEP02:     CHGJOB     OUTQ(&PRTG)
             CHGVAR     VAR(&FILE) VALUE('AJSWP5D' *CAT %SST(&WSNO 1 +
                          3))

             DLTF       FILE(HWFILE1/&FILE)
             MONMSG     MSGID(CPF2105 CPF3261)
             CRTPF      FILE(HWFILE1/&FILE) RCDLEN(1024) +
                          OPTION(*NOLIST *NOSRC) SIZE(50000 2000 5) +
                          LVLCHK(*NO)

             OVRDBF     FILE(AJSWP5D) TOFILE(HWFILE1/&FILE)

             CALL       PGM(AJSR5D) PARM(&MACH &SHZ &STM &EHZ &ETM)

             DLTOVR     FILE(AJSWP5D)

 END:        ENDPGM
