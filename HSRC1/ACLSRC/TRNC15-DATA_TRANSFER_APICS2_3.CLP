             PGM
             /** TRNC15 ************************/
             /* DATA TRANCEFER APICS2/3        */
             /* T.SAKASHITA      2011.06.01    */
             /************************ TRNC01 **/

         /*  GOTO       CMDLBL(@JUMP)  */

             DLTF       FILE(TRNC15SAVF)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTSAVF    FILE(HFILE1/TRNC15SAVF)

             DLTF       FILE(TRNC15WSVF)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTSAVF    FILE(HFILE1/TRNC15WSVF)

             /* FCEPP01 */
             /* AAVPPN1 */

             /* AAMPP11 */
             /* GHCPP21 */

             /* AAFPP01めっき*/
             /* AAHPP01引取り*/
             /* AANPP01半製品*/
             /* AAPPP01完成品*/
             /* ABHPP01工程内*/
             /* ADHPP01焼入れ*/
             /* CADPP01２*/

             /* AAJPP11 */

             /* AAAPP01条件*/
             /* AABPP01設定*/
             /* AACPP01バーコード*/

             /* AGAPP31１平準化*/
             /* AGAWP31１平準化ワーク*/
             /* BTAPP04１計画発行*/

             /* CABPP01２平準化*/
             /* CABWP01２平準化ワーク*/
             /* CTAPP01２計画発行*/

             SAVOBJ     OBJ(FCEPP01 AAVPPN1 AAMPP11 GHCPP21 AAFPP01 +
                          AAHPP01 AANPP01 AAPPP01 ABHPP01 ADHPP01 +
                          CADPP01 AAJPP11 AAAPP01 AABPP01 AACPP01 +
                          AGAPP31 CABPP01 CTAPP01 BTAPP04) +
                          LIB(HFILE1) DEV(*SAVF) SAVF(TRNC15SAVF) +
                          SAVACT(*SYSDFN) DTACPR(*HIGH)

             SAVOBJ     OBJ(AGAWP31 CABWP01) LIB(HWFILE1) DEV(*SAVF) +
                          SAVF(TRNC15WSVF) SAVACT(*SYSDFN) +
                          DTACPR(*HIGH)
@JUMP:
             CHGJOB     OUTQ(QTCPIP)
             OVRDBF     FILE(INPUT) TOFILE(HSRC1/FMTSRC) MBR(TRNS15)
             STRTCPFTP  RMTSYS('172.16.8.5')

             ENDPGM
