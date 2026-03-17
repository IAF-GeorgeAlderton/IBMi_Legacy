             PGM
             /** TRNC14 ************************/
             /* DATA TRANCEFER                 */
             /* T.SAKASHITA      2011.06.01    */
             /************************ TRNC01 **/

         /*  GOTO       CMDLBL(@JUMP)  */

             DLTF       FILE(TRNC14SAVF)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTSAVF    FILE(HFILE1/TRNC14SAVF)

             /* AJSWP15 BZ         */
             /* AJSWP17 DACRO      */
             /* AJSWP19 GEOMET     */
             /* AJSWP13 DSM        */
             /* AJSWP11 MAC DERMID */

             SAVOBJ     OBJ(AJSWP40 AJSWP15 AJSWP17 AJSWP19 AJSWP13 +
                          AJSWP11) LIB(HWFILE1) DEV(*SAVF) +
                          SAVF(TRNC14SAVF) SAVACT(*SYSDFN) +
                          DTACPR(*HIGH)
@JUMP:
             CHGJOB     OUTQ(QTCPIP)
             OVRDBF     FILE(INPUT) TOFILE(HSRC1/FMTSRC) MBR(TRNS14)
             STRTCPFTP  RMTSYS('172.16.8.5')

             ENDPGM
