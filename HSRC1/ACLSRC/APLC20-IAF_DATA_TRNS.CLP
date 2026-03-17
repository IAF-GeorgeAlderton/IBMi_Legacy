             PGM        PARM(&SYSTM &SLIBL &SFILE &PCFIL &PUTGT)
             /** APLC20 ******************************************/
             /*IAF DATA TRNS                                     */
             /*  Y.SAMEJIMA.........           2012.09.19        */
             /*--------------------------------------------------*/
             /****************************************************/
             DCL        VAR(&SYSTM)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&SLIBL)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&SFILE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PCFIL)  TYPE(*CHAR) LEN(52)
             DCL        VAR(&TRNTO)  TYPE(*CHAR) LEN(15)
             DCL        VAR(&LIBFI)  TYPE(*CHAR) LEN(21)
             DCL        VAR(&PUTGT)  TYPE(*CHAR) LEN(3)

             CALL       PGM(APLR20) PARM(&SLIBL &SFILE &LIBFI)

             CHGVAR     VAR(&TRNTO) VALUE('               ')
       /*    IF         COND(&SYSTM *EQ 'AOYAMA') THEN(DO)     */
       /*    CHGVAR     VAR(&TRNTO) VALUE('172.16.8.1     ')   */
       /*    ENDDO                                             */
             IF         COND(&SYSTM *EQ 'IAFAYM') THEN(DO)
             CHGVAR     VAR(&TRNTO) VALUE('172.16.8.5     ')
             ENDDO
             IF         COND(&SYSTM *EQ 'IAF   ') THEN(DO)
             CHGVAR     VAR(&TRNTO) VALUE('10.1.1.25      ')
             ENDDO

             IF         COND(&SYSTM *EQ '      ') THEN(GOTO @END)


             STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)

   /* PC---->AS400 */
             IF         COND(&PUTGT *EQ 'PUT') THEN(DO)
             STRPCCMD   PCCMD('C:/AS400/FTP/FTPTRN.BAT' *BCAT &TRNTO +
                          *BCAT &LIBFI *BCAT &PCFIL *BCAT &PUTGT) +
                          PAUSE(*YES)
             ENDDO
   /* AS400---->PC */
             IF         COND(&PUTGT *EQ 'GET') THEN(DO)
             STRPCCMD   PCCMD('C:/AS400/FTP/FTPTRN.BAT' *BCAT &TRNTO +
                          *BCAT &PCFIL *BCAT &LIBFI *BCAT &PUTGT) +
                          PAUSE(*NO)
             ENDDO


 @END:
             ENDPGM
