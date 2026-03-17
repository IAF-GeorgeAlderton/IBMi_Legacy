             PGM        PARM(&JYKB &DKBN &SFILE &SLIBL &LEN &HOST &PTNR)
             /** EJKC18 ***********************************/
             /* HULFT_RCV  REGISTER RECEPTION FILE        */
             /*    **ORIGINAL IS JK180C FROM ASJ**        */
             /*  T.SAKAKI            2016.10.12           */
             /*********************************** EJKC18 **/
             DCL        VAR(&JYKB) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DKBN) TYPE(*CHAR) LEN(3)
             DCL        VAR(&PTNR) TYPE(*CHAR) LEN(12)
             DCL        VAR(&SFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SLIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&HOST) TYPE(*CHAR) LEN(10)

             DCL        VAR(&CNT)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&MM)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&DD)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&LEN) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0) VALUE(0)

    /* &DKBN = EDI DATA CODE SUCH AS 830,850 */
       /*-------------------*/
       /* GET UNIQUE NUMBER */
       /*-------------------*/
             CALL       PGM(EJKR60) PARM('R' &DKBN &MM &DD &CNT)

          /* SET FILE NAME */
             CHGVAR     VAR(&FILE) VALUE('R' *CAT &DKBN *CAT &MM +
                          *CAT &DD *CAT &CNT)

             DLTF       FILE(B2B_R/&FILE)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(B2B_R/&FILE) RCDLEN(&LEN) IGCDTA(*YES) +
                          SIZE(100000 10000)

          /* RECORD COUNT */
             CHGVAR     VAR(&REC) VALUE(0)
             RTVMBRD    FILE(&SLIBL/&SFILE) NBRCURRCD(&REC)

          /* COPY RECEPTION FILE */
             CPYF       FROMFILE(&SLIBL/&SFILE) TOFILE(B2B_R/&FILE) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)

       /*-------------------------*/
       /* REGISTER RECEPTION FILE */
       /*-------------------------*/
             CALL       PGM(EJKR18) PARM(&SFILE &FILE &JYKB &DKBN +
                          &HOST &PTNR &REC)

             ENDPGM
