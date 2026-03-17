             PGM
             /** VJBC71B **************************************************/
             /*  IT MORNING JOB (RUN 09:30) - BEFORE HONDA UPLOAD         */
             /*  J.WATANABE  2021.06.17                                   */
             /*************************************************************/

 /* RUN CHKC56C CHECK HONDA ORDERS VS EDI ORDERS ----- */
             CALL       PGM(HOBJ1/CHKC56C)

 /* RUN CHKC57B CHECK HONDA ORDERS CONTAIN MIXED PO# - */
             CALL       PGM(HOBJ1/CHKC57B)
             CALL       PGM(HOBJ1/CHKC57C)

             ENDPGM
