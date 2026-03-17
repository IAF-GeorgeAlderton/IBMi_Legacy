  PGM
/** AB#CBL ********************************************/
/*  GENERATE AB#EP40 FOR AUTOKINITON(5444)            */
/*  ADD JOB TO VJBC71  (JOB SCHEDULE  05:45 AM)       */
/*  J.WATANABE      2021.12.21                        */
/*-----------------------------------------------     */
/*  JW       2025.03.27 ADD AB#R12T (UNIVERSAL EDI)   */
/******************************************************/

             DCL        VAR(&RCD) TYPE(*DEC) LEN(10 0)

             CLRPFM     FILE(TFILE2/AB#EP40)
             OVRDBF     FILE(AB#EP40) TOFILE(TFILE2/AB#EP40)

       /*****CALL       PGM(AB#RBL2) *****/
             CALL       PGM(AB#RBL3)

             DLTOVR     FILE(*ALL)

             RTVMBRD    FILE(TFILE2/AB#EP40) NBRCURRCD(&RCD)

             IF         COND(&RCD *NE 0) THEN(DO)
             CPYF       FROMFILE(TFILE2/AB#EP40) +
                          TOFILE(HFILE1/AB#EP40) MBROPT(*ADD) +
                          FMTOPT(*MAP *DROP)

       /**  UNIVERSAL EDI            **/
       /**   CALL PGM(AB#C12T)       **/

             ENDDO

             ENDPGM
