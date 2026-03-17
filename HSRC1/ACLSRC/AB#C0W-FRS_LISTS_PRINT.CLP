             PGM
             /** AB#C0W **********************************************/
             /*  FRS LISTS PRINT                                     */
             /*    H.AMANO       MAR/03/03                           */
             /*                                                      */
             /* TCHK1 04/20/06 CHG SNDDST                            */
             /* JW1   04/27/18 CHG SNDDST                            */
             /********************************************** AB#C0W **/

             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)
             OVRPRTF    FILE(QPRINT) OUTQ(LANPRT50)
             OVRPRTF    FILE(QPRINT2) HOLD(*YES)
             OVRPRTF    FILE(QPRINT) OUTQ(EPRINT1) HOLD(*YES)  /*JW*/
             OVRPRTF    FILE(QPRINT2) OUTQ(EPRINT1) HOLD(*YES) /*JW*/

             CALL       PGM(AB#R0U)
             CALL       PGM(AB#R0W) PARM(&PD)

             IF         COND(&PD *NE ' ') THEN(DO)
             CPYSPLF    FILE(QPRINT2) TOFILE(HWFILE1/PRT132B) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             DLTSPLF    FILE(QPRINT2) JOB(&NBR/&USER/&WSID) +
                          SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)

             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132B)
             CALL       PGM(AB#RW0)

     /*JW1   SNDDST     TYPE(*FILE) +                                   */
     /*                   TOINTNET((DeletedFRSList@iafi.com) +          */
     /*                   (TanebeK@iafi.com *CC)) DSTD('Deleted FRS +   */
     /*                   List') MSG('Please check the deleted FRS +    */
     /*                   list as attached. (AB#C0W)') +                */
     /*                   DOCFILE(HWFILE1/PRT132B) DOCTYPE(*FFT) +      */
     /*                   SNDFMT(*NOTE) DOCD('Deleted FRS list') /* +   */
     /*                   TCHK1 * /                                     */

             SNDDST     TYPE(*FILE) +
                          TOINTNET((DeletedFRSList@iafi.com) +
                          (TanebeK@iafi.com *CC)) DSTD('EDI FRS +
                          ORDER LIST') MSG('Please check ** EDI FRS +
                          ORDER LIST ** as attached. (AB#C0W).') +
                          DOCFILE(HWFILE1/PRT132B) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('EDI FRS ORDER LIST') +
                          /* TCHK1 */

             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(PRT132)
             ENDDO

             DLTOVR     FILE(QPRINT)
             DLTOVR     FILE(QPRINT2)

  @END:
             ENDPGM
