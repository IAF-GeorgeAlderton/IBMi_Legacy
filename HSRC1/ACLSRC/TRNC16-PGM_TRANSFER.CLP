             PGM
             /** TRNC16 ************************/
             /* PGM TRANCEFER                  */
             /* T.SAKASHITA      2011.06.01    */
             /************************ TRNC01 **/

         /*  GOTO       CMDLBL(@JUMP)  */

             DLTF       FILE(TRNC16SAVF)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTSAVF    FILE(HFILE1/TRNC16SAVF)

             SAVOBJ     OBJ(UTLR21C) LIB(HOBJ1) DEV(*SAVF) +
                          SAVF(TRNC16SAVF) SAVACT(*SYSDFN) +
                          DTACPR(*HIGH)
@JUMP:
             CHGJOB     OUTQ(QTCPIP)
             OVRDBF     FILE(INPUT) TOFILE(HSRC1/FMTSRC) MBR(TRNS16)
             STRTCPFTP  RMTSYS('172.16.8.5')

             ENDPGM
