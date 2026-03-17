             PGM
             /** AJ#C41 ************************************/
             /*               CREATE DATE : 2015.05.14     */
             /*               ITS.                         */
             /**********************************************/
             DCL        VAR(&BAN1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&BAN2) TYPE(*CHAR) LEN(2)
             DCL        VAR(&BAN3) TYPE(*CHAR) LEN(2)
             DCL        VAR(&BAN4) TYPE(*CHAR) LEN(1)

             CALL       PGM(AJ#C43) PARM(&BAN1 &BAN2 &BAN3 &BAN4)

             ENDPGM
