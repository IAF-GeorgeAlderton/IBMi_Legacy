             PGM
             DCL        VAR(&PFLG)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PSIRE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR)   TYPE(*CHAR) LEN(6)

             RTVJOBA    JOB(&WSID)  USER(&USER) NBR(&NBR)
             CHGVAR     VAR(&PSIRE) VALUE('0390')
             CHGVAR     VAR(&WLIB ) VALUE('HWFILE1')

/* PREPARE */

/*-------------------------------------------------------------------*/
             DLTF       FILE(QTEMP/AB#WP202)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP202) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             FMTDTA     INFILE((&WLIB/AB#WP202HM)) OUTFILE(QTEMP/AB#WP202) +
                          SRCFILE(HSRC1/FMTSRC) SRCMBR(AB#S23) +
                          OPTION(*NOPRT)

             DLTF       FILE(QTEMP/AB#WP20)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP20) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AB#WP20) OPTION(*NOLIST *NOSRC) +
                          LVLCHK(*NO) AUT(*ALL)

 /* AB#R22: PRINT "EDI FRS ORDER LIST" */

             OVRDBF     FILE(AB#WP202) TOFILE(QTEMP/AB#WP202)
             OVRDBF     FILE(AB#WP20) TOFILE(QTEMP/AB#WP20)
             CALL       PGM(AB#R21) PARM(&PSIRE)

             OVRDBF     FILE(AB#WP20) TOFILE(QTEMP/AB#WP20)
             CALL       PGM(AB#R22)

 /* AB#R23: UPDATE AU#NP11 / AU#PP11   */

             OVRDBF     FILE(AB#WP20) TOFILE(QTEMP/AB#WP20)
         /***CALL       PGM(AB#R23) PARM(&PSIRE)**/


             DLTF       FILE(QTEMP/MITANKF)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/MITANKF) RCDLEN(300) +
                          OPTION(*NOLIST *NOSRC) LVLCHK(*NO) AUT(*ALL)

 /* AB#R25: DETECT PRICE ERROR (MITANKF) */

             OVRDBF     FILE(AB#WP20) TOFILE(QTEMP/AB#WP20)
             OVRDBF     FILE(MITANKF) TOFILE(QTEMP/MITANKF)
             CALL       PGM(AB#R25) PARM(&PFLG)

 /* AB#R26: PRINT "UNDECIDED UNIT PRICE LIST" */

             IF         (&PFLG *EQ '*') DO
             OVRDBF     FILE(MITANKF) TOFILE(QTEMP/MITANKF)
             CALL       PGM(AB#R26) PARM(&PSIRE)

       /***  SNDPGMMSG  MSG('UNIT PRICES ARE NOT REGISTERED IN THE +   ***/
       /***               SALES UNIT PRICE MASTER FILES. UNIT PRICE +  ***/
       /***               MUST BE REGISTERED. (AB#C2B)') TOMSGQ(&WSID) ***/

/* SEND ERROR MSG (QPRINT6) */
             CPYSPLF    FILE(QPRINT ) TOFILE(HWFILE1/PRT132B) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             OVRDBF     FILE(PRT132) TOFILE(PRT132B)
             CALL       PGM(AB#RW0)

             IF         COND(&USER *NE 'TEST') THEN(DO)
             SNDDST     TYPE(*FILE) +
                          TOINTNET((SALESGROUP@IAFI.COM)) +
                          DSTD('HONDA PRICE ERROR') MSG('** HONDA +
                          EDI Order Contains Incorrect Unit Price. +
                          Please Register The Correct Price In +
                          Price Master. (AB#C2B).') +
                          DOCFILE(HWFILE1/PRT132B) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('HONDA EDI PRICE ERROR')
             ENDDO
       /***                                                            ***/

             ENDDO

             DLTOVR     FILE(*ALL)
             ENDPGM
