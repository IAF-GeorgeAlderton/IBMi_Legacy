             PGM
             /** AB#C20  *********************************/
             /*  PRINT QR FOR TEAM MBR WORKER CODE       */
             /********************************************/

             DCL        VAR(&RCDS) TYPE(*DEC) LEN(10 0) VALUE(0)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&EMLADR) TYPE(*CHAR) LEN(30)
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(1)

             RTVJOBA    USER(&USER)

/**************************************************************/
             CLRPFM     FILE(AB#WP200)
             MONMSG     MSGID(CPF0000)

/**************************************************************/
/* get email address to receive pdf file...                   */

             CALL       PGM(UTLR81B) PARM((&EMLADR) (&RTN))

             IF         COND(&RTN = '*') THEN(GOTO CMDLBL(ENDIT))

/**************************************************************/
/* get worker codes to be printed...                          */

             CALL       PGM(AB#R200)

/**************************************************************/
/* if file contains records, then print TM QRs...             */

             RTVMBRD    FILE(AB#WP200) NBRCURRCD(&RCDS)
             MONMSG     MSGID(CPF0000)

             IF         COND(&RCDS *GT 0) THEN(DO)

/* override print file to saveoutq so tla forms will process) */
             OVRPRTF    FILE(AB#PR20) OUTQ(SAVEOUTQ) SAVE(*YES) +
                          USRDTA(&USER) EXPDATE(*DAYS) DAYS(7)

             CALL       PGM(AB#R20)

                                          ENDDO

 ENDIT:      ENDPGM
