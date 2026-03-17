   PGM
/** GDMC320 ***********************************************/
/*  ASJ WASHER ORDER KANBAN ISSUE                         */
/*                                                        */
/* TCHK1 11/19/10 CREATE                                  */
/**********************************************************/
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)

             RTVJOBA    USER(&USER)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)
   @START:
             OVRDBF     FILE(GDMPW320) TOFILE(TOBJ1/GDMPW320)
             OVRDBF     FILE(GDMPL71) TOFILE(TFILE1/GDMPL71)
             OVRDBF     FILE(GDMPL72) TOFILE(TFILE1/GDMPL72)
             OVRDBF     FILE(AB#PPCT) TOFILE(HFILE1/AB#PPCT)
             OVRDBF     FILE(GDMPL10) TOFILE(HFILE1/GDMPL10)
             OVRDBF     FILE(GDMPL20) TOFILE(HFILE1/GDMPL20)
             OVRDBF     FILE(GDMPL30) TOFILE(HFILE1/GDMPL30)
             OVRDBF     FILE(GDMPL50) TOFILE(TFILE1/GDMPL50)
             OVRDBF     FILE(GDMPL60) TOFILE(TFILE1/GDMPL60)
             OVRDBF     FILE(GDMPP80) TOFILE(TFILE1/GDMPP80)
             OVRDBF     FILE(AKBPL07) TOFILE(HFILE1/AKBPL07)
             OVRDBF     FILE(GDMPP60) TOFILE(TFILE1/GDMPP60)
             OVRDBF     FILE(GDMWP60) TOFILE(TWFILE1/GDMWP60)

             OVRPRTF    FILE(QPRINT) PAGESIZE(66 80) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(QDKT) FORMTYPE(K6S1)

             CALL       PGM(TOBJ1/GDMR320)

   @END:
             ENDPGM
