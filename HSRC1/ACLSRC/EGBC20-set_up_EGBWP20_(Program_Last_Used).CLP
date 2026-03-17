             PGM
             /** EGBC20 ************************************/
             /*  SET UP EGBWP10 (USER/PROGRAM/TIMES)       */
             /*  JW     2019.12.20                         */
             /**********************************************/

             DSPOBJD    OBJ(HOBJ1/*ALL) OBJTYPE(*PGM) DETAIL(*FULL) +
                          OUTPUT(*OUTFILE) OUTFILE(WATALIB/OBJDF)

             CLRPFM     FILE(HFILE1/VVVPP40)
             CPYF       FROMFILE(WATALIB/OBJDF) +
                          TOFILE(HFILE1/VVVPP40) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)

             CALL       PGM(EGBR20)


 ENDP:       ENDPGM
