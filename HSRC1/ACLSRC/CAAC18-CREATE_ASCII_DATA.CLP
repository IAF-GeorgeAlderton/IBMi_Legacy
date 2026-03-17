             PGM        PARM(&PBMON &PDATE &PBIN)
             /** CAAC18 ******************************/
             /*  ASCII DATA CREATION                 */
             /*      T.SAKASHITA       2020.09.29    */
             /****************************** CAAC17 **/
             DCL        VAR(&SYS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WS) TYPE(*CHAR) LEN(3)
             DCL        VAR(&TEST) TYPE(*CHAR) LEN(1)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(10)

             DCL        VAR(&CAA) TYPE(*CHAR) LEN(10)

             DCL        VAR(&CA2E) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CA2E2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CA2A) TYPE(*CHAR) LEN(10)

             DCL        VAR(&CA3E) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CA3E2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CA3A) TYPE(*CHAR) LEN(10)

             DCL        VAR(&PBMON) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PDATE) TYPE(*DEC) LEN(8 0)
             DCL        VAR(&PBIN) TYPE(*CHAR) LEN(2)

             DCL        VAR(&@LIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&@FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&@HOST) TYPE(*CHAR) LEN(8)
             DCL        VAR(&@SAVE) TYPE(*CHAR) LEN(52)
             DCL        VAR(&@TYPE) TYPE(*CHAR) LEN(2)

             RTVNETA    SYSNAME(&SYS)
             RTVJOBA    USER(&USER)
             RTVJOBA    JOB(&WSID)
    /********************************/
    /* CHECK LIBRARY                */
    /********************************/
             CALL       PGM(ALBC01) PARM(&USER &PLIB &WLIB)

             /*              DIVIDE        ADD HEADER     ASCII    */
             /* CAA011101 -> CA2011101E -> CA20111012 -> CA2011101 */
             /*              (&CA2E)       (&CA2E2)      (&CA2A)   */
             /*           -> CA3011101E -> CA30111012 -> CA3011101 */
             /*              (&CA2E)       (&CA2E2)      (&CA2A)   */


             CHGVAR     VAR(&WS) VALUE(%SST(&WSID 1 3))
             CHGVAR     VAR(&TEST) VALUE('0')
             IF (&WS *EQ 'HPI') DO
             CHGVAR     VAR(&TEST) VALUE('1')
             ENDDO


         CHGVAR     VAR(&CAA) VALUE('CAA' *TCAT &PBMON *TCAT &PBIN)

         CHGVAR     VAR(&CA2E) VALUE('CA2' *TCAT &PBMON *TCAT &PBIN *TCAT 'E')
         CHGVAR     VAR(&CA2E2) VALUE('CA2' *TCAT &PBMON *TCAT &PBIN *TCAT '2')
         CHGVAR     VAR(&CA2A) VALUE('CA2' *TCAT &PBMON *TCAT &PBIN)

         CHGVAR     VAR(&CA3E) VALUE('CA3' *TCAT &PBMON *TCAT &PBIN *TCAT 'E')
         CHGVAR     VAR(&CA3E2) VALUE('CA3' *TCAT &PBMON *TCAT &PBIN *TCAT '2')
         CHGVAR     VAR(&CA3A) VALUE('CA3' *TCAT &PBMON *TCAT &PBIN)

           /*------------------------------------------------*/

             DLTF       FILE(&CA2E)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&CA2E) RCDLEN(3072)

             DLTF       FILE(&CA2E2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&CA2E2) RCDLEN(3072)

             DLTF       FILE(&CA2A)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&CA2A) RCDLEN(3072)

           /*------------------------------------------------*/

             DLTF       FILE(&CA3E)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&CA3E) RCDLEN(3072)

             DLTF       FILE(&CA3E2)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&CA3E2) RCDLEN(3072)

             DLTF       FILE(&CA3A)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(&WLIB/&CA3A) RCDLEN(3072)

           /*------------------------------------------------*/
             IF         COND(&TEST *EQ '1') THEN(DO)
             EDTDTA     FILE(&CAA)
             ENDDO

           /* DIVIDE */

           /* &CAA -> &CA2E */
           /*      -> &CA3E */
             OVRDBF     FILE(INPUT) TOFILE(&CAA)
             OVRDBF     FILE(CA2) TOFILE(&CA2E)
             OVRDBF     FILE(CA3) TOFILE(&CA3E)
             CALL       PGM(CAAR18)

             IF         COND(&TEST *EQ '1') THEN(DO)
             EDTDTA     FILE(&CA2E)
             EDTDTA     FILE(&CA3E)
             ENDDO

           /* ADD HEADER */

           /* &CA2E -> &CA2E2 */
             OVRDBF     FILE(OUTPUT1) TOFILE(&CA2E)
             OVRDBF     FILE(OUTPUT2) TOFILE(&CA2E2)
             CALL       PGM(CAAR88) PARM(&PDATE &PBIN)

             IF         COND(&TEST *EQ '1') THEN(DO)
             EDTDTA     FILE(&CA2E2)
             ENDDO

           /* &CA3E -> &CA3E2 */
             OVRDBF     FILE(OUTPUT1) TOFILE(&CA3E)
             OVRDBF     FILE(OUTPUT2) TOFILE(&CA3E2)
             CALL       PGM(CAAR88) PARM(&PDATE &PBIN)

             IF         COND(&TEST *EQ '1') THEN(DO)
             EDTDTA     FILE(&CA3E2)
             ENDDO

           /* EBCDIC -> ASCII */
           /* &CA2E2 -> &CA2A */
             OVRDBF     FILE(OUTPUT1) TOFILE(&CA2E2)
             OVRDBF     FILE(OUTPUT2) TOFILE(&CA2A)
             CALL       PGM(CAARCV)

             CHGVAR     VAR(&@LIBL) VALUE(&WLIB)
             CHGVAR     VAR(&@FILE) VALUE(&CA2A)
             CHGVAR     VAR(&@HOST) VALUE(&SYS)
        CHGVAR     VAR(&@SAVE) VALUE('C:/AS400/DATA/' *CAT &CA2A *TCAT '.TXT')
             CHGVAR     VAR(&@TYPE) VALUE(' 6')

             IF         COND(&TEST *EQ '1') THEN(DO)
             CALL       PGM(APLC98) PARM(&@LIBL &@FILE &@HOST &@SAVE +
                          &@TYPE)
             ENDDO

           /* &CA3E2 -> &CA3A */
             OVRDBF     FILE(OUTPUT1) TOFILE(&CA3E2)
             OVRDBF     FILE(OUTPUT2) TOFILE(&CA3A)
             CALL       PGM(CAARCV)

             CHGVAR     VAR(&@LIBL) VALUE(&WLIB)
             CHGVAR     VAR(&@FILE) VALUE(&CA3A)
             CHGVAR     VAR(&@HOST) VALUE(&SYS)
        CHGVAR     VAR(&@SAVE) VALUE('C:/AS400/DATA/' *CAT &CA3A *TCAT '.TXT')
             CHGVAR     VAR(&@TYPE) VALUE(' 6')

             IF         COND(&TEST *EQ '1') THEN(DO)
             CALL       PGM(APLC98) PARM(&@LIBL &@FILE &@HOST &@SAVE +
                          &@TYPE)
             ENDDO

             ENDPGM
