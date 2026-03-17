             PGM
             /** TRNC13 ************************/
             /* DATA TRANCEFER                 */
             /* T.SAKASHITA      2011.06.01    */
             /************************ TRNC01 **/

         /*  GOTO       CMDLBL(@JUMP)  */

             DLTF       FILE(TRNC13SAVF)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTSAVF    FILE(HFILE1/TRNC13SAVF)

             SAVOBJ     OBJ(FCEPP01 AJSPP01 AAFPP01 AAHPP01 CADPP01 +
                          AARPP11 AAMPP11) LIB(HFILE1) DEV(*SAVF) +
                          SAVF(TRNC13SAVF) SAVACT(*SYSDFN) +
                          DTACPR(*HIGH)
@JUMP:
             CHGJOB     OUTQ(QTCPIP)
             OVRDBF     FILE(INPUT) TOFILE(HSRC1/FMTSRC) MBR(TRNS13)
             STRTCPFTP  RMTSYS('172.16.8.5')

             ENDPGM
