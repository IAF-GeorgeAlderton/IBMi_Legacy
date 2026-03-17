             PGM
             /** AJPC02 ****************************************/
             /*   CLEAR SPOOL OUTQ                             */
             /*            JUL/22/04                           */
             /*   JW1   2018.02.27 CHG CLRSPLOUTQ TO CLROUTQ2  */
             /**************************************** AJPC02 **/
             DCL        VAR(&DAY)   TYPE(*DEC) LEN(3 0)
             DCL        VAR(&DAT)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&OUTQ)  TYPE(*CHAR) LEN(10)

             ADDLIBLE   LIB(G3X1CUSOBJ)
             MONMSG     MSGID(CPF0000)
             CHGJOB     OUTQ(EDIOUTQ)

      /* CLEAR SAVEOUTQ */
             CHGVAR     VAR(&DAY)    VALUE(60)
             CALL       PGM(AJPR02)  PARM(&DAY &DAT)
             CHGVAR     VAR(&OUTQ)   VALUE(SAVEOUTQ)
      /*JW1**CALL       PGM(CLRSPLOUTQ) PARM(&OUTQ &DAT)***/
             CALL       PGM(CLROUTQ2) PARM(&OUTQ &DAT)

      /* CLEAR EDIOUTQ */
             CHGVAR     VAR(&DAY)    VALUE(2)
             CALL       PGM(AJPR02)  PARM(&DAY &DAT)
             CHGVAR     VAR(&OUTQ)   VALUE(EDIOUTQ)
      /*JW1**CALL       PGM(CLRSPLOUTQ) PARM(&OUTQ &DAT)***/
             CALL       PGM(CLROUTQ2) PARM(&OUTQ &DAT)

      /* CLEAR GENRPORT  */
         /*  CHGVAR     VAR(&DAY)    VALUE(14)         */
         /*  CALL       PGM(AJPR02)  PARM(&DAY &DAT)   */
         /*  CHGVAR     VAR(&OUTQ)   VALUE(GENRPORT)   */
         /*  CALL       PGM(CLROUTQ2) PARM(&OUTQ &DAT) */

      /* CLEAR FORECAST  */
             CHGVAR     VAR(&DAY)   VALUE(60)
             CALL       PGM(AJPR02) PARM(&DAY &DAT)
             CHGVAR     VAR(&OUTQ)  VALUE(FORECAST)
      /*JW1**CALL       PGM(CLRSPLOUTQ) PARM(&OUTQ &DAT)***/
             CALL       PGM(CLROUTQ2) PARM(&OUTQ &DAT)

      /* CLEAR QPRINT    */
             CHGVAR     VAR(&DAY)   VALUE(90)
             CALL       PGM(AJPR02) PARM(&DAY &DAT)
             CHGVAR     VAR(&OUTQ)  VALUE(QPRINT  )
             CALL       PGM(CLROUTQ2) PARM(&OUTQ &DAT)

      /* CLEAR QPRINTS   */
             CHGVAR     VAR(&DAY)   VALUE(90)
             CALL       PGM(AJPR02) PARM(&DAY &DAT)
             CHGVAR     VAR(&OUTQ)  VALUE(QPRINTS )
             CALL       PGM(CLROUTQ2) PARM(&OUTQ &DAT)

      /* CLEAR LANPRT21  */
         /*  CHGVAR     VAR(&DAY)   VALUE(365)        */
         /*  CALL       PGM(AJPR02) PARM(&DAY &DAT)   */
         /*  CHGVAR     VAR(&OUTQ)  VALUE(LANPRT21)   */
         /*  CALL       PGM(CLROUTQ2) PARM(&OUTQ &DAT) */

      /* CLEAR LANPRT22  */
         /*  CHGVAR     VAR(&DAY)   VALUE(365)        */
         /*  CALL       PGM(AJPR02) PARM(&DAY &DAT)   */
         /*  CHGVAR     VAR(&OUTQ)  VALUE(LANPRT22)   */
         /*  CALL       PGM(CLROUTQ2) PARM(&OUTQ &DAT) */

      /* CLEAR LANPRT23  */
         /*  CHGVAR     VAR(&DAY)   VALUE(365)        */
         /*  CALL       PGM(AJPR02) PARM(&DAY &DAT)   */
         /*  CHGVAR     VAR(&OUTQ)  VALUE(LANPRT23)   */
         /*  CALL       PGM(CLROUTQ2) PARM(&OUTQ &DAT) */

      /* CLEAR LANPRT24  */
         /*  CHGVAR     VAR(&DAY)   VALUE(365)        */
         /*  CALL       PGM(AJPR02) PARM(&DAY &DAT)   */
         /*  CHGVAR     VAR(&OUTQ)  VALUE(LANPRT24)   */
         /*  CALL       PGM(CLROUTQ2) PARM(&OUTQ &DAT) */

      /* CLEAR LANPRT25  */
         /*  CHGVAR     VAR(&DAY)   VALUE(365)        */
         /*  CALL       PGM(AJPR02) PARM(&DAY &DAT)   */
         /*  CHGVAR     VAR(&OUTQ)  VALUE(LANPRT25)   */
         /*  CALL       PGM(CLROUTQ2) PARM(&OUTQ &DAT) */

      /* CLEAR LANPRT26  */
         /*  CHGVAR     VAR(&DAY)   VALUE(365)        */
         /*  CALL       PGM(AJPR02) PARM(&DAY &DAT)   */
         /*  CHGVAR     VAR(&OUTQ)  VALUE(LANPRT26)   */
         /*  CALL       PGM(CLROUTQ2) PARM(&OUTQ &DAT) */

      /* CLEAR LANPRT27  */
         /*  CHGVAR     VAR(&DAY)   VALUE(365)        */
         /*  CALL       PGM(AJPR02) PARM(&DAY &DAT)   */
         /*  CHGVAR     VAR(&OUTQ)  VALUE(LANPRT27)   */
         /*  CALL       PGM(CLROUTQ2) PARM(&OUTQ &DAT) */

      /* CLEAR LANPRT28  */
         /*  CHGVAR     VAR(&DAY)   VALUE(365)        */
         /*  CALL       PGM(AJPR02) PARM(&DAY &DAT)   */
         /*  CHGVAR     VAR(&OUTQ)  VALUE(LANPRT28)   */
         /*  CALL       PGM(CLROUTQ2) PARM(&OUTQ &DAT) */

      /* CLEAR LANPRT29  */
         /*  CHGVAR     VAR(&DAY)   VALUE(365)        */
         /*  CALL       PGM(AJPR02) PARM(&DAY &DAT)   */
         /*  CHGVAR     VAR(&OUTQ)  VALUE(LANPRT29)   */
         /*  CALL       PGM(CLROUTQ2) PARM(&OUTQ &DAT) */

             ENDPGM
