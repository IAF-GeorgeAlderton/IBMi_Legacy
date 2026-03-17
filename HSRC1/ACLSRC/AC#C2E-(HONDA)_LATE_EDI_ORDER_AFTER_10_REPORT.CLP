             PGM
             /** AC#C2E **************************************************/
             /*  HONDA LATE EDI ORDER AFTER 10 REPORT                    */
             /*  (RUN IN WRKJOBSCDE "CHK.HONDA9 SCD USER DEF 12:33:00")  */
             /*  J.WATANABE 2019.04.08                                   */
             /************************************************************/

             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR )  TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTN )  TYPE(*CHAR) LEN(1)
             DCL        VAR(&UPD )  TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

             OVRPRTF    FILE(QPRINT) OUTQ(EPRINT1)

  /********* CALL       PGM(AC#R2E)  PARM(&RTN) **************/
             CALL       PGM(AC#R2E2) PARM(&RTN)

             CRTDUPOBJ  OBJ(PRT132A) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM QTEMP/PRT132A

             CPYSPLF    FILE(QPRINT) TOFILE(QTEMP/PRT132A) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)

             OVRDBF     FILE(PRT132) TOFILE(QTEMP/PRT132A)

             CALL       PGM(HOBJ1/AB#RW0)

       /*    SNDDST     TYPE(*FILE) +                                  */
       /*                 TOINTNET(('KAZ.WATANABE@iafi.com'))      +   */
       /*                 DSTD('HONDA EDI LATE ORDER AFTER 10AM')  +   */
       /*                 MSG('HONDA LATE EDI ORDER AFTER 10 REPORT. + */
       /*                 (AC#C2E).') DOCFILE(QTEMP/PRT132A)       +   */
       /*                 DOCTYPE(*FFT) SNDFMT(*NOTE) DOCD('HONDA  +   */
       /*                 LATE EDI ORDER AFTER 10 REPORT')             */

             SNDDST     TYPE(*FILE) +
                          TOINTNET(('ProductionControl@iafi.com')) +
                          DSTD('HONDA EDI LATE ORDER AFTER 10')    +
                          MSG('HONDA LATE EDI ORDER AFTER 10       +
                          REPORT. (AC#C2E).')                      +
                          DOCFILE(QTEMP/PRT132A) DOCTYPE(*FFT)     +
                          SNDFMT(*NOTE) DOCD('HONDA LATE EDI ORDER +
                          AFTER 10 REPORT')

 ENDP:
             DLTOVR     FILE(PRT132)

/** TEMP                                     **/
/*********** CALL       AC#C2ET    ************/

             ENDPGM
