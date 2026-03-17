             PGM
             /** MFAC2X **************************************/
             /* FACILITY MANAGEMENT PACKAGE UPDATE           */
             /*        T.SAKAKI        2014.08.01            */
             /********************************** MFAC2X ******/

   /* 1. CSV DATA TRANSFER TO HWFILE1/MXAWP01 */
      /* PROCESS,MACHINE#,MACHINE TYPE,MACHINE GROUP,TURN,TURN(NEW) */
      /* AK ,AK1,          ,AK ,1,720 */

             CPYFRMIMPF FROMFILE(HWFILE1/MXAWP01) TOFILE(MXAPP01) +
                          MBROPT(*REPLACE)

   /* 2. CALL MFAR2X  */

 END:        ENDPGM
