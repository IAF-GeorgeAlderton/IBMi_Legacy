             PGM
             /** VJBC73 ***************************************************/
             /*  IT EVENING JOB (RUN 13:00) - NOON                        */
             /*  J.WATANABE  2021.04.29                                   */
             /*************************************************************/

 /* RUN CHKC51 CHECK ASN TO BE SENT    -------------- */
             CALL       PGM(HOBJ1/CHKC51A)

 /* RUN UEXR31C SET PO# (HONDA)             BY AB#EP90S*/
             CALL       PGM(HOBJ1/UEXR31C)

 /* RUN AB#C9 PRINT FORD MISSING ORDER REPORT */
             CALL       PGM(HOBJ1/AB#C9P3) PARM(' ')

             ENDPGM
