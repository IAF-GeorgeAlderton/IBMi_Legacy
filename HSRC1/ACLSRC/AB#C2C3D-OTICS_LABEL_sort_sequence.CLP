             PGM
             /** AB#C2C3D *********************************************/
             /*  OTICS LABEL  --- sort sequence                       */
             /*  JW     2023.01.13                                    */
             /*********************************************************/
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBR)  TYPE(*CHAR) LEN(3)

/* ADD MEMBER */
             RTVJOBA    JOB(&WSID)
             CHGVAR     VAR(&MBR ) VALUE(%SUBSTRING(&WSID 1 3))

             ADDLFM     FILE(HFILE1/AB#WL2I) MBR(&MBR) +
                          DTAMBRS((HFILE1/AB#WP2I (&MBR)))
             MONMSG     MSGID(CPF7306)

/* REPLACE PALLET# */
             OVRDBF     FILE(AB#WL2I) TOFILE(HFILE1/AB#WL2I) MBR(&MBR)
             CALL       PGM(AB#R2C3D)

             ENDPGM
