             PGM
   /** AYBC02 ************************************/
   /* ZMOD MENU                                  */
   /*       CREATE DATE : 2015.08.19             */
   /*       AUTHOR      : T.SAKAKI               */
   /** AYBC02 ************************************/

            ADDLIBLE   LIB(ZMODLIB10) POSITION(*LAST)
            MONMSG     MSGID(CPF0000)

            GO NUBRIDGES

            RMVLIBLE   LIB(ZMODLIB10)
            MONMSG     MSGID(CPF0000)

    @END:
             ENDPGM
