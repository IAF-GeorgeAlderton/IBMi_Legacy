             /** UEXC36C **********************************************/
             /*  EXSUB - CREATE AB#PP70 WORK FILE                     */
             /*-------------------------------------------------------*/
             PGM        PARM(&NONY &NKOJ &NUKE &NOHZ &NOBN &RTN)

             DCL        VAR(&NONY  ) TYPE(*CHAR) LEN(4 )
             DCL        VAR(&NKOJ  ) TYPE(*CHAR) LEN(1 )
             DCL        VAR(&NUKE  ) TYPE(*CHAR) LEN(4 )
             DCL        VAR(&NOHZ  ) TYPE(*CHAR) LEN(8 )
             DCL        VAR(&NOBN  ) TYPE(*CHAR) LEN(2 )
             DCL        VAR(&RTN   ) TYPE(*CHAR) LEN(1 )

             CLRPFM     FILE(AB#WP7A)

             CALL       PGM(UEXR36C) PARM(&NONY &NKOJ &NUKE &NOHZ +
                          &NOBN &RTN)

             ENDPGM
