             PGM
             /** SYSC03 **********************************************/
             /*  START EDI_R/S   IN QBATCH                           */
             /*  RETREIEVE FROM @QSTRUP FROM 119.00                  */
             /*  QGPL/QCLSRC(@QSTRUP)                                */
             /*                                                      */
             /*  JW    2017.12.11                                    */
             /********************************************************/

 /* SBMJOB EDI_R EDI_S */
             CALL       PGM(JYUCP2)
             MONMSG     MSGID(CPF0000)

             ENDPGM
