/** ALDC6Y ************************************************/
/*  #OF SHORTAGE SCAN                                     */
/*                                                        */
/* TCHK  10/07/14 CREATE                                  */
/* JW1   07/11/19 USE QTEMP FOR ALDWP68                   */
/**********************************************************/
 PGM

   /*JW1 OVRDBF    FILE(ALDWP68) TOFILE(HWFILE1/ALDWP68)     */
   /*    CLRPFM    HWFILE1/ALDWP68                           */

   /*JW1 ADD 2019.07.11 */
             DLTF       FILE(QTEMP/ALDWP68)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTDUPOBJ  OBJ(ALDWP68) FROMLIB(HWFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP)

             OVRDBF     FILE(ALDWP68) TOFILE(QTEMP/ALDWP68)
             CLRPFM     FILE(QTEMP/ALDWP68)

             CALL       PGM(ALDR6Y)

 ENDPGM
