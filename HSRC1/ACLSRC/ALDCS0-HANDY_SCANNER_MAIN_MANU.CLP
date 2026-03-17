             PGM
             /** ALDCS0 **************************************/
             /* HANDY SCANNER MAIN MANU                      */
             /*        KIRI            2014.02.19            */
             /************************************************/
             DCL        VAR(&WSID)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)     TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTG)     TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRNT)     TYPE(*CHAR) LEN(7)
             DCL        VAR(&DEVT)     TYPE(*CHAR) LEN(6)
             DCL        VAR(&IGCD)     TYPE(*CHAR) LEN(4)

             RTVJOBA    JOB(&WSID)     USER(&USER)
             CALL       PGM(AGAR01)    PARM(&WSID &DEVT &IGCD)
             CALL       PGM(AGAR00)    PARM(&WSID &PRNT &TYPE &PRTG)

         /*-----------------------------------------------*/
         /* LAST ACTIVE CHEAK                             */
         /*-----------------------------------------------*/
             CALL       PGM(ALDRZ5)




 @STEP00:
         /*-----------------------------------------------*/
         /* MAIN MENU                                     */
         /*-----------------------------------------------*/
             CALL       PGM(ALDRS0)


 @END:
             IF         COND((&USER *NE 'QPGMR') +
                        *AND (&USER *NE 'IAF'))  +
             THEN(DO)
                 SIGNOFF    LOG(*LIST)
             ENDDO

             ENDPGM
