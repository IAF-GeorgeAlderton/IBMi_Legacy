             PGM
             /** TRNC01 ************************/
             /* DATA TRANCEFER                 */
             /* T.SAKASHITA      2011.06.01    */
             /************************ TRNC01 **/

             DLTF       FILE(TRNC11SAVF)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTSAVF    FILE(HFILE1/TRNC11SAVF)

             SAVLIB     LIB(HSRC1) DEV(*SAVF) +
                          SAVF(HFILE1/TRNC11SAVF) SAVACT(*SYSDFN) +
                          DTACPR(*HIGH)

             CHGJOB     OUTQ(QTCPIP)
             OVRDBF     FILE(INPUT) TOFILE(HSRC1/FMTSRC) MBR(TRNS11)
          /* STRTCPFTP  RMTSYS('172.16.8.5') */

             ENDPGM
