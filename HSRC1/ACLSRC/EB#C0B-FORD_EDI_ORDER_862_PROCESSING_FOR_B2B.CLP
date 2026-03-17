  PGM
/** EB#C0B *************************************************/
/*  FORD EDI ORDER 862 PROCESSING FOR B2B                  */
/*      T.SAKAKI        06/07/2017                         */
/*  JW1   2020.11.19 ADD STOP B2B                          */
/*  JW2   2020.12.21 ADD CHKR61D (EDI862 LOG)              */
/*  JW4   2024.05.23 CHG ABFJP02                           */
/*  JWX   2025.06.26 SWITCH TO GENTRAN                     */
/***********************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&PD)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&CNT)  TYPE(*DEC) LEN(10 0)
             DCL        VAR(&CNT1) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

/*** #STOP B2B *********************************************/
/***         GOTO  @END                                  ***/
/***********************************************************/

     /*--------------------------*/
     /*    CHECK ENVIRONMENT     */
     /*--------------------------*/
             RTVJOBA    USER(&USER)
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             OVRDBF     FILE(AGDPP11) TOFILE(&PLIB/A@DPP11)
             OVRDBF     FILE(AGDPL11) TOFILE(&PLIB/A@DPL11)
             OVRDBF     FILE(AGDPL12) TOFILE(&PLIB/A@DPL12)

    /* CLEAR 1PROCESS FILE */
             CLRPFM     FILE(ABF1P01)
             MONMSG     MSGID(CPF0000)

    /* CREATE 1PROCESS FILE */
    /*  EB#EP50 -> ABFAP01 */
    /*          -> ABF1P01 */
             CALL       PGM(EB#R0E)

     /* JW2 SAVE EDI862 LOG                           ****/
     /**JWX  CALL       PGM(CHKR61D) PARM(' ')        ****/

    /* PRINT DATA LIST */
             OVRPRTF    FILE(QPRINT) OUTQ(EPRINT1)
             CALL       PGM(AB#RF2)
             DLTOVR     FILE(QPRINT)

             CLRPFM     FILE(ABFJP01)

             CPYF       FROMFILE(ABF1P01) TOFILE(ABFHP01) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
             MONMSG     MSGID(CPF0000)

    /* UPDATE FORD ORDER ACCUMULATE FILE */
    /*  ABFHP01 -> ABF2P01 */
    /*          -> ABFIP01 */
    /*          -> ABFJP01 */
             CALL       PGM(AB#RF7F4)

             RTVMBRD    FILE(ABFJP01) NBRCURRCD(&CNT1)
             IF         COND(&CNT1 *GT 0) THEN(DO)
  /**JW4     CPYF       FROMFILE(ABFJP01) TOFILE(ABFJP02) +    **/
  /**                     MBROPT(*ADD) FMTOPT(*NOCHK)          **/
             ENDDO

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             OVRPRTF    FILE(QPRINT) OUTQ(EPRINT1 ) FORMTYPE(K6H1) +
                          HOLD(*YES) SAVE(*YES)

    /* PRINT FORD PLANT & DOCK NEW REPORT */
             CALL       PGM(AB#RFN) PARM(&PD)

             IF         COND(&PD *NE ' ') THEN(DO)
             CPYSPLF    FILE(QPRINT) TOFILE(&WLIB/PRT132B) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             RLSSPLF    FILE(QPRINT) JOB(&NBR/&USER/&WSID) +
                          SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(PRT132) TOFILE(&WLIB/PRT132B)
             CALL       PGM(AB#RW0)

             IF         COND(&USER *NE 'TEST') THEN(DO)
             SNDDST     TYPE(*FILE) +
                          TOINTNET((FordOrderError@iafi.com) +
                          (ProductionControl@iafi.com)) DSTD('FORD +
                          error List') MSG('** ERROR ** Please +
                          check the attached list. (EB#C0B).') +
                          DOCFILE(&WLIB/PRT132B) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('FORD Error list')
             DLTOVR     FILE(PRT132)
             ENDDO
             ENDDO

    /* PRINT FORD SEQUENCE DOWN AND EMAIL */
             IF         COND(&CNT1 *GT 0) THEN(DO)

             CHGVAR     VAR(&PD) VALUE(' ')
             OVRPRTF    FILE(QPRINT) OUTQ(EPRINT1 ) FORMTYPE(K6H1) +
                          HOLD(*YES) SAVE(*YES)

             CALL       PGM(AB#RF@) PARM(&PD)

  /**JW4**/  CPYF       FROMFILE(ABFJP01) TOFILE(ABFJP02) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)

             IF         COND(&PD *NE ' ') THEN(DO)

             CPYSPLF    FILE(QPRINT) TOFILE(&WLIB/PRT132B) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             RLSSPLF    FILE(QPRINT) JOB(&NBR/&USER/&WSID) +
                          SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(PRT132) TOFILE(&WLIB/PRT132B)
             CALL       PGM(AB#RW0)

             IF         COND(&USER *NE 'TEST') THEN(DO)
             SNDDST     TYPE(*FILE) +
                          TOINTNET((FordOrderError@iafi.com)) +
                          DSTD('FORD Sequence Down') MSG('** ERROR +
                          ** Please check the attached list. +
                          (EB#C0B).') DOCFILE(&WLIB/PRT132B) +
                          DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD('FORD +
                          Sequence Down')
             DLTOVR     FILE(PRT132)
             ENDDO
             ENDDO
             ENDDO

     /* JWX SAVE EDI862 LOG */
             CALL       PGM(CHKR61D) PARM(' ')

    /* JW3 SET BATCH# IN ABF2P01        */
    /******  CALL       EB#R0F      *****/

             DLTOVR     FILE(*ALL)
@END:
             ENDPGM
