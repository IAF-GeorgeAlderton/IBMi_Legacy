             PGM      PARM(&MCEDP01)
             /** MYBC03 ********************/
             /*  I-HASADA 2013/04/03       */
             /*   COPY RPG(IAFAYM):MCEC00  */
             /******************** MYBC03 **/

             DCL        VAR(&MCEDP01) TYPE(*CHAR) LEN(8)
             RTVDTAARA  DTAARA(MCEDP01) RTNVAR(&MCEDP01)

             ENDPGM
