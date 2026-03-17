             PGM        PARM(&DKBN &FILE)
             /** EJKC56 ***********************************/
             /* HULFT_SND  GET UNIQUE NUMBER              */
             /*    **ORIGINAL IS JK580C FROM ASJ**        */
             /*  T.SAKAKI            2016.10.20           */
             /*********************************** EJKC58 **/
             DCL        VAR(&DKBN) TYPE(*CHAR) LEN(3)

             DCL        VAR(&CNT)   TYPE(*CHAR) LEN(4)
             DCL        VAR(&MM)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&DD)   TYPE(*CHAR) LEN(1)
             DCL        VAR(&FILE)   TYPE(*CHAR) LEN(10)

       /*-------------------*/
       /* GET UNIQUE NUMBER */
       /*-------------------*/
             CALL       PGM(EJKR60) PARM('S' &DKBN &MM &DD &CNT)

          /* SET FILE NAME */
             CHGVAR     VAR(&FILE) VALUE('S' *CAT &DKBN *CAT &MM +
                          *CAT &DD *CAT &CNT)

             ENDPGM
