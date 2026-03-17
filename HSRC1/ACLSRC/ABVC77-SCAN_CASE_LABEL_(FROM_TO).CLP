/** ABVC77 ************************************************/
/*  SCAN CASE LABEL (FROM-TO)                             */
/*  JW   2020.12.08                                       */
/**********************************************************/
 PGM
             DCL        VAR(&USER)     TYPE(*CHAR) LEN(10)

             RTVJOBA    USER(&USER)

             IF         COND((&USER *NE 'I0777') *AND (&USER *NE +
                          'QPGMR') *AND (&USER *NE 'I0088')) THEN(DO)
             GOTO       CMDLBL(ENDP)
             ENDDO

             OVRDBF     FILE(AB#PL71) TOFILE(HFILE1/AB#PL71 )
             OVRDBF     FILE(ABVPP75) TOFILE(HFILE1/ABVPP75 )

             CALL      PGM(ABVR77)

 ENDP:       ENDPGM
