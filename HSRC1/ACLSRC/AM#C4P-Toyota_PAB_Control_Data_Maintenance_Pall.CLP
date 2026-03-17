             PGM
             /** AM#C4P ************************/
             /* TOYOTA PAB CONTROL DATA MAINT. */
             /*   LEC.             2020.03.25  */
             /**********************************/

             DCL        VAR(&ID) TYPE(*CHAR) LEN(3) VALUE('PR')

             CALL       PGM(AM#R46) PARM(&ID)

             ENDPGM
