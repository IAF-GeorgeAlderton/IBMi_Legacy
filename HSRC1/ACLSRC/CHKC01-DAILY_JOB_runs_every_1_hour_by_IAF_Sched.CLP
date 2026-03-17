             PGM
             /** CHKC01 **********************************************/
             /*  DAILY JOB: RUNS EVERY 1 HOUR BY LARRYS SCHEDULER    */
             /*  J.WATANABE 2024.01.24                               */
             /********************************************************/

 /* CHKC57C PRINT "HONDA ORDER MIXED PO# CHECK LIST" */
             CALL       PGM(CHKC57B)
             CALL       PGM(CHKC57C)

 /* CHKC82  PRINT "EDI824 SHIP DATE ERROR REPORTT" */
             CALL       PGM(CHKC82 )

 /* RUN UEXR90A SET PACKING LIST# IN PP10              */
             CALL       PGM(HOBJ1/UEXR90A) PARM('Y')

 /* RUN AB#CBL  GENERATE AB#EP40 FOR AUTOKINITON(5444) */
             CALL       PGM(HOBJ1/AB#CBL )

 /* CHECK INCORRECT UNIT PRICE                        */
             CALL       PGM(HOBJ1/CHKC23)

 /* SET DELIVERY CODE IN EP40S                        */
             CALL       PGM(HOBJ1/EDIR81 ) PARM((' '))

 /* CHECK JCMPP11 (NOT RECEIVE 997)        */
             CALL       PGM(HOBJ1/CHKC61L)

 /* CHECK & FIX AB#PPF1/F5NONY=0           */
             CALL       PGM(HOBJ1/CHKR25C) PARM(' ' 'Y' 'N')

             ENDPGM
