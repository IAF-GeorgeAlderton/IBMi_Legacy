/** ABVC75 ************************************************/
/*  VW SHIP VERIFY (SCAN CASE LABEL)                      */
/*                                                        */
/* TCHK1 05/14/14 CREATE                                  */
/**********************************************************/
 PGM
             DCL        VAR(&US)    TYPE(*CHAR) LEN(10)
             RTVJOBA    USER(&US)

             OVRDBF    FILE(AGDPP11) TOFILE(HFILE1/A@DPP11)
             OVRDBF    FILE(AGDPL11) TOFILE(HFILE1/A@DPL11)
             OVRDBF    FILE(AGDPL12) TOFILE(HFILE1/A@DPL12)

             CALL      PGM(ABVR75)
             IF         COND(&US *NE 'VW') THEN(GOTO CMDLBL(END))
             SIGNOFF

 END:        ENDPGM
