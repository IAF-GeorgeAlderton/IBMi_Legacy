             PGM
             /** UEXC53A **********************************************/
             /*  (FORD) SET 997 RECEIVED DATE/TIME IN JCMPP11         */
             /*  JW     2024.08.06                                    */
             /*-------------------------------------------------------*/
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&TIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(8)

             OVRDBF     FILE(AB#PP6U) TOFILE(TFILE1/AB#PP6U)

             CHGVAR     VAR(&DATE) VALUE('20251027')
             CHGVAR     VAR(&TIME) VALUE('121721')
             OVRPRTF    FILE(QPRINT) OUTQ(QDKT)
             CALL       PGM(UEXR53A) PARM(&DATE &TIME &RTN)

             DLTOVR     FILE(*ALL)

             ENDPGM

