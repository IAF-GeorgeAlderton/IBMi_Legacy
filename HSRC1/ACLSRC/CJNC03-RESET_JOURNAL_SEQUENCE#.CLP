             PGM
             /** CJNC03 ************************************/
             /*ジャーナル　シーケンス番号初期化　　　　  */
             /*   Y.MAEDA                  2023.05.29      */
             /**********************************************/
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CNT) TYPE(*DEC) LEN(2 0)

             CHGVAR     VAR(&CNT) VALUE(0)
LOOP:
             IF         COND(&CNT *GE 10) THEN(GOTO CMDLBL(@END))
             CHGJRN     JRN(HJRN1/JRNAPICS) JRNRCV(*GEN) SEQOPT(*RESET)
             MONMSG     MSGID(CPF7018) EXEC(DO)
             CHGVAR     VAR(&CNT) VALUE(&CNT + 1)
             GOTO       CMDLBL(LOOP)
             ENDDO

@END:        ENDPGM
