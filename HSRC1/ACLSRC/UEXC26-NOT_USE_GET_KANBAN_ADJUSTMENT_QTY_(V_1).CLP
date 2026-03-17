             /** UEXC26 ***********************************************/
             /*  GET KANBAN ADJUSTMENT QTY                            */
             /*  JW  2020.04.24                                       */
             /*-------------------------------------------------------*/
             PGM        PARM(&ZAIS &ZAIK &ADJ)

             DCL        VAR(&ZAIS  ) TYPE(*CHAR) LEN(15)
             DCL        VAR(&ZAIK  ) TYPE(*DEC ) LEN(5 2)
             DCL        VAR(&ADJ   ) TYPE(*DEC ) LEN(3 0)

             CLRPFM     FILE(*LIBL/UEXWP26A)
             CLRPFM     FILE(*LIBL/UEXWP26B)

             CALL       PGM(UEXR26) PARM(&ZAIS &ZAIK &ADJ)

             ENDPGM
