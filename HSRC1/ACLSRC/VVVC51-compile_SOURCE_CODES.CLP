             PGM
             /** VVVC51 ************************************************/
             /*  COMPILE SOURCE CODES                                  */
             /*  JW   2026.02.11                                       */
             /**********************************************************/

             ADDLIBLE   LIB(G3X6DTA)
             MONMSG     MSGID(CPF0001 CPF2103)

             ADDLIBLE   LIB(G3X6PGM)
             MONMSG     MSGID(CPF0001 CPF2103)

             ADDLIBLE   LIB(BACKUP )
             MONMSG     MSGID(CPF0001 CPF2103)

/* SET VVVP51A */
    /**      DSPOBJD    OBJ(HOBJ1/*ALL) OBJTYPE(*ALL) +                 **/
    /**                   OUTPUT(*OUTFILE) OUTFILE(WATALIB/DSPOBJD)     **/
    /**                                                                 **/
    /**      CPYF       FROMFILE(WATALIB/DSPOBJD) +                     **/
    /**                   TOFILE(HFILE1/DSPOBJ1) MBROPT(*REPLACE) +     **/
    /**                   FMTOPT(*MAP *DROP)                            **/
    /**                                                                 **/
    /**      CLRPFM     FILE(HFILE1/VVVPP51A)                           **/
    /**                                                                 **/
             OVRDBF     FILE(VVVPP51)  TOFILE(HFILE1/VVVPP51)
             OVRDBF     FILE(DSPOBJ1)  TOFILE(HFILE1/DSPOBJ1)
             OVRDBF     FILE(VVVPP51A) TOFILE(HFILE1/VVVPP51A)
    /**                                                                 **/
    /**      CALL       PGM(VVVR51)                                     **/

/** COMPILE **/
             CALL       PGM(VVVR51C)

 ENDP:       ENDPGM
