             PGM
             /** APLC02 ******************************************/
             /*  COMPILE CL                                      */
             /*  JW     2021.07.06                               */
             /*                                                  */
             /*  // RUN THIS CL IN TEST MODE FIRST //            */
             /*  // THEN RUN THIS CL IN PRODUCTION //            */
             /****************************************************/

/* *******************************************************************  */
         /** DCL        VAR(&LIB)  TYPE(*CHAR) LEN(10) VALUE('TFILE1  ') **/
         /** DCL        VAR(&WLIB) TYPE(*CHAR) LEN(10) VALUE('TWFILE1 ') **/
         /** DCL        VAR(&OBJ ) TYPE(*CHAR) LEN(10) VALUE('TOBJ1   ') **/

             DCL        VAR(&LIB)  TYPE(*CHAR) LEN(10) VALUE('HFILE1  ')
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(10) VALUE('HWFILE1 ')
             DCL        VAR(&OBJ ) TYPE(*CHAR) LEN(10) VALUE('HOBJ1   ')

/* TEMP STOP JOB  **************************************************** */

        /**  GOTO       CMDLBL(ENDP)  **/

/* SAVE DATA ********************************************************* */
             DLTF       FILE(WATALIB/AB#PP25SV)
             MONMSG     MSGID(CPF0000)

             CPYF       FROMFILE(&LIB/AB#PP25) +
                          TOFILE(WATALIB/AB#PP25SV) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NOCHK)

/* DELETE LF ********************************************************* */
             DLTF       FILE(&LIB/AB#PL25 )

/* DELETE PF ********************************************************* */
             DLTF       FILE(&LIB/AB#PP25 )

/* CREATE PF ********************************************************* */
             CRTPF      FILE(&LIB/AB#PP25) SRCFILE(HSRC1/ADDSSRC) +
                          SIZE(9999999 30000)

/* CREATE LF ********************************************************* */
             CRTLF      FILE(&LIB/AB#PL25) SRCFILE(HSRC1/ADDSSRC)

/* COMPILE RPG ********************************************************* */
             CRTRPGPGM PGM(&OBJ/AB#REB ) SRCFILE(HSRC1/ARPGSRC)
             CRTRPGPGM PGM(&OBJ/AB#R0I ) SRCFILE(HSRC1/ARPGSRC)
             CRTRPGPGM PGM(&OBJ/AB#R2BN) SRCFILE(HSRC1/ARPGSRC)
             CRTRPGPGM PGM(&OBJ/AB#R2L ) SRCFILE(HSRC1/ARPGSRC)
             CRTRPGPGM PGM(&OBJ/AB#R2T ) SRCFILE(HSRC1/ARPGSRC)
             CRTRPGPGM PGM(&OBJ/AB#R3U ) SRCFILE(HSRC1/ARPGSRC)
             CRTRPGPGM PGM(&OBJ/AB#R79 ) SRCFILE(HSRC1/ARPGSRC)
             CRTRPGPGM PGM(&OBJ/AC#R2B ) SRCFILE(HSRC1/ARPGSRC)
             CRTRPGPGM PGM(&OBJ/AC#R2BT) SRCFILE(HSRC1/ARPGSRC)

/* RESTORE DATA ********************************************************* */
             CPYF       FROMFILE(WATALIB/AB#PP25SV) +
                          TOFILE(&LIB/AB#PP25) MBROPT(*ADD) +
                          CRTFILE(*NO) FMTOPT(*MAP *DROP)
ENDP:
             ENDPGM
