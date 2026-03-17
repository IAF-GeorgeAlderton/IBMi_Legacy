             PGM
             /** SYSC02 **********************************************/
             /*  SUBMIT B2B_E /R /S                                  */
             /*  RETREIEVE FROM @QSTRUP FROM 147.00                  */
             /*  QGPL/QCLSRC(@QSTRUP)                                */
             /*                                                      */
             /*  JW    2017.12.11                                    */
             /********************************************************/

 /* SBMJOB  B2B_R & B2B_S & B2B_E */

             CALL PGM(HOBJ1/EJKC00)
             MONMSG MSGID(CPF0000)

             ENDPGM
