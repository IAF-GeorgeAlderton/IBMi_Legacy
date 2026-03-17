/** ALEC02 ************************************************/
/*  BTP QRY                                               */
/*                                                        */
/* T.SAKAKI 12/07/19                                      */
/**********************************************************/
 PGM

         CLRPFM    FILE(ALEWP02)
         CALL      PGM(ALER02)

             DLTF       FILE(ALEWP03)
             MONMSG     MSGID(CPF3261 CPF2105)

             CRTPF      FILE(HWFILE1/ALEWP03) RCDLEN(512) TEXT('BTP +
                          QRY WORK FILE') OPTION(*NOLIST) +
                          SIZE(*NOMAX) LVLCHK(*NO) AUT(*ALL)

         CALL      PGM(ALER03)

 ENDPGM
