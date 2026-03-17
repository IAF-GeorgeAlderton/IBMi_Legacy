             PGM        PARM(&FILE &ERRCD)
             /** AIACCC ***********************************/
             /* PGM FOR TRANSMISSION DATA             */
             /* M/F DATA PRODUCTION INSTRUCTION DATA  */
             /*                 DATA CHECK */
             /* I-HASADA                     86.10.17     */
             /*********************************** AIACCC **/
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ERRCD) TYPE(*CHAR) LEN(1)
             CHGVAR     VAR(&ERRCD) VALUE(' ')

             CHKOBJ     OBJ(&FILE) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801 CPF0001) EXEC(DO)
             CHGVAR     VAR(&ERRCD) VALUE('1')
             ENDDO

             ENDPGM
