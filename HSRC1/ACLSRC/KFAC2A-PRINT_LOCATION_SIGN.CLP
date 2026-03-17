             PGM
             /** KFAC2A ********************************************/
             /* NEW PRINT LOCATION TAG                             */
             /*  A.HOTTA 2019/01/24                                */
             /*-------------------------------------------         */
             /*  JW1     2023.08.17 ADD EXCLUSIVE CONTROL (CHKC45) */
             /******************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&KOTAE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MBAN)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&RTN1)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&PROC) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OPTI) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

/* CHECK OTHER USER IS USING  (JW1) ================================*/
             CALL CHKC45 ('KFAC2A' 'KFAC2A' 'Y'  'CHK' &RTN1)
             IF         COND(&RTN1 *NE ' ') THEN(GOTO SEND)
/* =================================================================*/

             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
     /*--------------------------*/
     /*    CHECK ENVIRONMENT     */
     /*--------------------------*/
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             CLRPFM     FILE(KFAWP20)

             CALL       PGM(KFAR2A) PARM(&PROC &OPTI)

             RTVMBRD    FILE(&WLIB/KFAWP20) NBRCURRCD(&REC)
      /**JW1 IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL(SEND)) **/
             IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL(PEND))

             DLTF       FILE(&WLIB/KFAWP2A)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTDUPOBJ  OBJ(KFAWP20) FROMLIB(&WLIB) OBJTYPE(*FILE) +
                          TOLIB(&WLIB) NEWOBJ(KFAWP2A) DATA(*YES)

             CALL       PGM(KFAR2B) PARM(&PROC)
           /* IN & OUT */
             IF         COND(&OPTI *EQ '1') THEN(DO)
             CPYF       FROMFILE(&WLIB/KFAWP2A) +
                          TOFILE(&WLIB/KFAWP20) MBROPT(*ADD) +
                          FMTOPT(*NOCHK)
             ENDDO

           /* ONLY IN */
             IF         COND(&OPTI *EQ '2') THEN(DO)
                 /* NO COPY */
             ENDDO

           /* ONLY OUT */
             IF         COND(&OPTI *EQ '3') THEN(DO)
             CPYF       FROMFILE(&WLIB/KFAWP2A) +
                          TOFILE(&WLIB/KFAWP20) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)
             ENDDO

       /*JW1* CLOSE EXCLUSIVE FLAG ********************/
 PEND:
             CALL CHKC45 ('KFAC2A' 'KFAC2A' 'N'  '' '')
 SEND:
             CHGJOB     RUNPTY(20)
             ENDPGM
