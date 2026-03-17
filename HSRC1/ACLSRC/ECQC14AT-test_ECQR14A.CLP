             PGM
             /** ECQC14A *********************************/
             /* DIE USAGE INQUIRY (REGRIND)              */
             /* PROGRAM ID. : ECQC15. <CLP>              */
             /* CREATE DATE.  04/01/05                   */
             /* AUTHOR.    TCH  REGRIND   TCH56          */
             /* JW1  2021.01.06 ADD CLRPFM ECQWP15       */
             /* JW2  2024.06.05 ADD EXCLUSIVE CHECK      */
             /********************************************/

  /*******   CLRPFM     FILE(&WLIB/ECQWP16 )                    *******/
  /*******   OVRDBF     FILE(ECQWP16 ) TOFILE(&WLIB/ECQWP16 )   *******/

             DLTF       FILE(QTEMP/ECQWP16)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTDUPOBJ OBJ(ECQWP16) FROMLIB(HWFILE1) OBJTYPE(*FILE) TOLIB(QTEMP)
             CLRPFM     FILE(QTEMP/ECQWP16)

             OVRDBF     FILE(ECQWP16 ) TOFILE(QTEMP/ECQWP16 )

             CALL       PGM(ECQR14A)

             ENDPGM
