             PGM        PARM(&WKSID)

   /** RDBC2C **************************************************/
   /*  Send label workfiles created by AB#C2C to SQL01.        */
   /*    LEC   Created 2022/07/11                              */
   /*                                                          */


             DCL        VAR(&WKSID) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MBR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTTM) TYPE(*CHAR) LEN(20)
             DCL        VAR(&REC) TYPE(*DEC) LEN(10 0)

             RTVSYSVAL  SYSVAL(QDATETIME) RTNVAR(&DTTM)
             CHGVAR     VAR(&MBR) VALUE(&WKSID)

             ADDLIBLE   LIB(RDB50)
             MONMSG     MSGID(CPF0000)

   /* *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  */
   /*  send workfile for subaru skid manifest AB#WP43 to SQL01 */
             RTVMBRD    FILE(AB#WP43) MBR(&MBR) NBRCURRCD(&REC)

             IF         (&REC *GT 0) THEN(DO)
             CALL       PGM(RDBC25) PARM(&MBR &DTTM)
                                     ENDDO

   /* *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  */
   /*  send workfile for AIAG label data (AB#WP2I) to SQL01    */
             RTVMBRD    FILE(AB#WP2I) MBR(&MBR) NBRCURRCD(&REC)

             IF         (&REC *GT 0) THEN(DO)
             CALL       PGM(RDBC24) PARM(&MBR &DTTM)
                                     ENDDO

   /* *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  */
   /*  send workfile for Master label data (AB#WP2L) to SQL01  */
             RTVMBRD    FILE(AB#WP2L) MBR(&MBR) NBRCURRCD(&REC)

             IF         (&REC *GT 0) THEN(DO)
             CALL       PGM(RDBC26) PARM(&MBR &DTTM)
                                     ENDDO

   /* *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  */
   /*  send workfile for label data (AB#WP2F) to SQL01         */
             RTVMBRD    FILE(AB#WP2F) MBR(&MBR) NBRCURRCD(&REC)

             IF         (&REC *GT 0) THEN(DO)
             CALL       PGM(RDBC2F) PARM(&MBR &DTTM)
                                     ENDDO

   /* *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  */
   /*  send workfile for master data (AB#WP2O) to SQL01        */
             RTVMBRD    FILE(AB#WP2O) MBR(&MBR) NBRCURRCD(&REC)

             IF         (&REC *GT 0) THEN(DO)
             CALL       PGM(RDBC2O) PARM(&MBR &DTTM)
                                     ENDDO

   /* *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  */
   /*  send workfile for master data (AB#WP2E) to SQL01        */
             RTVMBRD    FILE(AB#WP2E) MBR(&MBR) NBRCURRCD(&REC)

             IF         (&REC *GT 0) THEN(DO)
             CALL       PGM(RDBC2E) PARM(&MBR &DTTM)
                                     ENDDO

   /* *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  */
   /*  send workfile for label data (AB#WP2G) to SQL01         */
             RTVMBRD    FILE(AB#WP2G) MBR(&MBR) NBRCURRCD(&REC)

             IF         (&REC *GT 0) THEN(DO)
             CALL       PGM(RDBC2G) PARM(&MBR &DTTM)
                                     ENDDO

   /* *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  */
   /*  send workfile for label data (AB#WP2N) to SQL01         */
             RTVMBRD    FILE(AB#WP2N) MBR(&MBR) NBRCURRCD(&REC)

             IF         (&REC *GT 0) THEN(DO)
             CALL       PGM(RDBC2N) PARM(&MBR &DTTM)
                                     ENDDO

   /* *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  *  */
             RMVLIBLE   LIB(RDB50)
             MONMSG     MSGID(CPF0000)


             ENDPGM
