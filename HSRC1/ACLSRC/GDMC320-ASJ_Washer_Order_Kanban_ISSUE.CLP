   PGM
/** GDMC320 ***********************************************/
/*  ASJ WASHER ORDER KANBAN ISSUE                         */
/*                                                        */
/* TCHK1 11/19/10 CREATE                                  */
/**********************************************************/
             DCL        VAR(&PLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)

             RTVJOBA    USER(&USER)
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)
   @START:
             CPYF       FROMFILE(&PLIB/GDMPP60)  +
                        TOFILE(&PLIB/GDMPP60A) +
                        MBROPT(*ADD)

             IF         COND(&USER *NE 'TEST') THEN(DO)
             OVRPRTF    FILE(QPRINT) PAGESIZE(66 80) LPI(6) +
                          RPLUNPRT(*YES) OUTQ(LANPRT09) +
                          FORMTYPE(K6S1) SAVE(*YES)
             ENDDO

             CLRPFM     FILE(&WLIB/GDMWP60)

             CALL       PGM(GDMR320)

   @END:
             ENDPGM
