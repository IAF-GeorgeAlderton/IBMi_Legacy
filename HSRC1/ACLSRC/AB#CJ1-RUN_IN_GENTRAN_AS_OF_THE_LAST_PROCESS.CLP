             PGM
             /* AB#CJ1 *******************************************/
             /* RUN IN GENTRAN AS OF THE LAST PROCESS            */
             /* JW   2025.05.15                                  */
             /****************************************************/

 /* SET HONDA ASN RESEND FLAG                         */
             CALL       PGM(HOBJ1/AB#R0PA) PARM((' '))

 /** SET ASN 824 STATUS IN AB#EP14                  **/
             CALL       PGM(AB#R13A) PARM((' '))

 /** SET ASN BATCH# IN AB#EP14                      **/
             CALL       PGM(AB#R13B) PARM((' '))

 /** SET ASN ACCEPT STATUS IN AB#EP14  .....        **/
             CALL       PGM(AB#R13C) PARM((' '))

 /** CLEAR FORD ASN AB#EP66/63/64/65                **/
             CALL       PGM(CLRR01 )

             ENDPGM
