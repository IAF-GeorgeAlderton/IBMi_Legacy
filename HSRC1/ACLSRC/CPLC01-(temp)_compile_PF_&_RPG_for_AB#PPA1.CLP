             PGM
             /** APLC01 ******************************************/
             /*  COMPILE CL                                      */
             /*  JW     2018.03.13                               */
             /*                                                  */
             /*  // RUN THIS CL IN TEST MODE FIRST //            */
             /*  // THEN RUN THIS CL IN PRODUCTION //            */
             /****************************************************/

/* COMPILE AB#PPA1 ***************************************************  */
          /* DCL        VAR(&LIB)  TYPE(*CHAR) LEN(10) VALUE('TFILE1')  */
          /* DCL        VAR(&WLIB) TYPE(*CHAR) LEN(10) VALUE('TWFILE1') */
          /* DCL        VAR(&OBJ ) TYPE(*CHAR) LEN(10) VALUE('TOBJ1  ') */

             DCL        VAR(&LIB)  TYPE(*CHAR) LEN(10) VALUE('HFILE1')
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(10) VALUE('HWFILE1')
             DCL        VAR(&OBJ ) TYPE(*CHAR) LEN(10) VALUE('HOBJ1  ')

/* COMPILE AB#PPA1 *************************************************** */

             GOTO       CMDLBL(ENDP)

/* SAVE DATA ********************************************************* */
             CPYF       FROMFILE(&LIB/AB#PPA1) +
                          TOFILE(&WLIB/AB#PPA1313) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NOCHK)

/* DELETE LF ********************************************************* */
             DLTF       FILE(&LIB/AB#PLAA )
             DLTF       FILE(&LIB/AB#PLAJ )
             DLTF       FILE(&LIB/AB#PLAN )
             DLTF       FILE(&LIB/AB#PLA3 )
             DLTF       FILE(&LIB/AB#PLA4 )
             DLTF       FILE(&LIB/AB#PLA5 )
             DLTF       FILE(&LIB/AB#PLA8 )

/* DELETE PF ********************************************************* */
             DLTF       FILE(&LIB/AB#PPA1 )

/* CREATE PF ********************************************************* */
             CRTPF      FILE(&LIB/AB#PPA1) SRCFILE(HSRC1/ADDSSRC) +
                          SIZE(9999999 30000)

/* CREATE LF ********************************************************* */
             CRTLF      FILE(&LIB/AB#PLAA) SRCFILE(HSRC1/ADDSSRC)
             CRTLF      FILE(&LIB/AB#PLAJ) SRCFILE(HSRC1/ADDSSRC)
             CRTLF      FILE(&LIB/AB#PLAN) SRCFILE(HSRC1/ADDSSRC)
             CRTLF      FILE(&LIB/AB#PLA3) SRCFILE(HSRC1/ADDSSRC)
             CRTLF      FILE(&LIB/AB#PLA4) SRCFILE(HSRC1/ADDSSRC)
             CRTLF      FILE(&LIB/AB#PLA5) SRCFILE(HSRC1/ADDSSRC)
             CRTLF      FILE(&LIB/AB#PLA8) SRCFILE(HSRC1/ADDSSRC)


/* COMPILE RPG ********************************************************* */
             CRTRPGPGM PGM(&OBJ/AB#R4N ) SRCFILE(HSRC1/ARPGSRC)
             CRTRPGPGM PGM(&OBJ/AB#RE9 ) SRCFILE(HSRC1/ARPGSRC)
             CRTRPGPGM PGM(&OBJ/AB#RH6 ) SRCFILE(HSRC1/ARPGSRC)
             CRTRPGPGM PGM(&OBJ/AB#R1H ) SRCFILE(HSRC1/ARPGSRC)
             CRTRPGPGM PGM(&OBJ/AB#R3A ) SRCFILE(HSRC1/ARPGSRC)
             CRTRPGPGM PGM(&OBJ/AB#R3A1) SRCFILE(HSRC1/ARPGSRC)
             CRTRPGPGM PGM(&OBJ/AB#R3A2) SRCFILE(HSRC1/ARPGSRC)
             CRTRPGPGM PGM(&OBJ/AB#R3Q ) SRCFILE(HSRC1/ARPGSRC)
             CRTRPGPGM PGM(&OBJ/AB#R37 ) SRCFILE(HSRC1/ARPGSRC)
             CRTRPGPGM PGM(&OBJ/AB#R4M ) SRCFILE(HSRC1/ARPGSRC)
             CRTRPGPGM PGM(&OBJ/AB#R4S ) SRCFILE(HSRC1/ARPGSRC)
             CRTRPGPGM PGM(&OBJ/AB#R45 ) SRCFILE(HSRC1/ARPGSRC)
             CRTRPGPGM PGM(&OBJ/AB#R95 ) SRCFILE(HSRC1/ARPGSRC)
             CRTRPGPGM PGM(&OBJ/AC#R05 ) SRCFILE(HSRC1/ARPGSRC)
             CRTRPGPGM PGM(&OBJ/AM#R11 ) SRCFILE(HSRC1/ARPGSRC)

/* RESTORE DATA ********************************************************* */
             CPYF       FROMFILE(&WLIB/AB#PPA1313) +
                          TOFILE(&LIB/AB#PPA1) MBROPT(*ADD) +
                          CRTFILE(*NO) FMTOPT(*MAP *DROP)
ENDP:
             ENDPGM
