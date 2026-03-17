             /** UEXC22 ***********************************************/
             /*  MACHINE CHANGE REPORT                                */
             /*-------------------------------------------------------*/
             PGM

             CLRPFM     FILE(UEXWP22)
             CLRPFM     FILE(UEXWP23)

 /* READ ABHPL02 AND OUT TO UEXWP22 */

             CALL       PGM(UEXR22)

 /* READ UEXWP22 AND OUT TO UEXWP23 */

             CALL       PGM(UEXR23)

 /* THEN CONVERT UEXWP23 TO ISF BY MANUALLY */

        /**  CALL       PGM(APLC02) **/

             ENDPGM
