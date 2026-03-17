             PGM
             /** GCQC20 **************************************/
             /* DOWNLOAD DIE USAGE RESULT/KANBAN INF         */
             /*                                              */
             /************************************** GCQC20 **/
             DCL        VAR(&CNT)    TYPE(*CHAR) LEN(1)

             CLRPFM     FILE(HWFILE1/GCQWP20)

             CHGVAR     VAR(&CNT) VALUE('6')
             CALL       PGM(GCQR20) PARM(&CNT)

             ENDPGM
