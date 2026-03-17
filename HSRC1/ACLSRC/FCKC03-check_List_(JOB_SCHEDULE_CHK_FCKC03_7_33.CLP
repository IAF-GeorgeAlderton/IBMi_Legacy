             PGM
             /** FCKC03 ********************************************/
             /*  RUN CHECK DADA REPORT                             */
             /*  JOB SCHEDULE:  CHK.FCKC03  07:33:00               */
             /*  SCHEDULE DAY:  *MON  *TUE  *WED  *THU  *FRI  *SAT */
             /*  J.WATANABE  2020.08.04                            */
             /******************************************************/

 /* FORD ADD-ON ORDER CHECK LIST            */
             CALL       PGM(HOBJ1/CHKC61N)
             CALL       PGM(HOBJ1/CHKC61 )

 /* CHECK HONDA REJECTED ASN                */
             CALL       PGM(HOBJ1/CHKC62B)

 /* FORD PRE ORDER PAB#PPF1                 */
        /**  CALL       PGM(HOBJ1/AB#C0E1)  */

 /* PRINT "FORD ORDER SHORTAGE REPORT"      */
             CALL       PGM(HOBJ1/AB#C0E5)

 /* CHECK FORD DUP ROUTE M/F                */
             CALL       PGM(HOBJ1/CHKC61E)

 /* CHECK FORD ROUTE MASTER ERROR           */
             CALL       PGM(HOBJ1/CHKC61H)

 /* CHECK FORD NOT_SHIPPED REPORT           */
             CALL       PGM(HOBJ1/CHKC61J)

 /* CHECK FORD DELIV=0000 REPORT           */
             CALL       PGM(HOBJ1/CHKC61K)

 /* CHECK HONDA 824 LOG STATUS             */
             CALL       PGM(HOBJ1/AB#RH72) PARM((' '))

 /* SET DDS SOURCE DATA TO VVVPP50B        */
             CALL       PGM(HOBJ1/VVVC93 )

             ENDPGM
