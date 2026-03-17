             PGM
             /*** GWGC73 ***************************/
             /* HOLIDAY SCHEDULE                           */
             /*                                    */
             /*************************** GWGC73 ***/

             CPYF FROMFILE(HFILE1/BTAPP05) +
                  TOFILE(TFILE1/BTAPP05)   +
                  MBROPT(*REPLACE)         +
                  FMTOPT(*NOCHK)

             CPYF FROMFILE(HFILE1/BTBPP05) +
                  TOFILE(TFILE1/BTBPP05)   +
                  MBROPT(*REPLACE)         +
                  FMTOPT(*NOCHK)

/* PT */
             OVRDBF     FILE(GWSCDP1) TOFILE(HWFILE1/GWSCDP1)
             OVRDBF     FILE(GWCALP1) TOFILE(HWFILE1/GWCALP1)
             OVRDBF     FILE(BTAPL05) TOFILE(TFILE1/BTAPL05)
             OVRDBF     FILE(GDKPL02) TOFILE(HFILE1/GDKPL02)
             OVRPRTF    FILE(QPRINT)  OUTQ(QDKT)

             CALL       PGM(HOBJ1/GWGR73)


/*           OVRDBF     FILE(GWSCDP2) TOFILE(HWFILE1/GWSCDP2) */
/*           OVRDBF     FILE(GWCALP2) TOFILE(HWFILE1/GWCALP2) */
/*           OVRDBF     FILE(BTAPL05) TOFILE(TFILE1/BTAPL05)  */
/*           OVRDBF     FILE(GDKPL02) TOFILE(HFILE1/GDKPL02)  */
/*           OVRPRTF    FILE(QPRINT)  OUTQ(QDKT)              */
/*                                                            */
/*           CALL       PGM(HOBJ1/GWGR74)                     */

/* MATERIAL */
             OVRDBF     FILE(GWSCDP3) TOFILE(HWFILE1/GWSCDP3)
             OVRDBF     FILE(GWCALP3) TOFILE(HWFILE1/GWCALP3)
             OVRDBF     FILE(BTBPL05) TOFILE(TFILE1/BTBPL05)

             CALL       PGM(HOBJ1/GWGR75)


 @END:       ENDPGM
