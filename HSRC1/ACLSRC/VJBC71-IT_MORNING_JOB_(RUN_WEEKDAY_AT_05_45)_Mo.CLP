             PGM
             /** VJBC71 ***************************************************/
             /*  IT MORNING JOB (RUN EVERYDAY AT 5:45AM)                  */
             /*  SAVE SOURCE PROGRAM (DAILY)                              */
             /*  J.WATANABE  2017.07.05                                   */
             /*  J.W.        2017.07.12 ADD RE-CREATE VVVPPA0             */
             /*  J.W.        2017.11.06 ADD COPY J-COM DATA               */
             /*  J.W.        2018.03.19 ADD CLEAR AJAPP81 DAILY           */
             /*  J.W.        2018.09.14 ADD CHKC25                        */
             /*************************************************************/
             DCL        VAR(&FR)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&TO)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&AL)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&MB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&RE)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&NC)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(1)

             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM ) TYPE(*CHAR) LEN(10)

             CHGVAR     VAR(&PGM) VALUE('VJBC71  ')

             CHGVAR     VAR(&FR)  VALUE('HSRC1   ')
             CHGVAR     VAR(&TO)  VALUE('HSRC1BK ')
             CHGVAR     VAR(&AL)  VALUE('*ALL    ')
             CHGVAR     VAR(&MB)  VALUE('*FROMMBR')
             CHGVAR     VAR(&RE)  VALUE('*REPLACE')
             CHGVAR     VAR(&NC)  VALUE('*NOCHK  ')
 /* CL */
             CPYF &FR/ACLSRC    &TO/ACLSRC    &AL &MB &RE FMTOPT(&NC)
 /* RPG */
             CPYF &FR/ARPGSRC   &TO/ARPGSRC   &AL &MB &RE FMTOPT(&NC)
 /* DDS */
             CPYF &FR/ADDSSRC   &TO/ADDSSRC   &AL &MB &RE FMTOPT(&NC)
 /* DSP */
             CPYF &FR/ADSPSRC   &TO/ADSPSRC   &AL &MB &RE FMTOPT(&NC)
 /* PRT */
             CPYF &FR/APRTSRC   &TO/APRTSRC   &AL &MB &RE FMTOPT(&NC)
 /* RPGLE */
             CPYF &FR/ARPGLESRC &TO/ARPGLESRC &AL &MB &RE FMTOPT(&NC)
 /* CMD   */
             CPYF &FR/ACMDSRC &TO/ACMDSRC &AL &MB &RE FMTOPT(&NC)

  /* CREATE VVVPPA0/VVVPLB0 -------------------------*/
             CALL PGM(HOBJ1/VVVCA0)

  /* COPY FORD J-COM DATA   -------------------------*/
             CALL PGM(HOBJ1/JCMR10)

  /* CLEAR DEVICE START/END FLAG --------------------*/
             CALL       PGM(HOBJ1/AJAR83) PARM('Y')

 /* CHECK & ADJUST EDIPP42 --------------------------*/
             CALL       PGM(HOBJ1/CHKC25)

 /* CHECK MISSING DELIVERY CODE FOR AB#PP90 (PACKING LIST OPTION) */
             CALL       PGM(HOBJ1/CHKC28)

 /* REMOVE FILE MEMBER -------------------------- */
             CALL       PGM(HOBJ1/CHKC35)

 /* RUN DSPFD (*PRINT) ------------------------------ */
             CALL       PGM(HOBJ1/CHKC31)

 /* RUN REORGANIZE FILES ---------------------------- */
             CALL       PGM(HOBJ1/RGZC02) PARM(&PGM)


 /* RUN DSPFD (*PRINT) HFILE1 ----------------------- */
             CALL       PGM(HOBJ1/CHKC31)

 /* RUN DSPFD (*PRINT) HWFILE1 ---------------------- */
             CALL       PGM(HOBJ1/CHKC32)

 /* RUN DSPFD (*PRINT) MEKI FILE -------------------- */
             CALL       PGM(HOBJ1/CHKC33)

 /* RUN CHKC36 Q/C OF OUTSRC PO DETAIL FILE --------- */
             CALL       PGM(HOBJ1/CHKC36)

 /* RUN CHKC37 CHECK DUPLICATE ORDER   -------------- */
             CALL       PGM(HOBJ1/CHKC37)

 /* RUN CHKC50 CHECK DENSO SHIP DATE   -------------- */
             CALL       PGM(HOBJ1/CHKC50)

 /* RUN CHKC51 CHECK ASN TO BE SENT    -------------- */
             CALL       PGM(HOBJ1/CHKC51A)

 /* RUN CHKC57B CHECK HONDA ORDERS CONTAIN MIXED PO# - */
 /********** CALL       PGM(HOBJ1/CHKC57B)   ***********/
 /********** CALL       PGM(HOBJ1/CHKC57C)   ***********/

 /* RUN CHKC58B CHECK ADVICS ORDER OVER 120 BOX ------ */
             CALL       PGM(HOBJ1/CHKC58B)

 /* RUN CHKC78  CHECK POSTING ERROR    --------------- */
             CALL       PGM(HOBJ1/CHKC78)

 /* RUN CHKC79  CHECK VW ORDERS (ABVPP20) ------------ */
             CALL       PGM(HOBJ1/CHKC79)

 /* RUN CHKC56C CHECK HONDA ORDERS VS EDI ORDERS ----- */
             CALL       PGM(HOBJ1/CHKC56C)

 /* RUN CHKC56D CHECK QPC ORDER ERROR (PP10) --------- */
        /**  CALL       PGM(HOBJ1/CHKC56D)   **/

 /* RUN CHKC56E CHECK QPC ORDER ERROR (PP2A) --------- */
             CALL       PGM(HOBJ1/CHKC56E)

 /* RUN CHKC81  CHECK CHANGE LOCATION (FCEPP01) ------ */
             CALL       PGM(HOBJ1/CHKC81 )

 /* RUN CHKC38B DELETE PROCESSED ORDER (HONDA)  ------ */
             CALL       PGM(HOBJ1/CHKC38B)

 /* RUN CHKC38C DELETE QTY=0 ORDER (HONDA)      ------ */
             CALL       PGM(HOBJ1/CHKC38C)

 /* RUN CHKC52B TTAI ORDERS BIN#/PO# CONFLICT   ------ */
       /**   CALL       PGM(HOBJ1/CHKC52B)            **/

 /* RUN CHKC62  CHECK ASN                       ------ */
             CALL       PGM(HOBJ1/CHKC62 )

 /* RUN CHKC38D CHECK ASN                       ------ */
             CALL       PGM(HOBJ1/CHKC38D)

 /* RUN EDIR75 UPDATE EDIPP46 TTAI LOCATION     ------ */
             CALL       PGM(HOBJ1/EDIR75 )

 /* RUN CHKC23B PART NOT FOUND IN COMMON PART MASTER   */
             CALL       PGM(HOBJ1/CHKC23B)

 /* CHECK INCORRECT UNIT PRICE                         */
 /********* CALL       PGM(HOBJ1/CHKC23)           *****/

 /* RUN CHKC56H CHECK ORDER DATA (BASYOS=0)            */
             CALL       PGM(HOBJ1/CHKC56H)

 /* RUN CHKC38E CHECK HONDA 850 QTY CHANGE             */
             CALL       PGM(HOBJ1/CHKC38E)

 /* RUN CHKC56I CHECK HONDA QPC ERROR ORDER            */
             CALL       PGM(HOBJ1/CHKC56I)

 /* RUN CHKC82  CHECK EDI824 SHIP DATE ERROR           */
 /********** CALL       PGM(HOBJ1/CHKC82 )       *******/

 /* RUN CHKC83  CHECK EXP DATE=9999 IN WASHER KANBAN   */
             CALL       PGM(HOBJ1/CHKC83 )

 /* RUN AB#CBL  GENERATE AB#EP40 FOR AUTOKINITON(5444) */
 /***        CALL       PGM(HOBJ1/AB#CBL )         *****/

 /* RUN CHKC25B CHECK & FIX USER PART(PPA1) BY EDIPP45 */
             CALL       PGM(HOBJ1/CHKC25B)

 /* RUN CHKC37B CHECK INVOICE#=BLANK        BY AB#PP10 */
             CALL       PGM(HOBJ1/CHKC37B)

 /* RUN UEXR31C SET PO# (HONDA)             BY AB#EP90S*/
             CALL       PGM(HOBJ1/UEXR31C)

 /* RUN CHKC79B CHECK PACKING LIST#         BY AB#PL78 */
             CALL       PGM(HOBJ1/CHKC79B)

 /* RUN UEXR90A SET PACKING LIST# IN PP10                  */
 /*********  CALL       PGM(HOBJ1/UEXR90A) PARM('Y') *******/

 /* RUN CHKC39D CHECK DUPLICATE FORECAST  */
             CALL       PGM(HOBJ1/CHKC39D)

 /* RUN CHKCVAI CHECK DSISK STATUS        */
             CALL       PGM(HOBJ1/CHKCVAI)

 /* RUN CHKC05  CHECK KANBAN TEHAI# DUPLICATE */
 /*********  CALL       PGM(HOBJ1/CHKC04) *****/

 /* RUN CHKC62C5 REPORT ASN ERROR (HONDA EDI824) */
             CALL       PGM(HOBJ1/CHKC62C5)

             ENDPGM
