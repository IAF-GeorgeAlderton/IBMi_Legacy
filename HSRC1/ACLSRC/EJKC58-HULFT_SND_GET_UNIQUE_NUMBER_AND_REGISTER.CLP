             PGM        PARM(&JYKB &DKBN &SFILE &SLIBL &SND)
             /** EJKC58 *****************************************/
             /* HULFT_SND  GET UNIQUE NUMBER AND REGISTER FILE  */
             /*    **ORIGINAL IS JK580C FROM ASJ**              */
             /*  T.SAKAKI            2016.10.20                 */
             /***************************************** EJKC58 **/
             DCL        VAR(&JYKB) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DKBN) TYPE(*CHAR) LEN(3)
             DCL        VAR(&SFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SLIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SND) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE)   TYPE(*CHAR) LEN(10)

             DCL        VAR(&CNT)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&MM)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&DD)   TYPE(*CHAR) LEN(1)

          /* &DKBN = EDI DATA CODE SUCH AS 830,850 */
       /*-------------------*/
       /* GET UNIQUE NUMBER */
       /*-------------------*/
             CALL       PGM(EJKR60) PARM('S' &DKBN &MM &DD &CNT)

          /* SET FILE NAME */
             CHGVAR     VAR(&FILE) VALUE('S' *CAT &DKBN *CAT &MM +
                          *CAT &DD *CAT &CNT)

          /* COPY RECEPTION FILE */
             CPYF       FROMFILE(&SLIBL/&SFILE) +
                          TOFILE(B2B_S/&FILE) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*NOCHK)

       /*-------------------------*/
       /* REGISTER RECEPTION FILE */
       /*-------------------------*/
             CALL       PGM(EJKR58) PARM(&SFILE &FILE &JYKB &DKBN &SND)
                                    /* &FILE PUT */

             ENDPGM
