             PGM
             /** FCKC00 ********************************************/
             /*  RUN CHECK DADA REPORT                             */
             /*  JOB SCHEDULE:  CHK.FCKC01  10:10:00               */
             /*  SCHEDULE DAY:  *MON  *TUE  *WED  *THU  *FRI       */
             /*  J.WATANABE  2017.11.06                            */
             /******************************************************/

 /* CHECK FA MASTER(AJSPP01) AND SEND REPORT BY MAIL  */
             CALL       PGM(HOBJ1/FCKC01)

 /* CHECK FA MASTER(AARPP11) WGT AND SEND REPORT MAIL */
             CALL       PGM(HOBJ1/FCKC02)

 /* INCORRECT COMMON PART LIST                        */
             CALL       PGM(HOBJ1/CHKC22)

 /* CHECK INCORRECT UNIT PRICE                        */
 /********   CALL       PGM(HOBJ1/CHKC23)   ***********/

 /* CHECK INCORRECT AB#PPA1                           */
             CALL       PGM(HOBJ1/CHKC23C)

 /* CHECK OUTSRC PO VS LEVELLED MASTER (AGAPP31)      */
             CALL       PGM(HOBJ1/CHKC29)

 /* CHECK DUPLICATE ORDER           (AB#PP10/AB#PP2A) */
             CALL       PGM(HOBJ1/CHKC37)

 /* CHECK FILE STATUS (VVVPP30)                       */
             CALL       PGM(HOBJ1/CHKC47)

 /* CHECK HONDA PLANT/SHIPTO (PP2A)                   */
             CALL       PGM(HOBJ1/CHKC41)

 /* CHECK DENSO SHIP DATE                             */
             CALL       PGM(HOBJ1/CHKC50)

 /* CHECK ASN TO BE SENT                              */
             CALL       PGM(HOBJ1/CHKC51A)

 /* CHECK ORDERS                                      */
             CALL       PGM(HOBJ1/CHKC52)

 /* SET UP USER PART TABLE                            */
             CALL       PGM(HOBJ1/EDIR70)
             CALL       PGM(HOBJ1/EDIR73)

 /* SET UP TTAI LOCATION TABLE                        */
             CALL       PGM(HOBJ1/EDIR75)

 /* CHECK EDI 820                                     */
             CALL       PGM(HOBJ1/CHKC43)

 /* FORD ADD-ON ORDER CHECK LIST                      */
             CALL       PGM(HOBJ1/CHKC61)

 /* CHECK HONDA EDI ORDER (DELIVERY=0)                */
             CALL       PGM(HOBJ1/CHKC38D)

 /* RUN CHKC38E CHECK HONDA 850 QTY CHANGE             */
             CALL       PGM(HOBJ1/CHKC38E)

 /* CHECK UNIT PRICE MORE THAN $50                    */
             CALL       PGM(HOBJ1/CHKC24)

 /* CHECK INVOICE#=BLANK (AB#PP10)                    */
             CALL       PGM(HOBJ1/CHKC37B )

 /* RUN CHKC79B CHECK PACKING LIST#         BY AB#PL78 */
             CALL       PGM(HOBJ1/CHKC79B)

             ENDPGM
