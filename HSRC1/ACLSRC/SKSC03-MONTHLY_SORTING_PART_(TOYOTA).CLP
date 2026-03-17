PGM
   /** SKSC03 **********************************************************/
   /*  MONTHLY SORTING PART (TOYOTA)                                   */
   /*  J.WATANABE  2019.05.01                                          */
   /********************************************************************/
             DCL        VAR(&REC)   TYPE(*DEC) LEN(10 0) VALUE(0)
             DCL        VAR(&FNAM)  TYPE(*CHAR) LEN(30)

             CHGVAR     VAR(&FNAM) VALUE('MONTHLY SORTING PART +
                          (TOYOTA)')

             DLTF       FILE(QTEMP/SKSWP03)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/SKSWP03) RCDLEN(1024) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(SKSR03)

 /* TRANSFER.....*/
             RTVMBRD    FILE(QTEMP/SKSWP03) NBRCURRCD(&REC)
             IF         COND(&REC *NE 0) THEN(DO)
             CALL       PGM(APLC97) PARM('1' 'SKSWP03' 'QTEMP' +
                          &FNAM 'Y' ' ' 'Y')
             ENDDO

ENDPGM
