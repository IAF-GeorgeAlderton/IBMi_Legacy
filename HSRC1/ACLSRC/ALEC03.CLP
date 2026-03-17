/** ALEC03 ************************************************/
/*  BTP QRY VER2                                          */
/*                                                        */
/* T.SAKAKI 12/07/20                                     */
/**********************************************************/
 PGM

             DLTF       FILE(ALEWP03)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTPF      FILE(HWFILE1/ALEWP03) RCDLEN(128) TEXT('BTP +
                          QRY WORK FILE') OPTION(*NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO) AUT(*ALL)

         CALL      PGM(ALER04)

 ENDPGM
