             PGM
             /** AM#C4S ************************/
             /* TOYOTA PAB CONTROL DATA MAINT. */
             /*   LEC.             2020.03.25  */
             /**********************************/

             DCL        VAR(&ID) TYPE(*CHAR) LEN(3) VALUE('SHP')

             CALL       PGM(AM#R46) PARM(&ID)

             ENDPGM
