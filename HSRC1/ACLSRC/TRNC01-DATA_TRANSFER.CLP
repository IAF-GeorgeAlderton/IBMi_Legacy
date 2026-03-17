             PGM
             /** TRNC01 ************************/
             /* DATA TRANCEFER                 */
             /* T.SAKASHITA      2011.06.01    */
             /* FUKUTOMI         2021.08.18    */
             /*          FCEPP11 ADD           */
             /************************ TRNC01 **/

          /* GCQPP31 -> GCQWP80 */
          /* GCQPP11 -> GCQWP83 */
             CALL       PGM(GCQC80)

             DLTF       FILE(TRNC01SAVF)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTSAVF    FILE(HFILE1/TRNC01SAVF)

             SAVOBJ     OBJ(FCEPP01 AAMPP11 AEBPP01 AKCPP01 AGDPP11 +
                          FAAPP02 FCEPP40 FGBPP01 MFAPP21 AKDPP01 +
                          GCQWP80 A#DPP11 FCEPP11 GCQWP83) LIB(HFILE1) +
                          DEV(*SAVF) SAVF(HFILE1/TRNC01SAVF) +
                          TGTRLS(V7R3M0) SAVACT(*SYSDFN) +
                          ACCPTH(*NO) DTACPR(*HIGH)

             CHGJOB     OUTQ(QTCPIP)
             OVRDBF     FILE(INPUT) TOFILE(HSRC1/FMTSRC) MBR(TRNS01)
             STRTCPFTP  RMTSYS('172.16.8.1')

             ENDPGM
