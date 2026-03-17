             PGM
             /** FCEC66 ***************************************/
             /*  SERVICE PART FORECAST LIST                   */
             /*  J.WATANABE   2019.01.16                      */
             /*************************************************/

             CLRPFM     FILE(*LIBL/ABAWP11)
             MONMSG     MSGID(CPF0000)

             CLRPFM     FILE(*LIBL/FCEWP66)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(FCER66)

             CALL       PGM(FCER67)

             CALL       PGM(FCER68)

             ENDPGM
