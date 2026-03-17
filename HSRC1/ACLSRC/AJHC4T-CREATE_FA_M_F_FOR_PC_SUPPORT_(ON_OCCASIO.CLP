             PGM
             /** AJHC4T **********************************************/
             /* CREATE FA M/F FOR PC SUPPORT (ON OCCASION) ALL DATA  */
             /*      CREATE DATE  :  2006.11.22                      */
             /*      AUTHOR.      :  T.SAKASHITA                     */
             /*                                                      */
             /* TCHK1 03/06/12 CHG ADD *NOSRC TO CRTPF OPTION        */
             /* %0001 06/08/18 ADD AJHWP2D FOR JCD   T.SAKAKI        */
             /********************************************** AJHC4T **/
             DCL        VAR(&USER)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&TVMENT) TYPE(*CHAR) LEN(1)

             RTVJOBA    USER(&USER)

             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             CRTDTAARA  DTAARA(&PLIB/AJHC4TACT) TYPE(*CHAR) +
                          LEN(10) VALUE(&USER)
             MONMSG     MSGID(CPF1023)

             /*---------*/
             /* BACK UP */
             /*---------*/
             CLRPFM     FILE(&PLIB/AJHPPBK)
             CPYF       FROMFILE(&PLIB/AJHPP01) +
                          TOFILE(&PLIB/AJHPPBK) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF2817)

             DLTF       FILE(&WLIB/AJHWP40)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AJHWP40) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(AJHWP40) +
                          TEXT('WORK FROM FA M/F PART WITHDRAWAL +
                          KANBAN') OPTION(*NOLIST *NOSRC) +
                          SIZE(10000 3000) +
                          LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(AJHWP40) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

             DLTF       FILE(&WLIB/AJHWP42)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AJHWP42) RCDLEN(13) TEXT('FA +
                          M/F CHANGE DISKETT WORK')               +
                          OPTION(*NOLIST *NOSRC) +
                          SIZE(10000 3000) LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(AJHWP42) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

             /*------------------------------------------------------*/
             /* WHICH DATA IS INPUT INTO FROM PART WITHDRAWAL KANBAN */
             /*------------------------------------------------------*/
             /* AAHPP01 -> AJHWP40 */
             CALL       PGM(AJHR40)

             /*----------------*/
             /* FA M/F UPDATE  */
             /*----------------*/
             /* AJHWP40 -> AJHPP01 */
             CALL       PGM(AJHR4T)

             /*-----------------------------*/
             /*DELETE DATA MAKING OF FA M/F */
             /*-----------------------------*/
             /* AJHPP01 <- DELETE  */
             /*         -> AJHWP42 */
             CALL       PGM(AJHR44)

             /*-----------------------------------------*/
             /*  A DISKETTE MAKES WITH CHANGE WORK FILE */
             /*-----------------------------------------*/
             DLTF       FILE(&WLIB/AJHWP43)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AJHWP43) RCDLEN(256) +
                          TEXT('OUTPUT A FOR PC SUPPORT DKT') +
                          OPTION(*NOLIST *NOSRC) +
                          SIZE(10000 300) +
                          LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(AJHWP43) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

             DLTF       FILE(&WLIB/AJHWP45)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AJHWP45) RCDLEN(256) +
                          TEXT('OUTPUT AZ FOR PC SUPPORT DKT') +
                          OPTION(*NOLIST *NOSRC) +
                          SIZE(10000 3000) +
                          LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(AJHWP45) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

             /* IT IS MAKING FROM  FA M/F COPY FROM AJSR15 */
             /* AJHWP42 -> AJHPL01 */
             /*         -> AJHWP43 */
             /*         -> AJHWP45 */
             CALL       PGM(AJHR43)

             /*-------------------*/
             /*  FA M/F ALL DATA  */
             /*-------------------*/
             CHGVAR VAR(&TVMENT) VALUE(' ')

             DLTF FILE(&WLIB/AJHWP15)
             MONMSG MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AJHWP15) RCDLEN(256) TEXT('FOR +
                          FA M/F PERSONAL COMPUTER DKT OUTPUT') +
                          OPTION(*NOLIST *NOSRC) +
                          SIZE(10000 1000) +
                          LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(AJHWP15) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

             CALL       PGM(AJHR15) PARM(&TVMENT)

           /* FOR JC1 */
             DLTF FILE(&WLIB/AJHWP21)
             MONMSG MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AJHWP21) RCDLEN(512) TEXT('FOR +
                          FA M/F PERSONAL COMPUTER DKT OUTPUT') +
                          OPTION(*NOLIST *NOSRC) +
                          SIZE(10000 1000) +
                          LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(AJHWP21) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

           /* FOR JC2 */
             DLTF FILE(&WLIB/AJHWP22)
             MONMSG MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AJHWP22) RCDLEN(512) TEXT('FOR +
                          FA M/F PERSONAL COMPUTER DKT OUTPUT') +
                          OPTION(*NOLIST *NOSRC) +
                          SIZE(10000 1000) +
                          LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(AJHWP22) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

           /* FOR JC3 */
             DLTF FILE(&WLIB/AJHWP23)
             MONMSG MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AJHWP23) RCDLEN(512) TEXT('FOR +
                          FA M/F PERSONAL COMPUTER DKT OUTPUT') +
                          OPTION(*NOLIST *NOSRC) +
                          SIZE(10000 1000) +
                          LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(AJHWP23) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

           /* FOR JC4 */
             DLTF FILE(&WLIB/AJHWP24)
             MONMSG MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AJHWP24) RCDLEN(512) TEXT('FOR +
                          FA M/F PERSONAL COMPUTER DKT OUTPUT') +
                          OPTION(*NOLIST *NOSRC) +
                          SIZE(10000 1000) +
                          LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(AJHWP24) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

           /* FOR JC5 */
             DLTF FILE(&WLIB/AJHWP25)
             MONMSG MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AJHWP25) RCDLEN(512) TEXT('FOR +
                          FA M/F PERSONAL COMPUTER DKT OUTPUT') +
                          OPTION(*NOLIST *NOSRC) +
                          SIZE(10000 1000) +
                          LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(AJHWP25) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

           /* FOR JC6 */
             DLTF FILE(&WLIB/AJHWP26)
             MONMSG MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AJHWP26) RCDLEN(512) TEXT('FOR +
                          FA M/F PERSONAL COMPUTER DKT OUTPUT') +
                          OPTION(*NOLIST *NOSRC) +
                          SIZE(10000 1000) +
                          LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(AJHWP26) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

           /* FOR JC7 */
             DLTF FILE(&WLIB/AJHWP27)
             MONMSG MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AJHWP27) RCDLEN(512) TEXT('FOR +
                          FA M/F PERSONAL COMPUTER DKT OUTPUT') +
                          OPTION(*NOLIST *NOSRC) +
                          SIZE(10000 1000) +
                          LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(AJHWP27) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

           /* FOR JC8 */
             DLTF FILE(&WLIB/AJHWP28)
             MONMSG MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AJHWP28) RCDLEN(512) TEXT('FOR +
                          FA M/F PERSONAL COMPUTER DKT OUTPUT') +
                          OPTION(*NOLIST *NOSRC) +
                          SIZE(10000 1000) +
                          LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(AJHWP28) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

           /* FOR JCA */
             DLTF FILE(&WLIB/AJHWP2A)
             MONMSG MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AJHWP2A) RCDLEN(512) TEXT('FOR +
                          FA M/F PERSONAL COMPUTER DKT OUTPUT') +
                          OPTION(*NOLIST *NOSRC) +
                          SIZE(10000 1000) +
                          LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(AJHWP2A) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

           /* FOR JCB */
             DLTF FILE(&WLIB/AJHWP2B)
             MONMSG MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AJHWP2B) RCDLEN(512) TEXT('FOR +
                          FA M/F PERSONAL COMPUTER DKT OUTPUT') +
                          OPTION(*NOLIST *NOSRC) +
                          SIZE(10000 1000) +
                          LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(AJHWP2B) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

           /* FOR JC9 */
             DLTF FILE(&WLIB/AJHWP29)
             MONMSG MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AJHWP29) RCDLEN(512) TEXT('FOR +
                          FA M/F PERSONAL COMPUTER DKT OUTPUT') +
                          OPTION(*NOLIST *NOSRC) SIZE(10000 1000) +
                          LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(AJHWP29) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

     /* %0001 FOR JCD */
             DLTF FILE(&WLIB/AJHWP2D)
             MONMSG MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/AJHWP2D) RCDLEN(512) TEXT('FOR +
                          FA M/F PERSONAL COMPUTER DKT OUTPUT') +
                          OPTION(*NOLIST *NOSRC) SIZE(10000 1000) +
                          LVLCHK(*NO) AUT(*ALL)
             GRTOBJAUT  OBJ(AJHWP2D) OBJTYPE(*FILE) USER(*PUBLIC) +
                          AUT(*ALL)

           /******************************/
           /* CREATED BY AAF,CAD         */
           /******************************/
             CLRPFM     FILE(AJHPP80)

           /*  AAFTL06 -> AJHPP80  */
             CALL       PGM(AJHR80)
           /*  CADTL03 -> AJHPP80  */
             CALL       PGM(AJHR85)

           /* AJHPL01 -> OUTPUT        */
           /*         -> AJHWP21 (JC1) */
           /*         -> AJHWP22 (JC2) */
           /*         -> AJHWP23 (JC3) */
           /*         -> AJHWP24 (JC4) */
           /*         -> AJHWP25 (JC5) */
           /*         -> AJHWP26 (JC6) */
           /*         -> AJHWP27 (JC7) */
           /*         -> AJHWP28 (JC8) */
           /*         -> AJHWP2A (JCA) */
           /*         -> AJHWP2B (JCB) */
           /*         -> AJHWP29 (JC9) */
           /*         -> AJHWP2D (JCD) */

             OVRDBF     FILE(OUTPUT) TOFILE(AJHWP21)
             CALL       PGM(AJHR21) PARM(&TVMENT '1')
             CALL       PGM(AJHR81) PARM('1')

             OVRDBF     FILE(OUTPUT) TOFILE(AJHWP22)
             CALL       PGM(AJHR21) PARM(&TVMENT '2')
             CALL       PGM(AJHR81) PARM('2')

             OVRDBF     FILE(OUTPUT) TOFILE(AJHWP23)
             CALL       PGM(AJHR21) PARM(&TVMENT '3')
             CALL       PGM(AJHR81) PARM('3')

             OVRDBF     FILE(OUTPUT) TOFILE(AJHWP24)
             CALL       PGM(AJHR21) PARM(&TVMENT '4')
             CALL       PGM(AJHR81) PARM('4')

             OVRDBF     FILE(OUTPUT) TOFILE(AJHWP25)
             CALL       PGM(AJHR21) PARM(&TVMENT '5')
             CALL       PGM(AJHR81) PARM('5')

             OVRDBF     FILE(OUTPUT) TOFILE(AJHWP26)
             CALL       PGM(AJHR21) PARM(&TVMENT '6')
             CALL       PGM(AJHR81) PARM('6')

             OVRDBF     FILE(OUTPUT) TOFILE(AJHWP27)
             CALL       PGM(AJHR21) PARM(&TVMENT '7')
             CALL       PGM(AJHR81) PARM('7')

             OVRDBF     FILE(OUTPUT) TOFILE(AJHWP28)
             CALL       PGM(AJHR21) PARM(&TVMENT '8')
             CALL       PGM(AJHR81) PARM('8')

             OVRDBF     FILE(OUTPUT) TOFILE(AJHWP2A)
             CALL       PGM(AJHR21) PARM(&TVMENT 'A')
             CALL       PGM(AJHR81) PARM('A')

             OVRDBF     FILE(OUTPUT) TOFILE(AJHWP2B)
             CALL       PGM(AJHR21) PARM(&TVMENT 'B')
             CALL       PGM(AJHR81) PARM('B')

             OVRDBF     FILE(OUTPUT) TOFILE(AJHWP29)
             CALL       PGM(AJHR21) PARM(&TVMENT '9')
             CALL       PGM(AJHR81) PARM('9')

       /* %0001 */
             OVRDBF     FILE(OUTPUT) TOFILE(AJHWP2D)
             CALL       PGM(AJHR21) PARM(&TVMENT 'D')
             CALL       PGM(AJHR81) PARM('D')

             DLTOVR     FILE(OUTPUT)

             DLTDTAARA  DTAARA(&PLIB/AJHC4TACT)
             MONMSG     MSGID(CPF2105)

             ENDPGM
