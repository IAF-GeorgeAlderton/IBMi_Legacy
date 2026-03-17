  PGM
/** AC#CHN *************************************************/
/*  HONDA CONSOLIDATED PACKING LIST MENU                   */
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
             DCLF       FILE(AC#PWHN)

             RTVJOBA    JOB(&WSID) USER(&USR)

/* TCHK4 */  OVRDBF     FILE(AGDPP11) TOFILE(HFILE1/A@DPP11)
/* TCHK4 */  OVRDBF     FILE(AGDPL11) TOFILE(HFILE1/A@DPL11)
/* TCHK4 */  OVRDBF     FILE(AGDPL12) TOFILE(HFILE1/A@DPL12)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USR &WLIB)

             CHGVAR     VAR(&#PGM) VALUE('AC#CHN')
 STRT:
             CHGVAR     VAR(&D@SLCT) VALUE('00')
             SNDRCVF    RCDFMT(DSP01)

             IF         (&IN01 *EQ '1') GOTO END

 /* 1. CREATE CONSOLIDATED PACKING LIST                                      */
             IF         COND(&D@SLCT *EQ 1  ) THEN(DO)
             CALL       PGM(AC#C01)
             ENDDO

 /* 2. PACKING LIST/SHIPPER REPORT                                           */
             IF         COND(&D@SLCT *EQ 2) THEN(CALL PGM(AC#C02))

 /* 3. CREATE LABEL DATA                                             *********/
 /*          IF         COND(&D@SLCT *EQ 3) THEN(CALL PGM(AB#C2L))   *********/
 /* 4. RE-CREATE LABEL DATA                                          *********/
 /*          IF         COND(&D@SLCT *EQ 4) THEN(CALL PGM(AB#CEB))   *********/
 /* 5. QUICK RECEIVE                                                 *********/
 /*          IF         COND(&D@SLCT *EQ 5) THEN(DO)                 *********/
 /*          RTVJOBA    JOB(&WSID)                                   *********/
 /*          CHGVAR     VAR(&WKSID) VALUE(%SUBSTRING(&WSID 1 3))     *********/
 /*          CHKOBJ     OBJ(AB#WP2Z) OBJTYPE(*FILE) MBR(&WKSID)      *********/
 /*          MONMSG     MSGID(CPF9815) EXEC(ADDPFM FILE(AB#WP2Z) MBR(&WKSID))*/
 /*          CLRPFM     FILE(AB#WP2Z) MBR(&WKSID)                    *********/
 /*          OVRDBF     FILE(AB#WP2Z) TOFILE(AB#WP2Z) MBR(&WKSID)    *********/
 /*          CALL AB#RE8                                             *********/
 /*          ENDDO                                                   *********/
 /* 6. MASTER PICK UP LIST/BILL OF LADING                            *********/
 /*          IF         COND(&D@SLCT *EQ 6) THEN(CALL PGM(AB#R3S))   *********/

 /* 3. PRINT MASTER PACKING LIST & BILL OF LADING                            */
             IF         COND(&D@SLCT *EQ 3) THEN(CALL PGM(AC#C22))

 /* 4. CREATE CONSOLIDATED ASN                                               */
             IF         COND(&D@SLCT *EQ 4) THEN(CALL PGM(AC#C10))

             GOTO       STRT
 END:
             ENDPGM
