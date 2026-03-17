             PGM        PARM(&PFILE)
             /** MYBC12 ***********************************/
             /* 仕掛けﾜｮn及び出現率ﾌﾟjｰ]表WORKmﾞｰj  */
             /*  CLRPFM                                   */
             /*     I-HASADA               2013/02/27     */
             /*  I-HASADA 2013/04/04                      */
             /*   COPY RPG(IAFAYM):TG032C                 */
             /*********************************** MYBC12 **/
             DCL        VAR(&PFILE) TYPE(*CHAR) LEN(10)

             CLRPFM     FILE(&PFILE)

             ENDPGM
