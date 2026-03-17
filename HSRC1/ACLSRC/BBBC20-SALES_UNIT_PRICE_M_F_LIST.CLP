             PGM
             /**BBBC20*************************************/
             /* SALES UNIT PRICE M/F LIST */
             /* PROGRAM ID. : BBBC20                      */
             /* CREATE DATE. : OCT.18,'90. */
             /* AUTHOR.              : K.NAKAMURA         */
             /*************************************BBBC20**/
             DCL        VAR(&NO) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PTOKU) TYPE(*CHAR) LEN(4)
             RTVJOBA    JOB(&WSID)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CHGJOB     SWS(00000000)

 /* WORK FILE CREATE BBBWP20 */
             DLTF       FILE(BBBWP20)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE/BBBWP20) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(200000 10000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(BBBR20) PARM(&NO &PTOKU)

             IF         (%SWITCH(0XXXXXXX)) DO
             DLTF       FILE(BBBWP20)
             GOTO       END
             ENDDO

 /* WORK FILE CREATE BBBWP21 */
             DLTF       FILE(BBBWP21)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE/BBBWP21) RCDLEN(100) +
                          OPTION(*NOLIST) SIZE(200000 10000 3) +
                          LVLCHK(*NO) AUT(*ALL)

             IF         (&PTOKU *NE '3166') DO
             FMTDTA     INFILE(BBBWP20) OUTFILE(BBBWP21) +
                          SRCFILE(FMTSRC) SRCMBR(BBBS20) +
                          OPTION(*NOPRT)
             ENDDO
             ELSE       DO
             FMTDTA     INFILE(BBBWP20) OUTFILE(BBBWP21) +
                          SRCFILE(FMTSRC) SRCMBR(BBBS21) +
                          OPTION(*NOPRT)
             ENDDO

             IF         (&NO *EQ '1') DO

             OVRPRTF    FILE(BBBPR21) LPI(6) OVRFLW(62) +
                          RPLUNPRT(*YES) OUTQ(QPRINTE) +
                          FORMTYPE(H6H1) HOLD(*YES)
             CALL       PGM(BBBR21)
   /* MERGE APW */
             MRGAPW     FORMD(BBBR21APW) FILE(BBBR21APW) +
                          SPLF(BBBPR21) OUTQ(QPRINTE) FORMTYPE(H6H1)
   /* CLEAR SPLF */
             DLTSPLF    FILE(BBBPR21) SPLNBR(*LAST)
             ENDDO
             ELSE DO
             OVRPRTF    FILE(BBBPR22) LPI(6) OVRFLW(62) +
                          RPLUNPRT(*YES) OUTQ(QPRINTE) +
                          FORMTYPE(H6H1) HOLD(*YES)
             CALL       PGM(BBBR22)
   /* MERGE APW */
             MRGAPW     FORMD(BBBR22APW) FILE(BBBR22APW) +
                          SPLF(BBBPR22) OUTQ(QPRINTE) FORMTYPE(H6H1)
   /* CLEAR SPLF */
             DLTSPLF    FILE(BBBPR22) SPLNBR(*LAST)

             ENDDO

             DLTF       FILE(BBBWP20)
             DLTF       FILE(BBBWP21)
             DLTOVR     FILE(*ALL)

 END:        ENDPGM
