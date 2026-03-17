             PGM
             /** ABTC35 **********************************************/
             /* SHORTAGE FOLLOW STATUS 2 (JC)                        */
             /*    SAKAKI.          2020.04.07                       */
             /*    JW1.   2020.03.19 ADD PRINTER SELECTION           */
             /********************************************************/

 STP00:
             DLTF       FILE(QTEMP/ABTWL32)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(QTEMP/ABTWP32)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/ABTWP32) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABTWP32) OPTION(*NOLIST *NOSRC) +
                          SIZE(500000 1500 3) LVLCHK(*NO) AUT(*ALL)
             CRTLF      FILE(QTEMP/ABTWL32) SRCFILE(HSRC1/ADDSSRC) +
                          SRCMBR(ABTWL32) OPTION(*NOLIST *NOSRC) +
                          LVLCHK(*NO) AUT(*ALL)
 STP10:

 STP20:     /* ABTWP01 -> ABTWP32 */
            /* ABTWP01 IS CREATED BY ABTC00 */
             OVRDBF     FILE(ABTWP32) TOFILE(QTEMP/ABTWP32)
             CALL       PGM(ABTR31) PARM('6')

 STP30:     /* ABTWP31 -> ABTWP32 */
            /* ABTWP31 IS CREATED BY ABTC00 */
             CALL       PGM(ABTR32) PARM('6')

 #END:       ENDPGM
