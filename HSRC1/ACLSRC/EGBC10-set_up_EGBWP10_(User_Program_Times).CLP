             PGM
             /** EGBC10 ************************************/
             /*  SET UP EGBWP10 (USER/PROGRAM/TIMES)       */
             /*  JW     2019.12.20                         */
             /**********************************************/
             DCL        VAR(&FROM) TYPE(*CHAR) LEN(8)
             DCL        VAR(&TO)   TYPE(*CHAR) LEN(8)

             CHGVAR     VAR(&FROM) VALUE('20220101')
             CHGVAR     VAR(&TO  ) VALUE('99999999')

             CLRPFM     FILE(*LIBL/EGBWP10)
             CLRPFM     FILE(*LIBL/EGBWP11)

/* CREATE VVVPP40 (DSPOBJD FILE))   */
             CALL       PGM(EGBC20)


/* CREATE EGBWP10 */
             CALL       PGM(EGBR10)

/* SET USE TIMES */
             CALL       PGM(EGBR12) PARM(&FROM &TO)

/* SUMMARIZE */
             CALL       PGM(EGBR14)

/* ADJUST    */
             CALL       PGM(EGBR16) PARM(&FROM &TO)

 ENDP:       ENDPGM
