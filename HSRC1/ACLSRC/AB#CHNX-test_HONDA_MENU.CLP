  PGM
/** AB#CHN *************************************************/
/*  HONDA MENU                                             */
/*                                                         */
/* TCHK1 06/15/09 ADD TEMPORARY CHANGE CALENDAR M/F        */
/* TCHK2 03/19/10 ADD OPT#11(TOTAL CONTAINERS SHIPPED INQ) */
/* TCHK3 12/04/14 ADD OPT#12(shipment history & forecast)  */
/* T.SAKAKI 05/13/15  AB#R2G  OUTQ CHANGE     %0001        */
/************************************** AB#CHN *************/
             DCL        VAR(&WKSID)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MHN1) TYPE(*CHAR) LEN(5)
             DCL        VAR(&MHN2) TYPE(*CHAR) LEN(5)
             DCL        VAR(&MHN3) TYPE(*CHAR) LEN(5)
             DCL        VAR(&MHN4) TYPE(*CHAR) LEN(5)
             DCL        VAR(&NONY) TYPE(*DEC) LEN(4 0)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PSIRE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KEN) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCLF       FILE(AB#PWHN)

             RTVJOBA    JOB(&WSID) USER(&USR)

/* TCHK4 */  OVRDBF     FILE(AGDPP11) TOFILE(HFILE1/A@DPP11)
/* TCHK4 */  OVRDBF     FILE(AGDPL11) TOFILE(HFILE1/A@DPL11)
/* TCHK4 */  OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/A@DPL12)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USR &WLIB)

             CHGVAR     VAR(&#PGM) VALUE('AB#CHN')
 STRT:
             CHGVAR     VAR(&D@SLCT) VALUE('00')
             SNDRCVF    RCDFMT(DSP01)

             IF         (&IN01 *EQ '1') GOTO END

 /* ORDER PROCESSING */
             IF         COND(&D@SLCT *EQ 1  ) THEN(DO)

             DLTF       FILE(QTEMP/AB#WP2A)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/AB#WP2A) RCDLEN(100) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(AB#WP2A) TOFILE(QTEMP/AB#WP2A)
    /*TEMP   CALL       PGM(AB#C2B) PARM('0390')    */
             CALL       PGM(AB#C2BX) PARM('0390')

             RTVMBRD    FILE(QTEMP/AB#WP2A) NBRCURRCD(&KEN)
             IF         (&KEN *GT 0) THEN(DO)
           /* %0001 */
        /*   OVRPRTF    FILE(QPRINT) DEVTYPE(&PDEVT) PAGESIZE(66 +
                          132) OVRFLW(60) RPLUNPRT(*YES) +
                          OUTQ(&PRTG) FORMTYPE(K6H1) IGCDTA(&PIGCD) */
             OVRPRTF    FILE(QPRINT) PAGESIZE(66 132) OVRFLW(60) +
                          RPLUNPRT(*YES) OUTQ(LANPRT09) FORMTYPE(K6H1)
             CALL       PGM(AB#R2G) PARM(&PSIRE)
             DLTF       FILE(QTEMP/AB#WP2A)
             DLTOVR     FILE(QPRINT)
             ENDDO

             ENDDO

  /* PICK UP LIST/SHIPPER REPORT */
             IF         COND(&D@SLCT *EQ 2) THEN(CALL PGM(AB#C3U))

  /* CREATE LABEL DATA  */
             IF         COND(&D@SLCT *EQ 3) THEN(CALL +
                          PGM(AB#C2L))

  /* RE-CREATE LABEL DATA  */
             IF         COND(&D@SLCT *EQ 4) THEN(CALL +
                          PGM(AB#CEB))

  /* QUICK RECEIVE */
             IF         COND(&D@SLCT *EQ 5) THEN(DO)

             RTVJOBA    JOB(&WSID)
             CHGVAR     VAR(&WKSID) VALUE(%SUBSTRING(&WSID 1 3))
             CHKOBJ     OBJ(AB#WP2Z) OBJTYPE(*FILE) MBR(&WKSID)
             MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2Z) +
                          MBR(&WKSID))
             CLRPFM     FILE(AB#WP2Z) MBR(&WKSID)
             OVRDBF     FILE(AB#WP2Z) TOFILE(AB#WP2Z) MBR(&WKSID)

             CALL AB#RE8
             ENDDO

  /* MASTER PICK UP LIST/BILL OF LADING */
             IF         COND(&D@SLCT *EQ 6) THEN(CALL PGM(AB#R3S))

  /* CREATE ASN DATA */
             IF         COND(&D@SLCT *EQ 7) THEN(CALL PGM(AB#C0P))

  /* IPP TAG ENTRY           */
             IF         COND(&D@SLCT *EQ 8) THEN(CALL PGM(AB#RE7))


  /* CONTRY OF ORIGIN CHANGE */
             IF         COND(&D@SLCT *EQ 9) THEN(CALL PGM(AB#R1B) +
                          PARM(&MHN1 &MHN2 &MHN3 &MHN4 &NONY))

  /* PROJECT NUMBER CHANGE */
             IF         COND(&D@SLCT *EQ 10) THEN(CALL PGM(AB#RE6))

/* TCHK2 S */
  /* TOTAL CONTAINERS SHIPPED INQ */
             IF         COND(&D@SLCT *EQ 11) THEN(CALL PGM(AB#C9H))
/* TCHK2 E */

/* TCHK3 S */
  /* Shipment history & forecast ave */
             IF         COND(&D@SLCT *EQ 12) THEN(CALL PGM(ABBC57H))
/* T.SAKAKI */
  /* MAINTANANCE MENU FOR HONDA */
             IF         COND(&D@SLCT *EQ 13) THEN(CALL PGM(AB#CHM))
/* TCHK3 E */

             GOTO       STRT
 END:
             ENDPGM
