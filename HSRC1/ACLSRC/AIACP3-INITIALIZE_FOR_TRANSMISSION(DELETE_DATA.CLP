             PGM
             /** AIACP3 ************************************/
             /*  DELETE DATA AREA (AIAACT)            　 */
             /*  N.HYOTO 01/02/19                          */
             /************************************ AIACP3 **/

             CHKOBJ     OBJ(AIAACT) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(END))

             DLTDTAARA  DTAARA(AIAACT)


 END:        ENDPGM
