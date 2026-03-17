             PGM
             /*** AFFC70 ************************************/
             /*   UPLOAD IFS.FC.HORIZONTAL.CSV TO AB#EP20   */
             /*   JW (SRA)    2024.04.29                    */
             /***********************************************/
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&UPFLG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NONY ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PFLG ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&KEN )  TYPE(*DEC ) LEN(10 0)
             DCL        VAR(&NBR )  TYPE(*CHAR) LEN(6)
             DCL        VAR(&RTN1)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG1)  TYPE(*CHAR) LEN(60)
             DCL        VAR(&MSG2)  TYPE(*CHAR) LEN(60)
             DCL        VAR(&KEN)   TYPE(*DEC) LEN(10 0)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&NBR)

 /* TEMP MSG: UNDER CONSTRUCTING **************************************/
 /**         IF         COND(&USER *NE 'I0777') THEN(DO)             **/
 /**         CHGVAR     VAR(&MSG1) VALUE('THIS PROGRAM IS UNDER +    **/
 /**                      CONSTRUCTING ! ')                          **/
 /**         CHGVAR     VAR(&MSG2) VALUE('  ')                       **/
 /**         CALL UTLC97A (&MSG1 &MSG2)                              **/
 /**         GOTO @ENDP                                              **/
 /**         ENDDO                                                   **/
 /*********************************************************************/

/* CHECK OTHER USER IS USING  ======================================*/
             CALL       PGM(CHKC45) PARM('AFFC70' 'AFFC70' 'Y' 'CHK' &RTN1)
             IF         COND(&RTN1 *NE ' ') THEN(GOTO @ENDP )
/* =================================================================*/

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             CLRPFM     FILE(HWFILE1/AFFWP70)
             CLRPFM     FILE(HWFILE1/AFFWP71)
             CLRPFM     FILE(HFILE1/ABAEP21)

             OVRDBF     FILE(AFFWP70) TOFILE(HWFILE1/AFFWP70)
             OVRDBF     FILE(AFFWP71) TOFILE(HWFILE1/AFFWP71)
             CALL       PGM(AFFR70) PARM(&UPFLG)

/* SKIP TO ENDP WHEN NO DATA TO UPLOAD */
             IF         COND(&UPFLG *NE 'Y') THEN(GOTO CMDLBL(@ENDP2))

/* SKIP IF NO DATA                     */
             RTVMBRD    FILE(HWFILE1/AFFWP71) NBRCURRCD(&KEN)
             IF         COND(&KEN *EQ 0) THEN(DO)
             CHGVAR     VAR(&MSG1) VALUE('** NO FORECAST DATA FOR +
                          UPLOADING **                 ')
             CHGVAR     VAR(&MSG2) VALUE('END PROGRAM WITHOUT +
                          UPLOADING')
             CALL       PGM(UTLC97A) PARM(&MSG1 &MSG2)
             GOTO @ENDP2
             ENDDO

/* ======= UPLOAD TO FORECAST  =========*/
/* SAVE AFFWP70 --> 70S, AFFWP71 --> 71S */
             CALL       PGM(AFFR72)

/** CREATE ABAEP21 **/
             CALL       PGM(AFFR73)

/** DELETE PP60    **/
             CALL       PGM(AFFR74)

/** ERROR MSG **/
             RTVMBRD    FILE(ABAEP21) NBRCURRCD(&KEN)
             IF         COND(&KEN *EQ 0) THEN(DO)
             CHGVAR     VAR(&MSG1) VALUE('THERE IS NO DATA TO UPLOAD !')
             CHGVAR     VAR(&MSG2) VALUE('THE PROGRAM WILL END +
                          WITHOUT ANY DATA UPLOADING..')
             CALL       PGM(UTLC97C) PARM(&MSG1 &MSG2)
             GOTO       CMDLBL(@ENDP2)
             ENDDO

/** SAVE ABAEP21 **/
             CPYF       FROMFILE(HFILE1/ABAEP21) +
                          TOFILE(HFILE1/ABAEP21S) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)

/** UPLOADING ABAEP21 **/
             CALL       ABACP8

/** DISPLAY MSG  **/
             CHGVAR     VAR(&MSG1) VALUE('THE FORECAST DATA FROM +
                          IFS.FC.HORIZONTAL.csv HAS BEEN')
             CHGVAR     VAR(&MSG2) VALUE('UPLOADED SUCCESSFULLY...')
             CALL       PGM(UTLC97A) PARM(&MSG1 &MSG2)

 @ENDP2:
             CALL       PGM(CHKC45) PARM('AFFC70' 'AFFC70' 'N' '' '')

 @ENDP:      DLTOVR     FILE(*ALL)
             ENDPGM
