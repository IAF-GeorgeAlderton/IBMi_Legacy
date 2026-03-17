             PGM
             /** TRNC12 ************************/
             /* DATA TRANCEFER                 */
             /* T.SAKASHITA      2011.06.01    */
             /************************ TRNC01 **/

         /*  GOTO       CMDLBL(@JUMP)  */

             DLTF       FILE(TRNC12SAVF)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTSAVF    FILE(HFILE1/TRNC12SAVF)

             SAVOBJ     OBJ(AB#PP10) LIB(HFILE1) DEV(*SAVF) +
                          SAVF(TRNC12SAVF) SAVACT(*SYSDFN) +
                          DTACPR(*HIGH)
@JUMP:
             CHGJOB     OUTQ(QTCPIP)
             OVRDBF     FILE(INPUT) TOFILE(HSRC1/FMTSRC) MBR(TRNS12)
             STRTCPFTP  RMTSYS('172.16.8.5')

             ENDPGM
