             PGM
             /** ATBC01 ********************/
             /* CZ DELIVERY AMOUNT LIST CREATE */
             /* A-IDOTA 1992.10.16 */
             /******************** ATBC01 **/
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             CALL       PGM(KZZR00) PARM(&WS &PRT &TYPE &PRTG)

 /* WORK FILE CREATE ATBWP01 */
             DLTF       FILE(ATBWP01)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ATBWP01) RCDLEN(70) +
                          OPTION(*NOLIST) SIZE(300000 20000 3) +
                          LVLCHK(*NO)

             FMTDTA     INFILE((MCEWP22)) OUTFILE(ATBWP01) +
                          SRCFILE(FMTSRC) SRCMBR(ATBS01) +
                          OPTION(*NOPRT)

 /* WORK FILE CREATE ATBWP02 */
             DLTF       FILE(ATBWP02)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ATBWP02) RCDLEN(70) +
                          OPTION(*NOLIST) SIZE(300000 20000 3) +
                          LVLCHK(*NO)

             CALL       PGM(ATBR01)

 /* WORK FILE CREATE ATBWP03 */
             DLTF       FILE(ATBWP03)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/ATBWP03) RCDLEN(70) +
                          OPTION(*NOLIST) SIZE(300000 20000 3) +
                          LVLCHK(*NO)

             CALL       PGM(ATBR02)

             DLTF       FILE(ATBWP01)
             DLTF       FILE(ATBWP02)
 END:        ENDPGM
