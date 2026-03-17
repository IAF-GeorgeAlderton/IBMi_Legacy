             PGM        PARM(&PONUM)

   /** EDIC70 ******************************************************/
   /* RETRIEVE PO# FROM GREAT PLAINS SERVER VIA RDB CONNECT        */
   /*     LEC           2016.12.07                                 */
   /****************************************************** EDIC70 **/

             DCL        VAR(&PONUM) TYPE(*CHAR) LEN(17)
             DCL        VAR(&LOCNID) TYPE(*CHAR) LEN(15) VALUE('MAIN')

   /****************************************************************/
   /*  CLEAR WORKFILES                                             */
             CLRPFM     FILE(RDBWP10)
             CLRPFM     FILE(RDBWP11)
             CLRPFM     FILE(RDBWP55)
             CLRPFM     FILE(RDBWP60)

   /****************************************************************/
   /*  ADD RDB CONNECT LIBRARY TO LIST                             */
             ADDLIBLE   LIB(RDB50)
             MONMSG     MSGID(CPF0000)

   /****************************************************************/
   /*  CALL PGM TO GET PO FROM GREAT PLAINS SERVER VIA RDB CONNECT */
             CALL       PGM(RDBR01) PARM(&PONUM &LOCNID)

   /****************************************************************/
   /*  CALL PGM TO REFORMAT PO WORKFILES INTO EXISTING EDI WF      */
             CALL       PGM(RDBR02) PARM(&PONUM &LOCNID)

   /****************************************************************/
   /*  RMV RDB CONNECT LIBRARY FROM LIST                           */
             RMVLIBLE   LIB(RDB50)
             MONMSG     MSGID(CPF0000)


             ENDPGM
