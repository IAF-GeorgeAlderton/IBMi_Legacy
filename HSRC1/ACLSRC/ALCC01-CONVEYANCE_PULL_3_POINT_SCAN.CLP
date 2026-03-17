/** ALCC01 ************************************************/
/*  CONVEYANCE PULL 3-POINT SCAN                          */
/*                                                        */
/* TCHK1 04/21/09 CREATE                                  */
/* LEC   02/04/16 ADD LOGIC TO AVOID HANDY TERMINAL RESET */
/*                GETTING AROUND LOCK OUT ERROR.          */
/**********************************************************/
 PGM

             OVRDBF    FILE(AGDPP11) TOFILE(HFILE1/A@DPP11)
             OVRDBF    FILE(AGDPL11) TOFILE(HFILE1/A@DPL11)
             OVRDBF    FILE(AGDPL12) TOFILE(HFILE1/A@DPL12)

 /*******************************************************************/
 /*  Check and Unlock Sign-on Information for Handy Terminal        */
             CALL       PGM(ALDRZ5)

 /*******************************************************************/
 /*  Run Conveyance Pull 3pt Scan                                   */
             CALL      PGM(ALCR01)

 /*******************************************************************/
 /*  Delete Sign-on Information for Handy Terminal                  */
             CALL       PGM(ALDRZ7)

             SIGNOFF

 ENDPGM
