             PGM        PARM(&WORKER &WKNM)
             /** AM#C18 ********************************/
             /* PACKING - ORIG PAPERWORK SUPPLEMENTALS */
             /*   LEC.             2020.06.18          */
             /*   LEC.  TAKE OUT WORKER CODE VALIDATION*/
             /******************************************/

             DCL        VAR(&WORKER) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WKNM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&VALID) TYPE(*CHAR) LEN(1)

             CHGVAR     VAR(&VALID) VALUE('Y')


  /*   GET WORKER CODE                                      */
  /********* CALL       PGM(AM#R10) PARM(&WORKER &WKNM &VALID)  *******/

             CHGVAR     VAR(&VALID) VALUE('Y')

             IF         COND(&VALID = 'Y') THEN(DO)
  /*  run scan program for original paperwork supplemental orders  */
             CALL       PGM(AM#R18) PARM(&WORKER &WKNM)
                        ENDDO

 #END:       ENDPGM
