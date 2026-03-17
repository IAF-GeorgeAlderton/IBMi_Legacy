             PGM
             /** AB#CAR ********************************/
             /*    ASN LOG                             */
             /* TCH                        05.01.10    */
             /* TCHK1 11/03/06 CHG SNDDST              */
             /******************************** AB#CAR **/

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CNT) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&DTA) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             OVRPRTF    FILE(QPRINT) OUTQ(QPRINT) HOLD(*YES) SAVE(*YES)

             CALL       PGM(AB#RAR) PARM(&DTA)

             IF         COND(&DTA *EQ '1') THEN(DO)

             CPYSPLF    FILE(QPRINT) TOFILE(HWFILE1/PRT132B) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(HWFILE1/PRT132B)
             CALL       PGM(AB#RW0)

/* TCHK1     SNDDST     TYPE(*FILE) +                                  */
             /*           TOINTNET((Production_Control@iafi.com) +     */
             /*           (*NONE *PRI) (*NONE *PRI)) DSTD('ASN sent +  */
             /*           without scanning log') MSG('ASN has been +   */
             /*           sent without scanning all labels. Please +   */
             /*           check the attached list.') +                 */
             /*           DOCFILE(HWFILE1/PRT132B) DOCTYPE(*FFT) +     */
             /*           SNDFMT(*NOTE) DOCD('ASN without scanning +   */
             /*           log') DOCDATE(*CURRENT) CRTDATE(*CURRENT) +  */
             /*           CMPDATE(*CURRENT)                            */

             SNDDST     TYPE(*FILE) +
                          TOINTNET((Production_Control@iafi.com) +
                          (Larry.Cox@iafi.com *CC)) DSTD('ASN sent +
                          without scanning log') MSG('ASN has been +
                          sent without scanning all labels. Please +
                          check the attached list.(AB#CAR)') +
                          DOCFILE(HWFILE1/PRT132B) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('ASN without scanning +
                          log') DOCDATE(*CURRENT) CRTDATE(*CURRENT) +
                          CMPDATE(*CURRENT) /* TCHK1 */
             DLTOVR     FILE(PRT132)
             DLTSPLF    FILE(QPRINT) JOB(&NBR/&USER/&WSID) +
                          SPLNBR(*LAST)
             MONMSG     MSGID(CPF0000)
             ENDDO

             ENDPGM
