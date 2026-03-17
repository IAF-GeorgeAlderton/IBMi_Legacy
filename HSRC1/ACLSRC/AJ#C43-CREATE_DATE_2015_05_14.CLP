             PGM        PARM(&BAN1 &BAN2 &BAN3 &BAN4)
             /** AJ#C43 ************************************/
             /*               CREATE DATE : 2015.05.14     */
             /*               ITS.                         */
             /**********************************************/
             DCL        VAR(&BAN1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&BAN2) TYPE(*CHAR) LEN(2)
             DCL        VAR(&BAN3) TYPE(*CHAR) LEN(2)
             DCL        VAR(&BAN4) TYPE(*CHAR) LEN(1)

             DCL        VAR(&SYS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&WT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&@LIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&@FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&@HOST) TYPE(*CHAR) LEN(8)
             DCL        VAR(&@SAVE) TYPE(*CHAR) LEN(52)
             DCL        VAR(&@TYPE) TYPE(*CHAR) LEN(2)

             RTVNETA    SYSNAME(&SYS)
             RTVJOBA    JOB(&WSID)

             CHGVAR     VAR(&WT) VALUE(%SST(&WSID 1 3))

             IF         COND(&WT *NE 'HPI' *AND &WT *NE 'V#I') THEN(DO)
             CALL       PGM(APPC96) PARM('INVWP41')
          /* GOTO       CMDLBL(@END) */
             ENDDO

             IF         COND(&WT *EQ 'HPI' *OR &WT *EQ 'V#I') THEN(DO)

          /* GOTO       CMDLBL(@END) */

             DLTF       FILE(QTEMP/INVWP41)
             MONMSG     MSGID(CPF3261 CPF2105)
             CPYF       FROMFILE(HWFILE1/INVWP41) +
                          TOFILE(QTEMP/INVWP41) CRTFILE(*YES)

             DLTF       FILE(QTEMP/INVPP46)
             MONMSG     MSGID(CPF3261 CPF2105)
             CPYF       FROMFILE(HFILE1/INVPP46) +
                          TOFILE(QTEMP/INVPP46) CRTFILE(*YES)

             DLTF       FILE(QTEMP/AB#WPS3)
             MONMSG     MSGID(CPF3261 CPF2105)
             CPYF       FROMFILE(HWFILE1/AB#WPS3) +
                          TOFILE(QTEMP/AB#WPS3) CRTFILE(*YES)

             DLTF       FILE(QTEMP/AB#WPS4)
             MONMSG     MSGID(CPF3261 CPF2105)
             CPYF       FROMFILE(HWFILE1/AB#WPS4) +
                          TOFILE(QTEMP/AB#WPS4) CRTFILE(*YES)

             CHKOBJ     OBJ(WEEKDLT/FINVPP40) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTPF      FILE(WEEKDLT/FINVPP40) +
                          SRCFILE(HSRC1/ADDSSRC) SRCMBR(INVPP40)
             MONMSG     MSGID(CPF0000)
             ENDDO

@STEP1:
             OVRDBF     FILE(INVPP40) TOFILE(WEEKDLT/FINVPP40)

             ENDDO

             CLRPFM     FILE(INVWP41)
             CLRPFM     FILE(AB#WPS3)
             CLRPFM     FILE(AB#WPS4)

             CALL       PGM(AJ#R41) PARM(&BAN1 &BAN2 &BAN3 &BAN4 ' ')

          /* AB#WPS3 -> AB#WPS4 */
             CALL       PGM(AB#RS4)

          /* ------------------------------------------------ */
             /* SAFE LIST */
             CLRPFM     FILE(INVPP46)

             DLTF       FILE(HWFILE1/INVWP47)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/INVWP47) RCDLEN(2015) +
                          OPTION(*NOLIST) SIZE(10000 3000) +
                          LVLCHK(*NO) AUT(*ALL)

             /* CREATE SAFE LIST */
             /* INVWP41 -> INVPP46 */
             OVRDBF     FILE(OUTPUT) TOFILE(INVWP47)
             CALL       PGM(INVR47)

             /* DELETE SAFE DATA */
             /* INVPP46 -> INVWP41 */
             CALL       PGM(INVR4Z)
          /* ------------------------------------------------ */

             CALL       PGM(INVR42)
             CALL       PGM(INVR43)

             IF         COND(&WT *EQ 'HPI' *OR &WT *EQ 'V#I') THEN(DO)
             DLTF       FILE(HWFILE1/INVWP41T)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/INVWP41T) RCDLEN(2015) +
                          OPTION(*NOLIST) SIZE(10000 3000) +
                          LVLCHK(*NO) AUT(*ALL)
             OVRDBF     FILE(OUTPUT) TOFILE(INVWP41T)
             GOTO       CMDLBL(@JUMP)
             ENDDO

             DLTF       FILE(HWFILE1/INVWP41S)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/INVWP41S) RCDLEN(2015) +
                          OPTION(*NOLIST) SIZE(10000 3000) +
                          LVLCHK(*NO) AUT(*ALL)

       /*    CALL       PGM(INVR44)       */

          /* CALL       PGM(INVC46) */

             OVRDBF     FILE(OUTPUT) TOFILE(INVWP41S)
@JUMP:
             CALL       PGM(AJ#R45)
             DLTOVR     FILE(OUTPUT)

             IF         COND(&WT *NE 'HPI' *AND &WT *NE 'V#I') THEN(DO)
             CALL       PGM(APPC97) PARM('INVWP41')
             CALL       PGM(APPC97) PARM('INVPP40')
             CALL       PGM(APPC97) PARM('INVPP46')
             CALL       PGM(APPC97) PARM('ABBPP9A')
             CALL       PGM(APPC97) PARM('ABBPP90')
             CALL       PGM(APPC97) PARM('INVWP41S')
             GOTO       CMDLBL(@END)
             ENDDO

             CHGVAR     VAR(&@LIBL) VALUE('HWFILE1')
             CHGVAR     VAR(&@FILE) VALUE('INVWP41T')
             CHGVAR     VAR(&@HOST) VALUE(&SYS)
             CHGVAR     VAR(&@SAVE) VALUE('C:/AS400/DATA/INVWP41T.CSV')
             CHGVAR     VAR(&@TYPE) VALUE(' 1')

             CALL       PGM(APLC98) PARM(&@LIBL &@FILE &@HOST &@SAVE +
                          &@TYPE)

             STRPCO     PCTA(*NO)
             MONMSG     MSGID(CPF0000)

             STRPCCMD   PCCMD(&@SAVE) PAUSE(*NO)

@END:
             ENDPGM
