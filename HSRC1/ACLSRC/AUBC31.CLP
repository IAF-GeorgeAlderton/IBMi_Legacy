             PGM
     /***************************************************************/
     /* PROGRAM NAME. : ORDERING DATA ADJUSTMENT M/F UPDATE   */
     /* PROGRAM ID. : AUBC31. <CLP>                                 */
     /* CREATE DATE. : MAR.16'86.                                   */
     /* AUTHOR.         : E.KAWASHIMA                               */
     /***************************************************************/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             RTVJOBA    USER(&USER)

             CALL       PGM(AUBR31) PARM(&USER)

             ENDPGM
