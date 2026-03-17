             PGM

             DLTF       FILE(QTEMP/INVPP40B)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTDUPOBJ  OBJ(INVPP40) FROMLIB(HFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP) NEWOBJ(INVPP40B)

             /* FCEPP01 -> INVPP40B */
             CALL       PGM(INVR4G)

             DLTF       FILE(QTEMP/INVWP41)
             MONMSG     MSGID(CPF3261 CPF2105)
             CPYF       FROMFILE(HWFILE1/INVWP41) +
                          TOFILE(QTEMP/INVWP41) CRTFILE(*YES)

         /*  DLTF       FILE(QTEMP/AB#WPS3)                   */
         /*  MONMSG     MSGID(CPF3261 CPF2105)                */
         /*  CPYF       FROMFILE(HWFILE1/AB#WPS3) +           */
         /*               TOFILE(QTEMP/AB#WPS3) CRTFILE(*YES) */

         /*  DLTF       FILE(QTEMP/AB#WPS4)                   */
         /*  MONMSG     MSGID(CPF3261 CPF2105)                */
         /*  CPYF       FROMFILE(HWFILE1/AB#WPS4) +           */
         /*               TOFILE(QTEMP/AB#WPS4) CRTFILE(*YES) */

             CLRPFM     FILE(QTEMP/INVWP41)
         /*  CLRPFM     FILE(QTEMP/AB#WPS3)                   */
         /*  CLRPFM     FILE(QTEMP/AB#WPS4)                   */

             /* INVPP40 -> INVWP41 */
             OVRDBF     FILE(INVPP40) TOFILE(QTEMP/INVPP40B)
             CALL       PGM(INVR41) PARM(' ' '  ' '  ' ' ' '1')

             DLTF       FILE(HWFILE1/INVWP47)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/INVWP47) RCDLEN(2015) +
                          OPTION(*NOLIST) SIZE(10000 3000) +
                          LVLCHK(*NO) AUT(*ALL)

             DLTF       FILE(QTEMP/INVPP40B)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTDUPOBJ  OBJ(INVPP40) FROMLIB(HFILE1) OBJTYPE(*FILE) +
                          TOLIB(QTEMP) NEWOBJ(INVPP40B)

             CLRPFM     FILE(INVPP46)

             /* INVWP41 -> INVPP46 */
             OVRDBF     FILE(OUTPUT) TOFILE(INVWP47)
             CALL       PGM(INVR47)

             /* INVPP46 -> INVWP41 */
             CALL       PGM(INVR48)

             CALL       PGM(INVR42)
             CALL       PGM(INVR43)

             CPYF       FROMFILE(QTEMP/INVWP41) +
                          TOFILE(HWFILE1/INVWP41) MBROPT(*ADD) +
                          FROMRCD(1)

             DLTF       FILE(QTEMP/INVWP41)

             ENDPGM
