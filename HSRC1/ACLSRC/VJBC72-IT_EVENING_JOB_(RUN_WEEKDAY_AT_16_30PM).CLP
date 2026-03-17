             PGM
             /** VJBC72 ***************************************************/
             /*  IT EVENING JOB (RUN EVERYDAY AT 16:30PM)                 */
             /*  J.WATANABE  2020.08.19                                   */
             /*************************************************************/

 /* RUN CHKC50 CHECK DENSO SHIP DATE   -------------- */
             CALL       PGM(HOBJ1/CHKC50)

 /* RUN CHKC51 CHECK ASN TO BE SENT    -------------- */
             CALL       PGM(HOBJ1/CHKC51A)

 /* RUN CHKC58B CHECK ADVICS ORDER OVER 120 BOX ------ */
             CALL       PGM(HOBJ1/CHKC58B)

 /* RUN CHKC79  CHECK VW ORDERS (ABVPP20) ------------ */
             CALL       PGM(HOBJ1/CHKC79)

 /* RUN CHKC56C CHECK HONDA ORDERS VS EDI ORDERS ----- */
             CALL       PGM(HOBJ1/CHKC56C)

 /* RUN CHKC38C DELETE QTY=0 ORDER (HONDA)      ------ */
             CALL       PGM(HOBJ1/CHKC38C)

 /* RUN CHKC52B TTAI ORDERS BIN#/PO# CONFLICT   ------ */
    /**      CALL       PGM(HOBJ1/CHKC52B)            **/

 /* RUN CHKC62  CHECK ASN                       ------ */
             CALL       PGM(HOBJ1/CHKC62 )

 /* RUN EDIR75 UPDATE EDIPP46 TTAI LOCATION     ------ */
             CALL       PGM(HOBJ1/EDIR75 )

 /* RUN CHKC23B PART NOT FOUND IN COMMON PART MASTER   */
             CALL       PGM(HOBJ1/CHKC23B)

 /* RUN CHKC62B HONDA REJECTED ASN                     */
             CALL       PGM(HOBJ1/CHKC62B)

 /* RUN CHKC56H CHECK ORDER DATA (BASYOS=0)            */
             CALL       PGM(HOBJ1/CHKC56H)

 /* RUN CHKC82  CHECK EDI824 SHIP DATE ERROR           */
 /********   CALL       PGM(HOBJ1/CHKC82 )   ***********/

 /* RUN CHKC83  CHECK EXP DATE=9999 IN WASHER KANBAN   */
             CALL       PGM(HOBJ1/CHKC83 )

 /* RUN CHKC57  CHECK HONDA ORDERS CONTAIN MIXED PO# - */
 /*********  CALL       PGM(HOBJ1/CHKC57B)     *********/
 /*********  CALL       PGM(HOBJ1/CHKC57C)     *********/

 /* RUN UEXR31C SET PO# (HONDA)             BY AB#EP90S*/
             CALL       PGM(HOBJ1/UEXR31C)

 /* RUN CHKC79B CHECK PACKING LIST#         BY AB#PL78 */
             CALL       PGM(HOBJ1/CHKC79B)

 /* RUN UEXR90A SET PACKING LIST# IN PP10                 */
 /********   CALL       PGM(HOBJ1/UEXR90A) PARM('Y')  *****/

 /* RUN CHKC39D CHECK DUPLICATE FORECAST               */
             CALL       PGM(HOBJ1/CHKC39D)

 /* RUN CHKC49A CHECK FORECAST DISCREPANCY             */
             CALL       PGM(HOBJ1/CHKC49A)

 /* RUN CHKC37 CHECK DUPLICATE ORDER   -------------- */
             CALL       PGM(HOBJ1/CHKC37)

 /* CHECK HONDA 824 LOG STATUS         -------------- */
             CALL       PGM(HOBJ1/AB#RH72) PARM((' '))

             ENDPGM
