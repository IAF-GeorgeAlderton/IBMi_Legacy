             PGM       PARM(&LIB &FIL &MEM)
/** VVVC601 ***********************************************/
/*  OVRDBF DDSSRC                                         */
/*  JW       2024.06.10                                   */
/**********************************************************/

             DCL        VAR(&LIB ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FIL ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEM ) TYPE(*CHAR) LEN(10)

/*  SET FIELD DATA */

             OVRDBF     FILE(DDSSRC) TOFILE(&LIB/&FIL) MBR(&MEM)
/* HFILE1 */
             CHKOBJ     OBJ(HFILE1/&MEM) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(SKIPW))
SET:
             CALL       PGM(VVVR60B ) PARM(&LIB &FIL &MEM)
             MONMSG     MSGID(CPF0000)
             GOTO       CMDLBL(ENDP)
/* HWFILE1 */
SKIPW:
             CHKOBJ     OBJ(HWFILE1/&MEM) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF4102 CPF9801) EXEC(GOTO CMDLBL(ENDP))
             GOTO       CMDLBL(SET)

ENDP:        ENDPGM
