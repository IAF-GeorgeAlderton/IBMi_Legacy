             PGM        PARM(&RTN)
             /** CHKC46 ****************************************/
             /*  CHECK SYSTEM AVAILABEL FLAG                   */
             /*  J.WATANABE 2018.08.24                         */
             /*  PARAMETRES                                    */
             /*   OUT $RTN  :  Y=SYSTEM IS AVAILABLE           */
             /*                N=SYSTEM IS NOT AVAILABLE       */
             /**************************************************/
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(1)

             OVRDBF     FILE(AB#PPCK) TOFILE(HFILE1/AB#PPCK)

             CALL       PGM(HOBJ1/CHKR46) PARM(&RTN)

             ENDPGM
