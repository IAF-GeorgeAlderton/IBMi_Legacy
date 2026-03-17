             PGM        PARM(&EFULIB &EFUFIL)
             /** OBAC70 **********************************/
             /*SENDING INSTRUCTION TAG OUTGOING DATA(TV INPUT ) */
             /*         BETWEEN AS400, S88             */
             /* C:N.HAYAKAWA              94.12.23       */
             /********************************************/
             DCL        VAR(&WATFUN) TYPE(*DEC) LEN(2) VALUE(0)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SW01) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&EFUFIL) TYPE(*CHAR) LEN(9)
             DCL        VAR(&EFULIB) TYPE(*CHAR) LEN(9)
             DCL        VAR(&WT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FIL70) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL71) TYPE(*CHAR) LEN(9)
             DCL        VAR(&FIL72) TYPE(*CHAR) LEN(9)
             RTVJOBA    JOB(&WSID)
             CHGVAR     VAR(&WT) VALUE(%SST(&WSID 1 2))
             CHGVAR     VAR(&FIL70) VALUE('OBAWP70' *CAT &WT)
             CHGVAR     VAR(&FIL71) VALUE('OBAWP71' *CAT &WT)
             CHGVAR     VAR(&FIL72) VALUE('OBAWP72' *CAT &WT)
             /* WORK FILE DELETE */
             DLTF HWFILE/&FIL70
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF HWFILE/&FIL71
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF HWFILE/&FIL72
             MONMSG     MSGID(CPF3261 CPF2105)
             /* WORK FILE CREATE  */
             CRTPF      FILE(HWFILE/&FIL70) RCDLEN(100) +
                          TEXT('INSTRUCTION TAG DATA EBC100') +
                          OPTION(*NOLIST) SIZE(200 20) +
                          LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(&FIL70) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

             CRTPF      FILE(HWFILE/&FIL71) RCDLEN(100) +
                          TEXT('INSTRUCTION TAG DATA ASC100') +
                          OPTION(*NOLIST) SIZE(200 20) +
                          LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(&FIL71) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

             CRTPF      FILE(HWFILE/&FIL72) RCDLEN(508) +
                          TEXT('INSTRUCTION TAG DATA ASC508') +
                          OPTION(*NOLIST) SIZE(200 20) +
                          LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(&FIL72) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

             /* CREATE INSTRUCTION TAG PUBLICATION DATA FOR SENDING */
             OVRDBF     FILE(EAEWP04) TOFILE(&EFULIB/&EFUFIL)
             OVRDBF     FILE(OBAWP70) TOFILE(HWFILE/&FIL70)
             CALL       PGM(OBAR70) PARM(&SW01)
             DLTOVR     FILE(OBAWP70)
             DLTOVR     FILE(EAEWP04)
             /* EXIT WHEN RECORD IS 0 */
             IF         COND(&SW01 *NE '*') THEN(GOTO CMDLBL(NOREC))
             /**************************************************/
             /* CHECK AND MAKING  OF DATA AREA FOR  RUNNING COMMUNICATION PGM */
             /**************************************************/
 LOOP1:   /* CHKOBJ OBJ(OALIB/S88TRNACT) OBJTYPE(*DTAARA)            */
          /* MONMSG MSGID(CPF9801) EXEC(GOTO CMDLBL(NONACT)) */
             /*  WAITE FOR 1 MINUTE IF IT IS RUNNING */
          /* DLYJOB DLY(60)                                          */
             /* IF IT IS NO GOOD FOR 10 MINUTES , SEND  A MESSAGE . */
          /* IF         COND(&WATFUN >= 20) THEN(SNDPGMMSG +         */
          /*             MSG('エフ出庫データのＳ８８に対する通信が+*/
          /*             ２０分待ったが解除されない。情報課に連絡+ */
          /*              せよ。') TOMSGQ(&WSID) MSGTYPE(*INFO))   */
          /* CHGVAR VAR(&WATFUN) VALUE(&WATFUN + 1)                  */
          /* GOTO LOOP1                                              */
 NONACT:  /* CRTDTAARA DTAARA(HFILE/S88TRNACT) TYPE(*CHAR) LEN(1) + */
          /*              TEXT('ARRS COMMUNICATION WHICH IS EXECUTED')     */

             /* IT IS CONVERTED INTO ASCII FROM EBCDIC */
             OVRDBF     FILE(OBAWP70) TOFILE(HWFILE/&FIL70)
             OVRDBF     FILE(OBAWP71) TOFILE(HWFILE/&FIL71)
             CALL       PGM(OBAR71)
             DLTOVR     FILE(OBAWP70)
             DLTOVR     FILE(OBAWP71)
             /* DATA BLOCKING */
             OVRDBF     FILE(OBAWP71) TOFILE(HWFILE/&FIL71)
             OVRDBF     FILE(OBAWP72) TOFILE(HWFILE/&FIL72)
             CALL       PGM(OBAR72)
             DLTOVR     FILE(OBAWP71)
             DLTOVR     FILE(OBAWP72)
             /* SEND  INSTRUCTION TAG DATA AS400 => S88 */
         /* OVRDBF FILE(S88WP01) TOFILE(WORKLIB/&FIL72) */
         /* CALL PGM(S88R01)                                     */
         /* DLTOVR FILE(S88WP01)                                 */
             /* DATA AREA DELETE  */
         /* DLTDTAARA DTAARA(OALIB/S88TRNACT)                    */
             /* TAG DUMP LIST CREATE*/
         /* OVRPRTF FILE(OBAPR73) LPI(6) OVRFLW(60) +            */
         /*               RPLUNPRT(*YES) OUTQ(HAYAKAWA/SIJIF) + */
         /*               FORMTYPE(K6H1) HOLD(*YES)              */
         /* OVRDBF FILE(OBAWP70) TOFILE(HWFILE/&FIL70) */
         /* CALL PGM(OBAR73) PARM(A2033)                         */
         /* DLTOVR FILE(OBAPR73)                                 */
         /* DLTOVR FILE(OBAWP70)                                 */
             /* WORK FILE DELETE */
  NOREC: /*DLTF HWFILE/&FIL70 */
           /*DLTF HWFILE/&FIL71 */
           /*DLTF HWFILE/&FIL72 */

             ENDPGM
