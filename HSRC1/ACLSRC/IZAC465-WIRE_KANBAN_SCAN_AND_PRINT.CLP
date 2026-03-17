             PGM        PARM(&SERL)
             /** IZAC465 ***************************************/
             /*  WIRE KANBAN SCAN AND PRINT                    */
             /*    LEC                      2025.07.28         */
             /**************************************************/

             DCL        VAR(&SERL) TYPE(*CHAR) LEN(15)


             OVRPRTF    FILE(IZAPR01) DRAWER(1) OUTQ(SAVEOUTQ)
             OVRPRTF    FILE(IZAPR02A) DRAWER(2) OUTQ(SAVEOUTQ)
             OVRPRTF    FILE(IZAPR02C) DRAWER(2) OUTQ(SAVEOUTQ)

             CALL       PGM(IZAR465) PARM((&SERL))

             ENDPGM
