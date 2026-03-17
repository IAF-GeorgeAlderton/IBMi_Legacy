  PGM
/** AB#CGN *************************************************/
/*  GENERAL CUSTOMER MENU                                  */
/*                                                         */
/* J.WATANABE   2018.07.18                                 */
/***********************************************************/
             DCLF       FILE(AB#PWGN)
             DCL        VAR(&WKSID) TYPE(*CHAR) LEN(3)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&MHN1)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&MHN2)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&MHN3)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&MHN4)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&NONY)  TYPE(*DEC) LEN(4 0)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PSIRE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KEN)   TYPE(*DEC) LEN(10 0)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             RTVJOBA    JOB(&WSID) USER(&USR)

             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USR &WLIB)
 STRT:
             CHGVAR     VAR(&D@SLCT) VALUE('00')
             SNDRCVF    RCDFMT(DSP01)

             IF         (&IN01 *EQ '1') GOTO END

 /* 1.<AB#C4N> ORDER MAINTENANCE */
             IF         COND(&D@SLCT *EQ 1) THEN(CALL PGM(AB#C4N))

 /* 2.<AB#CS0> SERVICE PARTS MENU        */
             IF         COND(&D@SLCT *EQ 2) THEN(CALL PGM(AB#CS0))

 /* 3.<AB#C2Z> FRS ORDER UPLOAD (TAKUMI) */
             IF         COND(&D@SLCT *EQ 3) THEN(CALL PGM(AB#C2Z))

 /* 4.<AFFC10> UPLOADING ORDER FROM IFS.CSV */
             IF         COND(&D@SLCT *EQ 4) THEN(CALL PGM(AFFC10))

 /* 5.<AB#C0W> PRINT FRS LIST               */
             IF         COND(&D@SLCT *EQ 5) THEN(CALL PGM(AB#C0W))

 /* 11.<AB#C3Q> PACKING LIST */
             IF         COND(&D@SLCT *EQ 11) THEN(CALL PGM(AB#C3Q))

 /* 21.<AB#C2C> PRINT LABEL */
             IF         COND(&D@SLCT *EQ 21) THEN(CALL PGM(AB#C2C))

 /* 22.<AB#RAQ> SCAN DATA MAINTENANCE  */
             IF         COND(&D@SLCT *EQ 22) THEN(CALL PGM(AB#RAQ))

 /* 23.<AB#CA8> TOYOTA LABEL MAINTENE  */
             IF         COND(&D@SLCT *EQ 23) THEN(CALL PGM(AB#CA8))

 /* 31.<AB#C0F> CREATE ASN  */
             IF         COND(&D@SLCT *EQ 31) THEN(CALL PGM(AB#C0F))

 /* 41.<AB#C98> CUST ORDER SALES STATUS INQ */
             IF         COND(&D@SLCT *EQ 41) THEN(CALL PGM(AB#C9K))

 /* 42.<AHBC02> APICS ORDER STATUS INQ      */
             IF         COND(&D@SLCT *EQ 42) THEN(CALL PGM(AHBC02))

 /* 43.<AB#CAQI> LABEL STATUS INQ           */
             IF         COND(&D@SLCT *EQ 43) THEN(CALL PGM(AB#CAQI))

 /* 44.<AB#CL3> ASN PROCESSING INQUIRY */
             IF         COND(&D@SLCT *EQ 44) THEN(CALL PGM(AB#CL3))

 /* 45.<AB#C1O> ORDER CHANGE HISTORY   */
             IF         COND(&D@SLCT *EQ 45) THEN(CALL PGM(AB#C1O))

 /* 46.<AM#C27> TOYOTA SCS PALLET VERIFICATION */
             IF         COND(&D@SLCT *EQ 46) THEN(CALL PGM(AM#C27))

 /* 47.<AB#CBV> ORDER (WEB VS EDI) COMP INQ    */
             IF         COND(&D@SLCT *EQ 47) THEN(CALL PGM(AB#CBV))

 /* 51.<AB#C90> PACKING LIST OPTION MAINTENANCE */
             IF         COND(&D@SLCT *EQ 51) THEN(CALL PGM(AB#C90))

 /* 52.<AB#C4M> ORDER CANCELLATION        */
             IF         COND(&D@SLCT *EQ 52) THEN(CALL PGM(AB#C4M))

 /* 53.<EDIR71> USER PART# MAINTENANCE    */
             IF         COND(&D@SLCT *EQ 53) THEN(CALL PGM(EDIR71))

 /* 54.<AB#C1G> REVISION/ORIGIN COUNTRY   */
             IF         COND(&D@SLCT *EQ 54) THEN(CALL PGM(AB#C1G))

 /* 60.<AB#CTM> MAINTENANCE               */
             IF         COND(&D@SLCT *EQ 60) THEN(CALL PGM(AB#CTM))

 /* 61.<AM#C41> SHIPPING CONFIRMATION MENU*/
             IF         COND(&D@SLCT *EQ 61) THEN(CALL PGM(AM#C41))

 /* 62.<AL#C00> TOYOTA LABEL ISSUE MENU   */
             IF         COND(&D@SLCT *EQ 62) THEN(CALL PGM(AL#C00))


             GOTO       STRT
 END:
             ENDPGM
