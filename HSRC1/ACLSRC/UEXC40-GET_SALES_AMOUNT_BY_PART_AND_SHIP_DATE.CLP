             PGM        PARM(&TOKU &NONY &MHIN &FROM &TO &TQTY &TAMT)
             /** UEXC40  **********************************************/
             /*  GET SALES AMOUNT BY PART AND SHIP DATE               */
             /*  J.W      2021.01.22                                  */
             /*  CALLING SEQ. ----------------------------------------*/
             /*                    CALL 'UEXR40'                      */
             /*                    PARM           $TOKU   4           */
             /*                    PARM           $NONY   4           */
             /*                    PARM           $MHIN  20           */
             /*                    PARM           $FROM   6           */
             /*                    PARM           $TO     6           */
             /*                    PARM           $TQTY  10           */
             /*                    PARM           $TAMT  12           */
             /*  IN  $TOKU   4A  CUSTOMER CODE                        */
             /*      $NONY   4A  DELIVERY CODE                        */
             /*      $MHIN  20A  USER PART                            */
             /*      $FROM   6A  SALES FROM   (YYYYMM)                */
             /*      $TO     6A  SALES TO     (YYYYMM)                */
             /*  OUT $TQTY  10A  TATAL QTY    (10,0)                  */
             /*      $TAMT  12A  TOTAL AMOUNT (12,5)                  */
             /*-------------------------------------------------------*/

             DCL        VAR(&TOKU   ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NONY   ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MHIN   ) TYPE(*CHAR) LEN(20)
             DCL        VAR(&FROM   ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&TO     ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&TQTY   ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TAMT   ) TYPE(*CHAR) LEN(12)

   /** CREATE WF IN QTEMP */
             DLTF       FILE(QTEMP/UEXWP40)
             MONMSG     MSGID(CPF0000)

   /*        CRTDUPOBJ  OBJ(UEXWP40) FROMLIB(HWFILE1) OBJTYPE(*FILE) +  */
   /*                     TOLIB(QTEMP)                                  */
   /*        MONMSG     MSGID(CPF0000)                                  */
   /*        CLRPFM     FILE(QTEMP/UEXWP40)                             */
   /*        OVRDBF     FILE(AUEXWP40) TOFILE(QTEMP/UEXWP40)            */

             CLRPFM     FILE(HWFILE1/UEXWP40)

             CALL       PGM(UEXR40) PARM(&TOKU &NONY &MHIN &FROM &TO +
                          &TQTY &TAMT)

             ENDPGM
