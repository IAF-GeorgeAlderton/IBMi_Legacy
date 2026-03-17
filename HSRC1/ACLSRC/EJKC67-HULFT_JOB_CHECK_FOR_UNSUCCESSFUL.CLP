             PGM        PARM(&JOB &FILE)
             /** EJKC67 *******************************************/
             /* HULFT JOB CHECK FOR UNSUCCESSFUL                  */
             /* THIS IS AUTOMATICALLY PROCESSED AFTER HULFT WORKS */
             /*    **ORIGINAL IS JN012C FROM ASJ**                */
             /*  T.SAKAKI                    2016.10.20           */
             /******************************************* EJKC67 **/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)

      /*IF HULFT JOB GET AN ERROR WHILE RECEIVING/SENDING FILE */

      /* WRITE ERROR LOG TO EJKPP55 */
             CALL       PGM(EJKR57) PARM(&JOB &FILE)

             ENDPGM
