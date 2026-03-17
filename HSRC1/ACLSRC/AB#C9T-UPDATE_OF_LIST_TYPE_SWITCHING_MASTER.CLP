             PGM
             /** AB#C9T ********************************************/
             /*  UPDATE OF LIST TYPE SWITCHING MASTER(+ CSV DATA)  */
             /*  KIRI                            2018.02.21        */
             /******************************************************/
             DCL        VAR(&SYS)   TYPE(*CHAR) LEN(8)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT)    TYPE(*CHAR) LEN(3)
             DCL        VAR(&REC)   TYPE(*DEC)  LEN(10 0)

             DCL        VAR(&@LIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&@FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&@HOST) TYPE(*CHAR) LEN(8)
             DCL        VAR(&@SAVE) TYPE(*CHAR) LEN(52)
             DCL        VAR(&@TYPE) TYPE(*CHAR) LEN(2)

             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)

             RTVNETA    SYSNAME(&SYS)
             RTVJOBA    JOB(&WSID) USER(&USER)

     /*--------------------------*/
     /*    CHECK ENVIRONMENT     */
     /*--------------------------*/
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             CHGVAR     VAR(&@FILE) VALUE('AB#WP9T' *CAT %SST(&WSID 1 3))

             DLTF       FILE(&WLIB/&@FILE)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&@FILE) RCDLEN(1024) +
                          OPTION(*NOLIST) SIZE(10000 3000) +
                          LVLCHK(*NO) AUT(*ALL)


             OVRDBF     FILE(AB#WP9T) TOFILE(&WLIB/&@FILE)
             CALL       PGM(AB#R9T)
             DLTOVR     FILE(AB#WP9T)

             RTVMBRD    FILE(&WLIB/&@FILE)  NBRCURRCD(&REC)
             IF         COND(&REC *EQ 0) THEN(GOTO CMDLBL(@END))

             CHGVAR     VAR(&@LIBL) VALUE(&WLIB)
             CHGVAR     VAR(&@HOST) VALUE(&SYS)
             CHGVAR     VAR(&@SAVE) VALUE('C:/AS400/DATA/AB#WP9T.CSV')
             CHGVAR     VAR(&@TYPE) VALUE(' 1')
             CALL       PGM(APLC98) PARM(&@LIBL &@FILE &@HOST &@SAVE +
                          &@TYPE)

    /* JW1 IFS TRANSFER */
  /**        CPYF       FROMFILE(&@LIBL/&@FILE) TOFILE(&@LIBL/FILE1024) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)   **/
   /**       CALL       PGM(APLC96) PARM('1' 'FILE1024' 'HWFILE1' +
                          'LIST TYPE SWITCIN')       **/

@END:
             ENDPGM
