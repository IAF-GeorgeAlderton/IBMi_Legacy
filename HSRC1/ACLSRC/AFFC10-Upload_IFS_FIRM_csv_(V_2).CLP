             PGM
             /*** AFFC10 *****************************************/
             /*   UPLOAD IFS.FIRM.CSV FROM IFS DATA              */
             /*   JW (SRA)    2018.06.07                         */
             /*--------------------------------------------      */
             /*   JW1  2024.01.29 CHG WORK FILE TO USE QTEMP     */
             /****************************************************/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&UPFLG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SIRE ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PFLG ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&KEN )  TYPE(*DEC ) LEN(10 0)
             DCL        VAR(&NBR )  TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTN1)  TYPE(*CHAR) LEN(1)

             DCL        VAR(&MSG1 ) TYPE(*CHAR) LEN(30) VALUE(' ')
             DCL        VAR(&MSG2 ) TYPE(*CHAR) LEN(30) VALUE(' ')

/* CHECK OTHER USER IS USING  ======================================*/
             CALL       PGM(CHKC45) PARM('AFFC10 ' 'AFFC10 ' 'Y' 'CHK' &RTN1)
             IF         COND(&RTN1 *NE ' ') THEN(GOTO @ENDP )
/* =================================================================*/

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

             DLTF       FILE(QTEMP/AFFWP10)
             MONMSG     MSGID(CPF0000)
           CRTDUPOBJ  OBJ(AFFWP10) FROMLIB(HWFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/AFFWP10)

             DLTF       FILE(QTEMP/AFFWP11)
             MONMSG     MSGID(CPF0000)
           CRTDUPOBJ  OBJ(AFFWP11) FROMLIB(HWFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(QTEMP/AFFWP11)


             OVRDBF     FILE(AFFWP10) TOFILE(QTEMP/AFFWP10)
             OVRDBF     FILE(AFFWP11) TOFILE(QTEMP/AFFWP11)
   /*****JW  CALL       PGM(AFFR10 ) PARM(&UPFLG &SIRE) ****/
             CALL       PGM(AFFR10A) PARM(&UPFLG &SIRE)

/* SKIP TO ENDP WHEN NO DATA TO UPLOAD */
             IF         COND(&UPFLG *NE 'Y') THEN(GOTO CMDLBL(@ENDP2))

/*TEMP STOP **********************************************/
/*********   GOTO @ENDP2                            ******/
/*********************************************************/

  /* ======= UPLOAD TO FRS ORDER =========*/
             /* SAVE AFFWP10 TO AFFWP10S */
             CALL       PGM(AFFR13)

 /********JW CALL       PGM(AFFC12 ) PARM(&SIRE) *****/
             CALL       PGM(AFFC12A) PARM(&SIRE)

             IF         (%SWITCH(0XXXXXXX)) DO
             CHGVAR VAR(&MSG1) VALUE('!! ORDER NOT PROCESSED !!     ')
             CALL       PGM(UTLC96 ) PARM(&MSG1 &MSG2)

             MONMSG     MSGID(CPF0000)
             GOTO CMDLBL(@ENDP2)
             ENDDO

             OVRPRTF    FILE(QPRINT)  OUTQ(EPRINT1) HOLD(*YES)
             OVRPRTF    FILE(QPRINT2) OUTQ(EPRINT1) HOLD(*YES)
             OVRPRTF    FILE(QPRINT5) OUTQ(EPRINT1) HOLD(*YES)
             OVRPRTF    FILE(QPRINT6) OUTQ(EPRINT1) HOLD(*YES)

             DLTF       FILE(QTEMP/AB#WP452)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP452) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(QTEMP/AB#WP201)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP201) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(QTEMP/AB#WP202)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP202) RCDLEN(256) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(QTEMP/AB#WP20)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP20) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(AB#WP20) OPTION(*NOLIST *NOSRC) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(QTEMP/MITANKF )
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/MITANKF ) RCDLEN(300) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             OVRDBF     FILE(AB#WP452) TOFILE(QTEMP/AB#WP452)
             OVRDBF     FILE(AB#WP201) TOFILE(QTEMP/AB#WP201)
             OVRDBF     FILE(AB#WP202) TOFILE(QTEMP/AB#WP202)
             OVRDBF     FILE(AB#WP20)  TOFILE(QTEMP/AB#WP20)
             OVRDBF     FILE(MITANKF)  TOFILE(QTEMP/MITANKF)

/* GENERATE AB#PP43 */
             IF         COND(&SIRE *EQ '0170') THEN(DO)
             CALL       PGM(GTAR10)
             ENDDO

             CPYF       FROMFILE(QTEMP/AB#WP45) TOFILE(QTEMP/AB#WP452) +
                        MBROPT(*ADD) FMTOPT(*NOCHK)

/* CHECK SHIP DATE */
             CALL       PGM(AB#R451)

/* GENARATE AB#PP10 & AB#PPA1    */
/* &USER2 = &USER + ID(=I) - ORDER ENTRY ID=IFS     JW */
             CHGVAR     VAR(&USER2) VALUE(&USER)
             CHGVAR     VAR(%SST(&USER2 10 1)) VALUE('I')

             CALL       PGM(AB#R45) PARM(&USER2)

             IF         (%SWITCH(X0XXXXXX)) DO
             CHGVAR VAR(&MSG1) VALUE('!! ORDER NOT PROCESSED !!     ')
             CHGVAR VAR(&MSG2) VALUE('   SEE IT DEPARTMENT...       ')
             CALL       PGM(UTLC96 ) PARM(&MSG1 &MSG2)

             MONMSG     MSGID(CPF0000)
             GOTO CMDLBL(@ENDP2)
             ENDDO

           CPYF FROMFILE(AB#WP201) TOFILE(AB#WP202) MBROPT(*ADD) FMTOPT(*NOCHK)

 /* CHECK FRS ORDER (AB#WP202 --> AB#WP20 )  */
             CALL       PGM(AB#R21) PARM(&SIRE)

             CLRPFM     FILE(&WLIB/PRT132)
             CPYSPLF    FILE(QPRINT) TOFILE(&WLIB/PRT132) +
                          JOB(&NBR/&USER/&WSID) SPLNBR(*LAST)
             MONMSG     MSGID(CPF3303)
             RTVMBRD    FILE(&WLIB/PRT132) NBRCURRCD(&KEN)
             IF         COND(&KEN *NE 0) THEN(DO)
             OVRDBF     FILE(PRT132) TOFILE(&WLIB/PRT132)
             CALL       PGM(AB#RW0)
             DLTOVR     FILE(PRT132)
             SNDDST     TYPE(*FILE) +
                          TOINTNET((Production_Control@iafi.com)) +
                          DSTD('EDI FRS ORDER FROM IFS.csv LIST') +
                          MSG('EDI FRS Order has been created from +
                          IFS.csv. Please Confirm Orders by +
                          Attached List. (AFFC10).') +
                          DOCFILE(&WLIB/PRT132) DOCTYPE(*FFT) +
                          SNDFMT(*NOTE) DOCD('EDI FRS ORDER FROM +
                          IFS.csv LIST')
             ENDDO

             CALL       PGM(AB#R22)

 /* CHECK UNIT PRICE */
             CALL       PGM(AB#R25) PARM(&PFLG)

             IF         (&PFLG *EQ '*') DO
             CALL       PGM(AB#R26) PARM(&SIRE)

             CHGVAR VAR(&MSG1) VALUE('!! PRICE NOT UPLOADED !!      ')
             CHGVAR VAR(&MSG2) VALUE('   PLEASE SEE ERROR REPORT... ')
             CALL       PGM(UTLC96 ) PARM(&MSG1 &MSG2)

             MONMSG     MSGID(CPF0000)
             GOTO CMDLBL(@ENDP2)
             ENDDO

             CHGVAR VAR(&MSG1) VALUE('ORDERS HAVE BEEN UPLOADED...  ')
             CHGVAR VAR(&MSG2) VALUE(' ')
             CALL       PGM(UTLC96 ) PARM(&MSG1 &MSG2)

             MONMSG     MSGID(CPF0000)
 @ENDP2:
             CALL       PGM(CHKC45) PARM('AFFC10 ' 'AFFC10 ' 'N' '' '')

 @ENDP:      DLTOVR     FILE(*ALL)
             ENDPGM
