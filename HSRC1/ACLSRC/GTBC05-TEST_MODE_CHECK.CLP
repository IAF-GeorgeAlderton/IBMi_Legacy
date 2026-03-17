             PGM
/**** GTBC05 ***********************************************/
/* ACZ PARTS ORDER DATA SUMMARY                            */
/*                                                         */
/* TCHK  10/05/12 CREATE(COPY FROM GDGC05)                 */
/***********************************************************/
             DCLF       FILE(GTBPW05)
             DCL        VAR(&PPUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PPGO) TYPE(*CHAR) LEN(2)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&FLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&DDATE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DDATEX) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PRVDATE) TYPE(*CHAR) LEN(6)
             RTVJOBA    JOB(&WSID) USER(&PPUSER) DATE(&DDATE)

             OVRDBF     FILE(AGDPP11) TOFILE(HFILE1/A@DPP11)
             OVRDBF     FILE(AGDPL11) TOFILE(HFILE1/A@DPL11)
             OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/A@DPL12)

             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             /* TEST MODE CHECK */
             CHGVAR     VAR(&FLIB) VALUE('HFILE1  ')
             CALL       PGM(ALBC00) PARM(&PPUSER &WLIB)
             IF         COND(&WLIB *EQ 'TWFILE1 ') THEN(DO)
             CHGVAR     VAR(&FLIB) VALUE('TFILE1  ')
             ENDDO
             /* *************** */

             CPYF       FROMFILE(GTBPP05) TOFILE(QTEMP/GTBP) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          INCREL((*IF IASYHZ *EQ 0))
             MONMSG     MSGID(CPF0000)
             RTVMBRD    FILE(QTEMP/GTBP) NBRCURRCD(&REC)
             CHGVAR     VAR(&D@KN) VALUE(&REC)

             RTVDTAARA  DTAARA(HWFILE1/GTBC05DT (1 6)) RTNVAR(&DDATEX)
             IF         COND(&DDATE *EQ &DDATEX) THEN(DO)
               SNDBRKMSG  MSG('YOU CAN USE IT ONLY ONCE A DAY  +
                          TRY NEXT DAY         .') TOMSGQ(&WSID) +
                          MSGTYPE(*INFO)
               GOTO       @END
             ENDDO

  @STRT:
             SNDRCVF    DEV(&WSID) RCDFMT(DSP01)

             IF         COND(&IN01 *EQ '1') THEN(GOTO CMDLBL(@END))
             IF         COND(&IN05 *NE '1') THEN(GOTO CMDLBL(@STRT))

             CHGDTAARA  DTAARA(HWFILE1/GTBC05DT) VALUE(&DDATE)

        /*  MSK 2004.11.10 */
             CHKOBJ     OBJ(&WLIB/GTBWP9Z) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)

             CRTPF      FILE(&WLIB/GTBWP9Z) RCDLEN(128) +
                          OPTION(*NOLIST *NOSRC) SIZE(*NOMAX) +
                          LVLCHK(*NO) AUT(*ALL)
             ENDDO

             CPYF       FROMFILE(GTBWP9X) TOFILE(GTBWP9Z) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(&WLIB/GTBWP9X)

             OVRDBF     FILE(GTBWP9X) TOFILE(&WLIB/GTBWP9Z)

             OVRPRTF    FILE(QPRINT) OUTQ(LANPRT03) FORMTYPE(K6H1)

             IF         COND(&REC *GT 0) THEN(DO)
             CALL       PGM(GTBR06)
             ENDDO

             CPYF       FROMFILE(GTBPP01)  TOFILE(TFILE1/GTBPP01Z) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(GTBR05) PARM(&PPUSER &PPGO)
             IF         (&PPGO *NE 'GO')   GOTO @END

             CPYF       FROMFILE(GTBPP01)  TOFILE(QTEMP/GTBPP01X) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          INCREL((*IF IASYHZ *EQ 0))
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(GTBPP01)
             CPYF       FROMFILE(QTEMP/GTBPP01X) TOFILE(GTBPP01) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF0000)

             CPYF       FROMFILE(GTBPP10) TOFILE(TFILE1/GTBPP10@SV) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             CPYF       FROMFILE(GTCPP05) TOFILE(TFILE1/GTCPP05@SV) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             CLRPFM     FILE(HWFILE1/GTBWP07)

             OVRPRTF    FILE(QPRINT2) OUTQ(LANPRT03) FORMTYPE(K6H1) +
                        SAVE(*YES)

             CALL       PGM(GTBR07) PARM(&DDATEX)

             /* PRINT OF KANBAN TOTAL LIST */
             OVRPRTF    FILE(QPRINT2) OUTQ(LANPRT03) FORMTYPE(K6H1)
             CLRPFM     FILE(HWFILE1/GTBWP15)
             MONMSG     MSGID(CPF0000)

/*           RTVDTAARA  DTAARA(GTBC12DATE) RTNVAR(&PRVDATE) */
/*           CALL       PGM(GTBR15) PARM(&PRVDATE)          */

 /* NOT SCANNED */
             CALL GTBR17
 /* NOT SCANNED AT SHIPPING */
             CALL GTBR18
 /* DUPLICAT SCANNING       */
       /*    CALL AB#RAK  */

             DLTOVR QPRINT
             DLTOVR QPRINT2

/*           CHKOBJ     OBJ(&FLIB/TRANS) OBJTYPE(*DTAARA)          */
/*           MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +            */
/*                        DTAARA(&FLIB/TRANS) TYPE(*CHAR) LEN(2) + */
/*                        TEXT('IAF->ASJ TRANSFER CHECK'))         */
/*           CHGDTAARA  DTAARA(&FLIB/TRANS (1 1)) VALUE('*')       */
/*                                                                 */
/*           CLRPFM     FILE(AANPP50)                              */

 @END:       ENDPGM
