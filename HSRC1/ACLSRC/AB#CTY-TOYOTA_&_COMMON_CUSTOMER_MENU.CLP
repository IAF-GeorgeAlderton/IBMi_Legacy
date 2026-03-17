  PGM
/** AB#CTY *************************************************/
/*  COMMON CUSTOMER MENU                                   */
/*                                                         */
/* J.WATANABE   2018.07.18                                 */
/***********************************************************/
             DCLF       FILE(AB#PWTY)
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

 /* 2.                                   */
          /* IF         COND(&D@SLCT *EQ 2) THEN(CALL PGM(AB#C2Z))  */

 /* 3.<AB#C4M> ORDER CANCELLATION        */
             IF         COND(&D@SLCT *EQ 3) THEN(CALL PGM(AB#C4M))

 /* 4.<AB#CS0> SERVICE PARTS MENU        */
             IF         COND(&D@SLCT *EQ 4) THEN(CALL PGM(AB#CS0))

 /* 5.<AFFC10> UPLOADING ORDER FROM IFS.CSV */
             IF         COND(&D@SLCT *EQ 5) THEN(CALL PGM(AFFC10))

 /* 6.<AB#C2Z> FRS ORDER UPLOAD (TAKUMI)    */
             IF         COND(&D@SLCT *EQ 6) THEN(CALL PGM(AB#C2Z))

 /* 11.<AB#C3Q> PACKING LIST */
             IF         COND(&D@SLCT *EQ 11) THEN(CALL PGM(AB#C3Q))

 /* 12.<AB#C90> PACKING LIST OPTION */
             IF         COND(&D@SLCT *EQ 12) THEN(CALL PGM(AB#C90))

 /* 21.<AB#C2C> PRINT LABEL */
             IF         COND(&D@SLCT *EQ 21) THEN(CALL PGM(AB#C2C))

 /* 22.<AB#RAQ> SCAN DATA MAINTENANCE  */
             IF         COND(&D@SLCT *EQ 22) THEN(CALL PGM(AB#RAQ))

 /* 23.<AB#CA8> TOYOTA LABEL MAINTENANCE */
             IF         COND(&D@SLCT *EQ 23) THEN(CALL PGM(AB#CA8))

 /* 31.<AB#C0F> CREATE ASN  */
             IF         COND(&D@SLCT *EQ 31) THEN(CALL PGM(AB#C0F))

 /* 41.<AB#C0G> CREATE INVOICE */
             IF         COND(&D@SLCT *EQ 41) THEN(CALL PGM(AB#C0G))

 /* 51.<AB#C9K> CUST ORDER SALES STATUS INQ */
             IF         COND(&D@SLCT *EQ 51) THEN(CALL PGM(AB#C9K))

 /* 52.<AHBC02> APICS ORDER STATUS INQ      */
             IF         COND(&D@SLCT *EQ 52) THEN(CALL PGM(AHBC02))

 /* 53.<AB#CBV> ORDER WEB VS EDI COMP       */
             IF         COND(&D@SLCT *EQ 53) THEN(CALL PGM(AB#CBV))

 /* 54.<AB#CAQI> LABEL STATUS INQ      */
             IF         COND(&D@SLCT *EQ 54) THEN(CALL PGM(AB#CAQI))

 /* 55.<AB#CL3> ASN PROCESSING INQ     */
             IF         COND(&D@SLCT *EQ 55) THEN(CALL PGM(AB#CL3 ))

 /* 56.<AB#C1O> ORDER CHANGE HISTORY   */
             IF         COND(&D@SLCT *EQ 56) THEN(CALL PGM(AB#C1O ))

 /* 57.<AM#C20> SCS MENU               */
             IF         COND(&D@SLCT *EQ 57) THEN(CALL PGM(AM#C20 ))

 /* 61.<AB#CTM> MAINTENANCE MENU            */
             IF         COND(&D@SLCT *EQ 61) THEN(CALL PGM(AB#CTM))

 /* 62.<AM#C40> SHIPPING CONFIRMATION  MENU */
             IF         COND(&D@SLCT *EQ 62) THEN(CALL PGM(AM#C41))

 /* 63.<AL#C00> TOYOTA LABEL ISSUE MENU */
             IF         COND(&D@SLCT *EQ 63) THEN(CALL PGM(AL#C00))

             GOTO       STRT
 END:
             ENDPGM
