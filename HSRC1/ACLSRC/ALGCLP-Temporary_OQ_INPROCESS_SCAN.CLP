/** ALGCLP ************************************************/
/*  TEMPORRARY OQ INPROCESS SCAN                          */
/**********************************************************/
             PGM

             DCL        VAR(&YORN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)


/* get user id                                                  */
             RTVJOBA    USER(&USER)

/* call pgm to determine if oq line has a laser printer or not  */
             CALL       PGM(ALGRLP) PARM(&YORN)

/* if not, then call original oq inproc pgm                     */
             IF         COND(&YORN = 'N') THEN(CALL PGM(ALGC01))

/* if it does, then call new oq inproc pgm                      */
             IF         COND(&YORN = 'Y') THEN(CALL PGM(ALGC02))

             IF         COND(&USER = 'OQ' *OR &USER = 'OQTEST') +
                          THEN(SIGNOFF)

 ENDPGM:     ENDPGM
