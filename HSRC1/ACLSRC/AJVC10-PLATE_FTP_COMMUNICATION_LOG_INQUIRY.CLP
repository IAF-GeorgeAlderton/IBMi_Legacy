             PGM
             /*** AJVC10 ********************************************/
             /*  PROGRAM NAME.  : CREATE LIMITATION MASTER        */
             /*                   MORE THAN 3 TIMES RELOADING     */
             /*  PROGRAM ID.    : AJVC10       <CLP>                */
             /*  CREATE DATE.   : 2019/01/11                        */
             /*  AUTHOR.        : Y.MAEDA                           */
             /********************************************* AJVCL1 **/
             DCL        VAR(&PSTS)   TYPE(*CHAR) LEN(1)

        /*  GET CREATE SCHEDULE     */
        /*  &PSTS = '*'     CREATE  */
        /*  &PSTS = ' ' NOT CREATE  */
             CALL       PGM(AJVR11) PARM(&PSTS)
             IF         COND(&PSTS *EQ ' ') THEN(GOTO CMDLBL(@END))

             CLRPFM     FILE(HFILE1/AJVPP10)
             MONMSG     MSGID(CPF0000)
             CALL       PGM(AJVR10)

             DLTF       FILE(HWFILE1/AJVWP10)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/AJVWP10) RCDLEN(256) +
                          OPTION(*NOLIST) SIZE(50000 10000) +
                          LVLCHK(*NO) AUT(*ALL)
             CALL       PGM(AJVR12)

 @END:
             ENDPGM
