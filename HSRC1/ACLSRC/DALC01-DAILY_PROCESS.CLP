             PGM
             /** DALC01 *************************************/
             /* PROGRAM NAME. : DAILY PROCESS             */
             /* AUTHOR.       : T.SAKAKI   2020.01.07       */
             /***********************************************/

      /* KANBAN M/F INFO */
             CALL       PGM(HOBJ1/ABNC01)

      /* PLATING KANBAN A-PICS REFLECT  */
             CALL       PGM(HOBJ1/AAFC10)

      /* WITHDRAWAL KANBAN A-PICS REFLECT  */
             CALL       PGM(HOBJ1/AAHC10)

  @END:      ENDPGM
