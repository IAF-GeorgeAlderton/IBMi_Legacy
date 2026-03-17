             /** EJKC30 ********************************/
             /* JOB B2B_E   HANDLING ERROR PROCESS     */
             /*  T.SAKAKI            2016.10.24        */
             /************************ EJKC01 **********/
             DCL        VAR(&WSID)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&WNBR)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&OBJL)   TYPE(*CHAR) LEN(10)

             RTVJOBA    JOB(&WSID) USER(&USER) NBR(&WNBR)
             CHGJOB     RUNPTY(20)

        /*--------------------------------------------*/
        /*  CHANGE ENVIRONMENT IF TEST USER USES      */
        /*--------------------------------------------*/
             CALL       PGM(ALBC02) PARM(&USER &OBJL)


@STP1:       DLYJOB     DLY(30)

       /*------------------------*/
       /* AS/400 ERROR           */
       /*------------------------*/
         /* FOR RECEIVE   CHK EJKPP01  */
             CALL       PGM(EJKC19)

         /* FOR SEND   CHK EJKPP50  */
             CALL       PGM(EJKC59)

         /* FOR SEND   CHK EJKPP40  */
             CALL       PGM(EJKC49)

             GOTO       CMDLBL(@STP1)
@END:
             ENDPGM
