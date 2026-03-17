             PGM
             /** AB#CF8 **************************************/
             /*  FORD EDI FILE DELETE & REORGANIZE           */
             /*  N-HYOTO  2000.06.21                         */
             /*                                              */
             /*  DELET FILE: ABF1L02(ABF1P01_SV)             */
             /*            : ABF4P01                         */
             /*            : ABF6P01                         */
             /*            : ABFPP10                         */
             /*            : ABFPP20                         */
             /************************************** AB#CF8 **/

             CALL       PGM(AB#RFG)

/* FORD 862(RELEASE) DATA */
     /*      RGZPFM     FILE(TFILE1/ABF1P01_SV)   */
             RGZPFM     FILE(TFILE1/ABF2P01)
      /*     RGZPFM     FILE(ABF1P01_SV)         */
             MONMSG     MSGID(CPF0000)

/* FORD MANIFEST NUMBER   */
             RGZPFM     FILE(TFILE1/ABF4P01)
      /*     RGZPFM     FILE(ABF4P01)            */
             MONMSG     MSGID(CPF0000)

/* FORD LABEL & ASN DATA  */
             RGZPFM     FILE(TFILE1/ABF6P01)
      /*     RGZPFM     FILE(ABF6P01)            */
             MONMSG     MSGID(CPF0000)

/* FORD 830(FORECAST) DATA */
             RGZPFM     FILE(TFILE1/ABFPP10)
      /*     RGZPFM     FILE(ABFPP10)            */
             MONMSG     MSGID(CPF0000)

/* FORD 830(FORECAST:NOTE) DATA */
             RGZPFM     FILE(TFILE1/ABFPP20)
      /*     RGZPFM     FILE(ABFPP20)            */
             MONMSG     MSGID(CPF0000)

 END:
             ENDPGM
