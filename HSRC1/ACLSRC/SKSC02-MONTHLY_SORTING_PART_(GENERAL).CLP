PGM
   /** SKSC02 **********************************************************/
   /*  MONTHLY SORTING PART (GENERAL)                                  */
   /*  J.WATANABE  2019.04.24                                          */
   /********************************************************************/
             DCL        VAR(&REC)   TYPE(*DEC) LEN(10 0) VALUE(0)
             DCL        VAR(&FNAM)  TYPE(*CHAR) LEN(30)

             CHGVAR     VAR(&FNAM) VALUE('MONTHLY SORTING PART +
                          (GENERAL)')

             DLTF       FILE(QTEMP/SKSWP01)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(QTEMP/SKSWP01) RCDLEN(200) +
                          OPTION(*NOLIST) LVLCHK(*NO) AUT(*ALL)

             CALL       PGM(SKSR01)

 /* TRANSFER.....*/
             RTVMBRD    FILE(QTEMP/SKSWP01) NBRCURRCD(&REC)
             IF         COND(&REC *NE 0) THEN(DO)
             CALL       PGM(APLC97) PARM('1' 'SKSWP01' 'QTEMP' +
                          &FNAM 'Y' ' ' 'Y')
             ENDDO

ENDPGM
