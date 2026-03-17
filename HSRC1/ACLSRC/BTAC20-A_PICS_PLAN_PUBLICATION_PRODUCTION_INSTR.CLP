             PGM
             /** BTAC20 ******************************************/
             /* || A-PICS PLAN PUBLICATION PRODUCTION INSTRUCTION DATA CREATE */
             /* I-HASADA                          94.06.14       */
             /* N-HYOTO  2001.04.23 CHANGE ISSUE 8->12           */
             /****************************************** BTAC20 **/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIST) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USER)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)

             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             CHKOBJ     OBJ(BTAWP20) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(&WLIB/BTAWP20) RCDLEN(100) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          AUT(*ALL))
             CLRPFM     FILE(BTAWP20)

             CHGVAR     VAR(&PLIST) VALUE(' ')

             CALL       PGM(BTAR20) PARM(&PLIST)

             IF         (&PLIST *EQ '*') DO

             CHKOBJ     OBJ(BTAWP21) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(CRTPF +
                          FILE(&WLIB/BTAWP21) RCDLEN(100) +
                          OPTION(*NOSRC *NOLIST) SIZE(*NOMAX) +
                          AUT(*ALL))
             CLRPFM     FILE(BTAWP21)

             FMTDTA     INFILE((&WLIB/BTAWP20)) +
                          OUTFILE(&WLIB/BTAWP21) SRCFILE(FMTSRC) +
                          SRCMBR(BTAS21) OPTION(*NOPRT)

             OVRPRTF    FILE(QPRINT)  PAGESIZE(66 +
                          156) LPI(6) CPI(12) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) IGCDTA(&PIGCD)
             CALL       PGM(BTAR21) PARM(&USER)
             DLTOVR     FILE(*ALL)

             ENDDO

             ENDPGM
