             PGM
             /** GCQC36 **********************************/
             /*   ..PUBLISHMENT OF DIE ALLOTMENT M/F     */
             /*       I-HASADA            88.04.13       */
             /*       TCH                 00.10.05       */
             /************************ COPY FROM GCQC32 **/
             DCL        VAR(&WS) TYPE(*CHAR) LEN(10)
             DCL        VAR(&US) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYP) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PCNT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PNO) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE1) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FILE2) TYPE(*CHAR) LEN(9)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             RTVJOBA    JOB(&WS) USER(&US)
             CHGJOB     SWS(00000000)

             CALL       PGM(AGAR00) PARM(&WS &PRT &TYP &PRTG)
             CALL       PGM(ALBC00) PARM(&US &WLIB)

             CHGVAR     VAR(%SST(&FILE1 1 7)) VALUE('GCQWP32')
             CHGVAR     VAR(%SST(&FILE1 8 2)) VALUE(%SST(&WS 1 2))
             CHGVAR     VAR(%SST(&FILE2 1 7)) VALUE('GCQWP33')
             CHGVAR     VAR(%SST(&FILE2 8 2)) VALUE(%SST(&WS 1 2))

             DLTF       FILE(&FILE1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE1) RCDLEN(300) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO)

             OVRDBF     FILE(GCQWP32) TOFILE(&FILE1)
             CALL       PGM(GCQR32) PARM(&PCNT &PNO)
             DLTOVR     FILE(GCQWP32)

             IF         (%SWITCH(0XXXXXXX)) DO
             DLTF       FILE(&FILE1)
             GOTO       END
             ENDDO

             DLTF       FILE(&FILE2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&FILE2) RCDLEN(300) +
                          OPTION(*NOLIST) SIZE(*NOMAX) LVLCHK(*NO)

             IF         (&PNO *EQ '1') DO
             FMTDTA     INFILE((&WLIB/&FILE1)) OUTFILE(&WLIB/&FILE2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(GCQS32) +
                          OPTION(*NOPRT)
             ENDDO
             ELSE       DO
             FMTDTA     INFILE((&WLIB/&FILE1)) OUTFILE(&WLIB/&FILE2) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(GCQS33) +
                          OPTION(*NOPRT)
             ENDDO
             DLTF       FILE(&FILE1)

             OVRPRTF    FILE(GCQPR33) DEVTYPE(*SCS) PAGESIZE(66) +
                          LPI(6) OVRFLW(65) RPLUNPRT(*YES) +
                          OUTQ(IT_OUTQ) FORMTYPE(D982) +
                          COPIES(&PCNT) MAXRCDS(*NOMAX)

             OVRDBF     FILE(GCQWP33) TOFILE(&FILE2)
             CALL       PGM(GCQR33) PARM(&US)

        /*   SNDNETSPLF FILE(GCQPR33) TOUSRID((V0030 SYSTEM1)) +
                          SPLNBR(*LAST) DTAFMT(*ALLDATA)      */
        /*   MONMSG     MSGID(CPF3309 CPF0000)                */

        /*   DLTSPLF    FILE(GCQPR33) SPLNBR(*LAST)           */
        /*   MONMSG     MSGID(CPF3309 CPF0000)                */
             DLTF       FILE(&FILE2)
             DLTOVR     FILE(*ALL)

 END:        ENDPGM
