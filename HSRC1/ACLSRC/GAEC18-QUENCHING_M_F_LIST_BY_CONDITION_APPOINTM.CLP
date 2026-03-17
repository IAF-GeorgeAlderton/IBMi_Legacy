             PGM        PARM(&PARM1)
             /** GAEC18 ************************************/
             /* QUENCHING M/F LIST BY  CONDITION APPOINTMENT */
             /*                              87.06.05      */
             /*----------+-----+----------+--------------------------*/
             /*2021.03.02|DCS. |T.MITSUI  | CHANGE WITH THE NUMBER */
             /*          |     |          | OF FIGURES EXPANSION   */
             /*          |     |          | OF THE "KANBAN"        */
             /********************************************************/
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSNO)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&RPY)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&TYPE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBAN)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&KOTE)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&PARM1)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PARM2)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PHIZ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MCEDP01) TYPE(*CHAR) LEN(8)
             RTVJOBA    JOB(&WSNO) USER(&USER)
             RTVDTAARA  DTAARA(MCEDP01) RTNVAR(&MCEDP01)

             CHGVAR     VAR(&PHIZ) VALUE(%SST(&MCEDP01 1 6))
             CALL       PGM(AGAR00) PARM(&WSNO &PRT &TYPE &PRTG)

             /*-----------------------------------------------------*/
 STEP02:     CHGJOB     OUTQ(&PRTG)

             DLTF       FILE(AAEWP01)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/AAEWP01) RCDLEN(206) LVLCHK(*NO)

 SP4:        CHGVAR     VAR(&PARM1) VALUE(' ')
             CHGVAR     VAR(&PARM2) VALUE(' ')

             CALL       PGM(GAER18) PARM(&PARM1 &PARM2)

             IF         ((&PARM1 *EQ '9') *OR (&PARM1 *EQ 'M')) DO
             DLTF       FILE(AAEWP01)
             GOTO       END
             ENDDO

             DLTF       FILE(AAEWL01)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/AAEWL01) RCDLEN(206) LVLCHK(*NO)

             IF (&PARM1 *EQ '1') DO
             FMTDTA     INFILE((HWFILE1/AAEWP01)) +
                          OUTFILE(HWFILE1/AAEWL01) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(GAES8A) +
                          OPTION(*NOPRT)
             GOTO       SP10
             ENDDO

             IF (&PARM1 *EQ '2') DO
             FMTDTA     INFILE((HWFILE1/AAEWP01)) +
                          OUTFILE(HWFILE1/AAEWL01) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(GAES8B) +
                          OPTION(*NOPRT)
             GOTO       SP10
             ENDDO

             IF (&PARM1 *EQ '3') DO
             FMTDTA     INFILE((HWFILE1/AAEWP01)) +
                          OUTFILE(HWFILE1/AAEWL01) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(GAES8C) +
                          OPTION(*NOPRT)
             GOTO       SP10
             ENDDO

             IF (&PARM1 *EQ '4') DO
             FMTDTA     INFILE((HWFILE1/AAEWP01)) +
                          OUTFILE(HWFILE1/AAEWL01) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(GAES8D) +
                          OPTION(*NOPRT)
             GOTO       SP10
             ENDDO

             IF (&PARM1 *EQ '5') DO
             FMTDTA     INFILE((HWFILE1/AAEWP01)) +
                          OUTFILE(HWFILE1/AAEWL01) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(GAES8E) +
                          OPTION(*NOPRT)
             GOTO       SP10
             ENDDO

             FMTDTA     INFILE((HWFILE1/AAEWP01)) +
                          OUTFILE(HWFILE1/AAEWL01) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(GAES8A) +
                          OPTION(*NOPRT)

 SP10:       DLTF       FILE(AAEWP01)

             IF         (&PARM1 *NE '5') DO
             OVRPRTF    FILE(GAEPR19) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(64) OUTQ(&PRTG) +
                          FORMTYPE(K6H1)
             CALL       PGM(GAER19) PARM(&PARM1)
             ENDDO
             ELSE       DO

             OVRPRTF    FILE(GAEPR20) DEVTYPE(*AFPDS) PAGESIZE(66 +
                          132) LPI(6) OVRFLW(64) OUTQ(&PRTG) +
                          FORMTYPE(K6H1)
             CALL       PGM(GAER20) PARM(&PHIZ)
             ENDDO

             DLTF       FILE(AAEWL01)
             DLTOVR     FILE(*ALL)

 END:        ENDPGM
