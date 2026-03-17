             PGM        PARM(&LIBL &FILE &MBR)

             DCL        VAR(&LIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&HOST) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PCFILE1) TYPE(*CHAR) LEN(52)
             DCL        VAR(&PCFILE2) TYPE(*CHAR) LEN(52)
             DCL        VAR(&PCTYPE) TYPE(*CHAR) LEN(2)

             RTVNETA    SYSNAME(&HOST)

          /* CHGVAR     VAR(&LIBL) VALUE('HSRC1')  */
          /* CHGVAR     VAR(&FILE) VALUE('CCLSRC') */
          /* CHGVAR     VAR(&MBR) VALUE('CAAC80')  */
          /* CHGVAR     VAR(&HOST) VALUE('IAF')    */
             CHGVAR     VAR(&PCFILE1) VALUE('C:/AS400/DATA/' *TCAT +
                          &HOST *TCAT '.TXT')
             CHGVAR     VAR(&PCTYPE) VALUE(' 1')

             CALL       PGM(APLC9A) PARM(&LIBL &FILE &MBR &HOST +
                          &PCFILE1 &PCTYPE)

             IF         COND(&HOST *EQ 'IAF') THEN(DO)
             CHGVAR     VAR(&HOST) VALUE('IAFAYM')
             GOTO       CMDLBL(@NEXT)
             ENDDO
             IF         COND(&HOST *EQ 'IAFAYM') THEN(DO)
             CHGVAR     VAR(&HOST) VALUE('IAF')
             GOTO       CMDLBL(@NEXT)
             ENDDO
@NEXT:
          /* CHGVAR     VAR(&LIBL) VALUE('HSRC1')  */
          /* CHGVAR     VAR(&FILE) VALUE('CCLSRC') */
          /* CHGVAR     VAR(&MBR) VALUE('CAAC80')  */
          /* CHGVAR     VAR(&HOST) VALUE('IAFAYM') */
             CHGVAR     VAR(&PCFILE2) VALUE('C:/AS400/DATA/' *TCAT +
                          &HOST *TCAT '.TXT')
             CHGVAR     VAR(&PCTYPE) VALUE(' 1')

             CALL       PGM(APLC9A) PARM(&LIBL &FILE &MBR &HOST +
                          &PCFILE2 &PCTYPE)

             STRPCCMD   PCCMD('START "" "C:/PROGRAM +
                          FILES/WINMERGE/WINMERGEU.EXE"' *BCAT &PCFILE1 +
                          *BCAT &PCFILE2) PAUSE(*NO)

             ENDPGM
