             PGM
/** VVVC60 ************************************************/
/*  SET FILE-FIELD IN VVVPP60                             */
/*  JW       2022.09.06                                   */
/**********************************************************/

             DCL        VAR(&LIB ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FIL ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEM ) TYPE(*CHAR) LEN(10)

/*  SET FILE NAME */
             CLRPFM     FILE(HFILE1/VVVPP60)
             CALL       PGM(VVVR60  )

/*  SET FIELD DATA */
             CALL       PGM(VVVR60A )

/*  DELETE EMPTY FILE  **/
             CALL       PGM(VVVR60C )

             ENDPGM
