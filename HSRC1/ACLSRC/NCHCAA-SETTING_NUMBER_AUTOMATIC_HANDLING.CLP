             PGM
             /** NCHCAA **************************/
             /* SETTING NUMBER AUTOMATIC HANDLING  */
             /*   EXPLANATION MATERIAL  FOR FACILITY ABILITY EXAMINATION. */
             /* I-HASADA            90.12.08     */
             /************************** NCHCAA **/
             DCL        VAR(&NJIHZ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WHIZ1) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WHIZ2) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WHIZ3) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WHIZ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WYY) TYPE(*DEC) LEN(4) VALUE(0)
             DCL        VAR(&WMM) TYPE(*DEC) LEN(2) VALUE(0)
             DCL        VAR(&WKADO) TYPE(*CHAR) LEN(3)
             DCL        VAR(&ABBDS2) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MCEDP01) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MCHDTA) TYPE(*CHAR) LEN(27)
             RTVDTAARA  DTAARA(ABBDS2) RTNVAR(&ABBDS2)
             RTVDTAARA  DTAARA(MCEDP01) RTNVAR(&MCEDP01)
             RTVDTAARA  DTAARA(MCHDTA) RTNVAR(&MCHDTA)

             CHGVAR     VAR(&NJIHZ) VALUE(%SST(&MCEDP01 1 6))

             CHGVAR     VAR(&WHIZ1) VALUE(&ABBDS2)
             CHGVAR     VAR(&WYY) VALUE(%SST(&ABBDS2 1 4))
             CHGVAR     VAR(&WMM) VALUE(%SST(&ABBDS2 5 2))

             IF         (&WMM *EQ 12) DO
             CHGVAR     VAR(&WYY) VALUE(&WYY+1)
             CHGVAR     VAR(&WMM) VALUE(01)
             ENDDO
             ELSE DO
             CHGVAR     VAR(&WMM) VALUE(&WMM+1)
             ENDDO
             CHGVAR     VAR(%SST(&WHIZ 1 4)) VALUE(&WYY)
             CHGVAR     VAR(%SST(&WHIZ 5 2)) VALUE(&WMM)
             CHGVAR     VAR(&WHIZ2) VALUE(&WHIZ)

             IF         (&WMM *EQ 12) DO
             CHGVAR     VAR(&WYY) VALUE(&WYY+1)
             CHGVAR     VAR(&WMM) VALUE(01)
             ENDDO
             ELSE DO
             CHGVAR     VAR(&WMM) VALUE(&WMM+1)
             ENDDO
             CHGVAR     VAR(%SST(&WHIZ 1 4)) VALUE(&WYY)
             CHGVAR     VAR(%SST(&WHIZ 5 2)) VALUE(&WMM)
             CHGVAR     VAR(&WHIZ3) VALUE(&WHIZ)

             CLRPFM     FILE(NCHNP01)
             CALL       PGM(NCHR01) PARM(&NJIHZ &WHIZ1 &WKADO)

             CHGVAR     VAR(%SUBSTRING(&MCHDTA 1 6)) VALUE(&NJIHZ)
             CHGVAR     VAR(%SUBSTRING(&MCHDTA 7 3)) VALUE(&WKADO)
             CHGVAR     VAR(%SUBSTRING(&MCHDTA 10 6)) VALUE(&WHIZ1)
             CHGVAR     VAR(%SUBSTRING(&MCHDTA 16 6)) VALUE(&WHIZ2)
             CHGVAR     VAR(%SUBSTRING(&MCHDTA 22 6)) VALUE(&WHIZ3)
             CHGDTAARA  DTAARA(MCHDTA) VALUE(&MCHDTA)

             ENDPGM
