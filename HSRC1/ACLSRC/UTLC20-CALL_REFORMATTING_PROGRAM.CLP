             PGM        PARM(&FILE &LIB &DATE)
             /** UTLC20 ****************************************/
             /*  CALL REFORMATION PROGRAM                      */
             /*  JW1: J-WATANABE             2017.04.06        */
             /*  &XDATE - TODAY'S DATE                         */
             /**************************************************/
             DCLF       FILE(UTLPW20)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&LIB ) TYPE(*CHAR) LEN(8)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(8)

             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WSID) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USR ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FROM ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TO   ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WKTM ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&WSTM ) TYPE(*CHAR) LEN(6)
             DCL        VAR(&REC1 ) TYPE(*CHAR) LEN(9)
             DCL        VAR(&REC2 ) TYPE(*CHAR) LEN(9)
             DCL        VAR(&OK   ) TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USR)

             CHGVAR     VAR(&XFILE) VALUE(&FILE)
             CHGVAR     VAR(&XDATE) VALUE(&DATE)
             CHGVAR     VAR(&FROM) VALUE('HFILE1')
             CHGVAR     VAR(&TO  ) VALUE('BACKUP')

 STP1:       SNDRCVF    DEV(&WSID) RCDFMT(DSP01)
             CHGVAR     VAR(&OK  ) VALUE('N')
             CHGVAR     VAR(&XMSG) VALUE(' ')
             CHGVAR     VAR(&IN41) VALUE('0')
             CHGVAR     VAR(&IN42) VALUE('0')

             IF         (&IN01 *EQ '1') GOTO ENDPGM

             IF         (&XFILE *EQ ' ') DO
             CHGVAR     VAR(&IN41) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ERR: ENTER TARGET FILE!')
             GOTO       STP1
             ENDDO

             IF         (&XDATE *EQ ' ') DO
             CHGVAR     VAR(&IN42) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ERR: ENTER DATE!.')
             GOTO       STP1
             ENDDO

             IF         (%SST(&XDATE 1 4) *LT '1984') GOTO STP2
             IF         (%SST(&XDATE 5 2) *GT '12') GOTO STP2
             IF         (%SST(&XDATE 5 2) *LT '01') GOTO STP2
             IF         (%SST(&XDATE 7 2) *GT '31') GOTO STP2
             IF         (%SST(&XDATE 7 2) *LT '01') GOTO STP2
             GOTO       STP3
 STP2:
             CHGVAR     VAR(&IN42) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ERR: INVALIDE DATE !')
             GOTO       STP1

 STP3:       IF         (&IN05 *EQ '0') THEN(DO)
             CHGVAR     VAR(&XMSG) VALUE('PRESS F1 FOR END OR F5 TO RUN...')
             GOTO       CMDLBL(STP1)
             ENDDO

             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&WKTM)

 /* VRFR21 - AJVPPLG */
             IF         (&XFILE *EQ 'AJVPPLG') THEN(DO)
         /** DLTF       FILE(&TO/AJVPPLGSV )                        **/
         /** MONMSG     MSGID(CPF3261 CPF2105)                      **/
         /** CPYF       FROMFILE(&FROM/AJVPPLG) +                   **/
         /**              TOFILE(&TO/AJVPPLGSV) MBROPT(*REPLACE) +  **/
         /**              CRTFILE(*YES) FMTOPT(*NOCHK)              **/
             OVRDBF     FILE(AJVPPLG)  TOFILE(&FROM/AJVPPLG)
             OVRDBF     FILE(AJVPPLGB) TOFILE(&TO/AJVPPLGB )
             CALL       PGM(VRFR21) PARM(&XDATE &REC1 &REC2)
             CHGVAR     VAR(&OK  ) VALUE('Y')
             ENDDO

 /* VRFR22 - GDGPP02 */
             IF         (&XFILE *EQ 'GDGPP02') THEN(DO)
         /** DLTF       FILE(&TO/GDGPP02SV )                        **/
         /** MONMSG     MSGID(CPF3261 CPF2105)                      **/
         /** CPYF       FROMFILE(&FROM/GDGPP02) +                   **/
         /**              TOFILE(&TO/GDGPP02SV) MBROPT(*REPLACE) +  **/
         /**              CRTFILE(*YES) FMTOPT(*NOCHK)              **/
             OVRDBF     FILE(GDGPP02)  TOFILE(&FROM/GDGPP02)
             OVRDBF     FILE(GDGPP02B) TOFILE(&TO/GDGPP02B )
             CALL       PGM(VRFR22) PARM(&XDATE &REC1 &REC2)
             CHGVAR     VAR(&OK  ) VALUE('Y')
             ENDDO

 /* VRFR23 - JYUPPML */
             IF         (&XFILE *EQ 'JYUPPML') THEN(DO)
         /** DLTF       FILE(&TO/JYUPPMLSV )                        **/
         /** MONMSG     MSGID(CPF3261 CPF2105)                      **/
         /** CPYF       FROMFILE(&FROM/JYUPPML) +                   **/
         /**              TOFILE(&TO/JYUPPMLSV) MBROPT(*REPLACE) +  **/
         /**              CRTFILE(*YES) FMTOPT(*NOCHK)              **/
             OVRDBF     FILE(JYUPPML)  TOFILE(&FROM/JYUPPML)
             OVRDBF     FILE(JYUPPMLB) TOFILE(&TO/JYUPPMLB )
             CALL       PGM(VRFR23) PARM(&XDATE &REC1 &REC2)
             CHGVAR     VAR(&OK  ) VALUE('Y')
             ENDDO

 /* VRFR24 - ALDPP25 */
             IF         (&XFILE *EQ 'ALDPP25') THEN(DO)
         /** DLTF       FILE(&TO/ALDPP25SV )                        **/
         /** MONMSG     MSGID(CPF3261 CPF2105)                      **/
         /** CPYF       FROMFILE(&FROM/ALDPP25) +                   **/
         /**              TOFILE(&TO/ALDPP25SV) MBROPT(*REPLACE) +  **/
         /**              CRTFILE(*YES) FMTOPT(*NOCHK)              **/
             OVRDBF     FILE(ALDPL28)  TOFILE(&FROM/ALDPL28)
             OVRDBF     FILE(ALDPP25B) TOFILE(&TO/ALDPP25B )
             CALL       PGM(VRFR24) PARM(&XDATE &REC1 &REC2)
             CHGVAR     VAR(&OK  ) VALUE('Y')
             ENDDO

 /* VRFR25 - AU#PP11 */
             IF         (&XFILE *EQ 'AU#PP11') THEN(DO)
         /** DLTF       FILE(&TO/AU#PP11SV )                        **/
         /** MONMSG     MSGID(CPF3261 CPF2105)                      **/
         /** CPYF       FROMFILE(&FROM/AU#PP11) +                   **/
         /**              TOFILE(&TO/AU#PP11SV) MBROPT(*REPLACE) +  **/
         /**              CRTFILE(*YES) FMTOPT(*NOCHK)              **/
             OVRDBF     FILE(AU#PP11)  TOFILE(&FROM/AU#PP11)
             OVRDBF     FILE(AU#PP11B) TOFILE(&TO/AU#PP11B )
             CALL       PGM(VRFR25) PARM(&XDATE &REC1 &REC2)
             CHGVAR     VAR(&OK  ) VALUE('Y')
             ENDDO

 /* VRFR26 - AU#PP21 */
             IF         (&XFILE *EQ 'AU#PP21') THEN(DO)
         /** DLTF       FILE(&TO/AU#PP21SV )                        **/
         /** MONMSG     MSGID(CPF3261 CPF2105)                      **/
         /** CPYF       FROMFILE(&FROM/AU#PP21) +                   **/
         /**              TOFILE(&TO/AU#PP21SV) MBROPT(*REPLACE) +  **/
         /**              CRTFILE(*YES) FMTOPT(*NOCHK)              **/
             OVRDBF     FILE(AU#PL25)  TOFILE(&FROM/AU#PL25)
             OVRDBF     FILE(AU#PP21B) TOFILE(&TO/AU#PP21B )
             CALL       PGM(VRFR26) PARM(&XDATE &REC1 &REC2)
             CHGVAR     VAR(&OK  ) VALUE('Y')
             ENDDO

 /* VRFR27 - ALDPP30 */
             IF         (&XFILE *EQ 'ALDPP30') THEN(DO)
         /** DLTF       FILE(&TO/ALDPP30SV )                        **/
         /** MONMSG     MSGID(CPF3261 CPF2105)                      **/
         /** CPYF       FROMFILE(&FROM/ALDPP30) +                   **/
         /**              TOFILE(&TO/ALDPP30SV) MBROPT(*REPLACE) +  **/
         /**              CRTFILE(*YES) FMTOPT(*NOCHK)              **/
             OVRDBF     FILE(ALDPL3A)  TOFILE(&FROM/ALDPL3A)
             OVRDBF     FILE(ALDPP30B) TOFILE(&TO/ALDPP30B )
             CALL       PGM(VRFR27) PARM(&XDATE &REC1 &REC2)
             CHGVAR     VAR(&OK  ) VALUE('Y')
             ENDDO

 /* VRFR28 - NZUPP01 */
             IF         (&XFILE *EQ 'NZUPP01') THEN(DO)
         /** DLTF       FILE(&TO/NZUPP01SV )                        **/
         /** MONMSG     MSGID(CPF3261 CPF2105)                      **/
         /** CPYF       FROMFILE(&FROM/NZUPP01) +                   **/
         /**              TOFILE(&TO/NZUPP01SV) MBROPT(*REPLACE) +  **/
         /**              CRTFILE(*YES) FMTOPT(*NOCHK)              **/
             OVRDBF     FILE(NZUPL04)  TOFILE(&FROM/NZUPL04)
             OVRDBF     FILE(NZUPP01B) TOFILE(&TO/NZUPP01B )
             CALL       PGM(VRFR28) PARM(&XDATE &REC1 &REC2)
             CHGVAR     VAR(&OK  ) VALUE('Y')
             ENDDO

 /* VRFR29 - AB#PP66 */
             IF         (&XFILE *EQ 'AB#PP66') THEN(DO)
         /** DLTF       FILE(&TO/AB#PP66SV )                        **/
         /** MONMSG     MSGID(CPF3261 CPF2105)                      **/
         /** CPYF       FROMFILE(&FROM/AB#PP66) +                   **/
         /**              TOFILE(&TO/AB#PP66SV) MBROPT(*REPLACE) +  **/
         /**              CRTFILE(*YES) FMTOPT(*NOCHK)              **/
             OVRDBF     FILE(AB#PL68)  TOFILE(&FROM/AB#PL68)
             OVRDBF     FILE(AB#PP66B) TOFILE(&TO/AB#PP66B )
             CALL       PGM(VRFR29) PARM(&XDATE &REC1 &REC2)
             CHGVAR     VAR(&OK  ) VALUE('Y')
             ENDDO

 /* VRFR30 - AB#HP10 */
             IF         (&XFILE *EQ 'AB#HP10') THEN(DO)
         /** DLTF       FILE(&TO/AB#HP10SV )                        **/
         /** MONMSG     MSGID(CPF3261 CPF2105)                      **/
         /** CPYF       FROMFILE(&FROM/AB#HP10) +                   **/
         /**              TOFILE(&TO/AB#HP10SV) MBROPT(*REPLACE) +  **/
         /**              CRTFILE(*YES) FMTOPT(*NOCHK)              **/
             OVRDBF     FILE(AB#HL10)  TOFILE(&FROM/AB#HL10)
             OVRDBF     FILE(AB#HP10B) TOFILE(&TO/AB#HP10B )
             CALL       PGM(VRFR30) PARM(&XDATE &REC1 &REC2)
             CHGVAR     VAR(&OK  ) VALUE('Y')
             ENDDO

 /* VRFR31 - AL#PP01 */
             IF         (&XFILE *EQ 'AL#PP01') THEN(DO)
         /** DLTF       FILE(&TO/AL#PP01SV )                        **/
         /** MONMSG     MSGID(CPF3261 CPF2105)                      **/
         /** CPYF       FROMFILE(&FROM/AL#PP01) +                   **/
         /**              TOFILE(&TO/AL#PP01SV) MBROPT(*REPLACE) +  **/
         /**              CRTFILE(*YES) FMTOPT(*NOCHK)              **/
             OVRDBF     FILE(AL#PL01)  TOFILE(&FROM/AL#PL01)
             OVRDBF     FILE(AL#PP01B) TOFILE(&TO/AL#PP01B )
             CALL       PGM(VRFR31) PARM(&XDATE &REC1 &REC2)
             CHGVAR     VAR(&OK  ) VALUE('Y')
             ENDDO

 /* VRFR32 - AL#PP01 */
             IF         (&XFILE *EQ 'AL#PPA1') THEN(DO)
         /** DLTF       FILE(&TO/AL#PPA1SV )                        **/
         /** MONMSG     MSGID(CPF3261 CPF2105)                      **/
         /** CPYF       FROMFILE(&FROM/AL#PPA1) +                   **/
         /**              TOFILE(&TO/AL#PPA1SV) MBROPT(*REPLACE) +  **/
         /**              CRTFILE(*YES) FMTOPT(*NOCHK)              **/
             OVRDBF     FILE(AL#PLA1)  TOFILE(&FROM/AL#PLA1)
             OVRDBF     FILE(AL#PPA1B) TOFILE(&TO/AL#PPA1B )
             CALL       PGM(VRFR32) PARM(&XDATE &REC1 &REC2)
             CHGVAR     VAR(&OK  ) VALUE('Y')
             ENDDO

 /* VRFR33 - ECSPP80 */
             IF         (&XFILE *EQ 'ECSPP80') THEN(DO)
         /** DLTF       FILE(&TO/ECSPP80SV )                        **/
         /** MONMSG     MSGID(CPF3261 CPF2105)                      **/
         /** CPYF       FROMFILE(&FROM/ECSPP80) +                   **/
         /**              TOFILE(&TO/ECSPP80SV) MBROPT(*REPLACE) +  **/
         /**              CRTFILE(*YES) FMTOPT(*NOCHK)              **/
             OVRDBF     FILE(ECSPL84)  TOFILE(&FROM/ECSPL84)
             OVRDBF     FILE(ECSPP80B) TOFILE(&TO/ECSPP80B )
             CALL       PGM(VRFR33) PARM(&XDATE &REC1 &REC2)
             CHGVAR     VAR(&OK  ) VALUE('Y')
             ENDDO

 /* VRFR34 - ALCPP01 */
             IF         (&XFILE *EQ 'ALCPP01') THEN(DO)
         /** DLTF       FILE(&TO/ALCPP01SV)                         **/
         /** MONMSG     MSGID(CPF3261 CPF2105)                      **/
         /** CPYF       FROMFILE(&FROM/ALCPP01) +                   **/
         /**              TOFILE(&TO/ALCPP01SV) MBROPT(*REPLACE) +  **/
         /**              CRTFILE(*YES) FMTOPT(*NOCHK)              **/
             OVRDBF     FILE(ALCPP01)  TOFILE(&FROM/ALCPP01)
             OVRDBF     FILE(ALCPP01B) TOFILE(&TO/ALCPP01B )
             CALL       PGM(VRFR34) PARM(&XDATE &REC1 &REC2)
             CHGVAR     VAR(&OK  ) VALUE('Y')
             ENDDO

 /* VRFR35 - JYUPPRL */
             IF         (&XFILE *EQ 'JYUPPRL') THEN(DO)
         /** DLTF       FILE(&TO/JYUPPRLSV)                         **/
         /** MONMSG     MSGID(CPF3261 CPF2105)                      **/
         /** CPYF       FROMFILE(&FROM/JYUPPRL) +                   **/
         /**              TOFILE(&TO/JYUPPRLSV) MBROPT(*REPLACE) +  **/
         /**              CRTFILE(*YES) FMTOPT(*NOCHK)              **/
             OVRDBF     FILE(JYUPPRL)  TOFILE(&FROM/JYUPPRL)
             OVRDBF     FILE(JYUPPRLB) TOFILE(&TO/JYUPPRLB )
             CALL       PGM(VRFR35) PARM(&XDATE &REC1 &REC2)
             CHGVAR     VAR(&OK  ) VALUE('Y')
             ENDDO

 /* VRFR36 - AB#EP40S */
             IF         (&XFILE *EQ 'AB#EP40S') THEN(DO)
         /** DLTF       FILE(&TO/AB#EP40SSV)                        **/
         /** MONMSG     MSGID(CPF3261 CPF2105)                      **/
         /** CPYF       FROMFILE(&FROM/AB#EP40S) +                  **/
         /**              TOFILE(&TO/AB#EP40SSV) MBROPT(*REPLACE) + **/
         /**              CRTFILE(*YES) FMTOPT(*NOCHK)              **/
             OVRDBF     FILE(AB#EP40S)  TOFILE(&FROM/AB#EP40S)
             OVRDBF     FILE(AB#EP40B)  TOFILE(&TO/AB#EP40B  )
             CALL       PGM(VRFR36) PARM(&XDATE &REC1 &REC2)
             CHGVAR     VAR(&OK  ) VALUE('Y')
             ENDDO

 /* VRFR37 - ADKPP01  */
             IF         (&XFILE *EQ 'ADKPP01 ') THEN(DO)
         /** DLTF       FILE(&TO/ADKPP01SV )                        **/
         /** MONMSG     MSGID(CPF3261 CPF2105)                      **/
         /** CPYF       FROMFILE(&FROM/ADKPP01) +                   **/
         /**              TOFILE(&TO/ADKPP01SV) MBROPT(*REPLACE) +  **/
         /**              CRTFILE(*YES) FMTOPT(*NOCHK)              **/
             OVRDBF     FILE(ADKPL02 )  TOFILE(&FROM/ADKPL02 )
             OVRDBF     FILE(ADKPP01B)  TOFILE(&TO/ADKPP01B  )
             CALL       PGM(VRFR37) PARM(&XDATE &REC1 &REC2)
             CHGVAR     VAR(&OK  ) VALUE('Y')
             ENDDO

 /* VRFR38 - KU#PP11  */
             IF         (&XFILE *EQ 'KU#PP11 ') THEN(DO)
         /** DLTF       FILE(&TO/KU#PP11SV )                        **/
         /** MONMSG     MSGID(CPF3261 CPF2105)                      **/
         /** CPYF       FROMFILE(&FROM/KU#PP11) +                   **/
         /**              TOFILE(&TO/KU#PP11SV) MBROPT(*REPLACE) +  **/
         /**              CRTFILE(*YES) FMTOPT(*NOCHK)              **/
             OVRDBF     FILE(KU#PL11 )  TOFILE(&FROM/KU#PL11 )
             OVRDBF     FILE(KU#PP11B)  TOFILE(&TO/KU#PP11B  )
             CALL       PGM(VRFR38) PARM(&XDATE &REC1 &REC2)
             CHGVAR     VAR(&OK  ) VALUE('Y')
             ENDDO

 /* VRFR39 - AB#PP70  */
             IF         (&XFILE *EQ 'AB#PP70 ') THEN(DO)
         /** DLTF       FILE(&TO/AB#PP70SV )                        **/
         /** MONMSG     MSGID(CPF3261 CPF2105)                      **/
         /** CPYF       FROMFILE(&FROM/AB#PP70) +                   **/
         /**              TOFILE(&TO/AB#PP70SV) MBROPT(*REPLACE) +  **/
         /**              CRTFILE(*YES) FMTOPT(*NOCHK)              **/
             OVRDBF     FILE(AB#PL73 )  TOFILE(&FROM/AB#PL73 )
             OVRDBF     FILE(AB#PP70B)  TOFILE(&TO/AB#PP70B  )
             CALL       PGM(VRFR39) PARM(&XDATE &REC1 &REC2)
             CHGVAR     VAR(&OK  ) VALUE('Y')
             ENDDO

 /* VRFR41 - AM#PP01  */
             IF         (&XFILE *EQ 'AM#PP01 ') THEN(DO)
         /** DLTF       FILE(&TO/AM#PP01SV )                        **/
         /** MONMSG     MSGID(CPF3261 CPF2105)                      **/
         /** CPYF       FROMFILE(&FROM/AM#PP01) +                   **/
         /**              TOFILE(&TO/AM#PP01SV) MBROPT(*REPLACE) +  **/
         /**              CRTFILE(*YES) FMTOPT(*NOCHK)              **/
             OVRDBF     FILE(AM#PL06 )  TOFILE(&FROM/AM#PL06 )
             OVRDBF     FILE(AM#PP01B)  TOFILE(&TO/AM#PP01B  )
             CALL       PGM(VRFR41) PARM(&XDATE &REC1 &REC2)
             CHGVAR     VAR(&OK  ) VALUE('Y')
             ENDDO

 /* VRFR42 - AM#PP01  */
             IF         (&XFILE *EQ 'ADKPP21 ') THEN(DO)
         /** DLTF       FILE(&TO/ADKPP21SV )                        **/
         /** MONMSG     MSGID(CPF3261 CPF2105)                      **/
         /** CPYF       FROMFILE(&FROM/ADKPP21) +                   **/
         /**              TOFILE(&TO/ADKPP21SV) MBROPT(*REPLACE) +  **/
         /**              CRTFILE(*YES) FMTOPT(*NOCHK)              **/
             OVRDBF     FILE(ADKPL21 )  TOFILE(&FROM/ADKPL21 )
             OVRDBF     FILE(ADKPP21B)  TOFILE(&TO/ADKPP21B  )
             CALL       PGM(VRFR42) PARM(&XDATE &REC1 &REC2)
             CHGVAR     VAR(&OK  ) VALUE('Y')
             ENDDO

 /* VRFR43 - ALDPP65  */
             IF         (&XFILE *EQ 'ALDPP65 ') THEN(DO)
         /** DLTF       FILE(&TO/ALDPP65SV )                        **/
         /** MONMSG     MSGID(CPF3261 CPF2105)                      **/
         /** CPYF       FROMFILE(&FROM/ALDPP65) +                   **/
         /**              TOFILE(&TO/ALDPP65SV) MBROPT(*REPLACE) +  **/
         /**              CRTFILE(*YES) FMTOPT(*NOCHK)              **/
             OVRDBF     FILE(ALDPL67 )  TOFILE(&FROM/ALDPL67 )
             OVRDBF     FILE(ALDPP65B)  TOFILE(&TO/ALDPP65B  )
             CALL       PGM(VRFR43) PARM(&XDATE &REC1 &REC2)
             CHGVAR     VAR(&OK  ) VALUE('Y')
             ENDDO

 /* VRFR44 - STAPP10/STAPP20) */
             IF         (&XFILE *EQ 'STAPP10 ') THEN(DO)
         /** DLTF       FILE(&TO/STAPP10SV )                        **/
         /** MONMSG     MSGID(CPF3261 CPF2105)                      **/
         /** CPYF       FROMFILE(&FROM/STAPP10) +                   **/
         /**              TOFILE(&TO/STAPP10SV) MBROPT(*REPLACE) +  **/
         /**              CRTFILE(*YES) FMTOPT(*NOCHK)              **/
             DLTF       FILE(&TO/STAPP20SV )
             MONMSG     MSGID(CPF3261 CPF2105)
             CPYF       FROMFILE(&FROM/STAPP20) +
                          TOFILE(&TO/STAPP20SV) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*NOCHK)
             OVRDBF     FILE(STAPP10 )  TOFILE(&FROM/STAPP10 )
             OVRDBF     FILE(STAPP20 )  TOFILE(&FROM/STAPP20 )
             CALL       PGM(VRFR44) PARM(&XDATE &REC1 &REC2)
             CHGVAR     VAR(&OK  ) VALUE('Y')
             ENDDO

 /* VRFR45 - AB#EP71S */
             IF         (&XFILE *EQ 'AB#EP71S') THEN(DO)
         /** DLTF       FILE(&TO/AB#EP71SSV)                        **/
         /** MONMSG     MSGID(CPF3261 CPF2105)                      **/
         /** CPYF       FROMFILE(&FROM/AB#EP71S) +                  **/
         /**              TOFILE(&TO/AB#EP71SSV) MBROPT(*REPLACE) + **/
         /**              CRTFILE(*YES) FMTOPT(*NOCHK)              **/
             OVRDBF     FILE(AB#EL71S)  TOFILE(&FROM/AB#EL71S)
             OVRDBF     FILE(AB#EP71B)  TOFILE(&TO/AB#EP71B  )
             CALL       PGM(VRFR45) PARM(&XDATE &REC1 &REC2)
             CHGVAR     VAR(&OK  ) VALUE('Y')
             ENDDO

 /* VRFR46 - ABAEP20S */
             IF         (&XFILE *EQ 'ABAEP20S') THEN(DO)
         /** DLTF       FILE(&TO/ABAEP20SSV)                        **/
         /** MONMSG     MSGID(CPF3261 CPF2105)                      **/
         /** CPYF       FROMFILE(&FROM/ABAEP20S) +                  **/
         /**              TOFILE(&TO/ABAEP20SSV) MBROPT(*REPLACE) + **/
         /**              CRTFILE(*YES) FMTOPT(*NOCHK)              **/
             OVRDBF     FILE(ABAEL20S)  TOFILE(&FROM/ABAEL20S)
             OVRDBF     FILE(ABAEP20B)  TOFILE(&TO/ABAEP20B  )
             CALL       PGM(VRFR46) PARM(&XDATE &REC1 &REC2)
             CHGVAR     VAR(&OK  ) VALUE('Y')
             ENDDO

 /* VRFR47 - AB#EP50S */
             IF         (&XFILE *EQ 'AB#EP50S') THEN(DO)
         /** DLTF       FILE(&TO/AB#EP50SSV)                        **/
         /** MONMSG     MSGID(CPF3261 CPF2105)                      **/
         /** CPYF       FROMFILE(&FROM/AB#EP50S) +                  **/
         /**              TOFILE(&TO/AB#EP50SSV) MBROPT(*REPLACE) + **/
         /**              CRTFILE(*YES) FMTOPT(*NOCHK)              **/
             OVRDBF     FILE(AB#EL51S)  TOFILE(&FROM/AB#EL51S)
             OVRDBF     FILE(AB#EP50B)  TOFILE(&TO/AB#EP50B  )
             CALL       PGM(VRFR47) PARM(&XDATE &REC1 &REC2)
             CHGVAR     VAR(&OK  ) VALUE('Y')
             ENDDO

 /* VRFR48 - AB#PP6A  */
             IF         (&XFILE *EQ 'AB#PP6A ') THEN(DO)
         /** DLTF       FILE(&TO/AB#EP50SSV)                        **/
         /** MONMSG     MSGID(CPF3261 CPF2105)                      **/
         /** CPYF       FROMFILE(&FROM/AB#PP6A ) +                  **/
         /**              TOFILE(&TO/AB#PP6ASV ) MBROPT(*REPLACE) + **/
         /**              CRTFILE(*YES) FMTOPT(*NOCHK)              **/
             CHKOBJ     OBJ(&TO/AB#PP6AB) OBJTYPE(*FILE)

             OVRDBF     FILE(AB#PL6B )  TOFILE(&FROM/AB#PL6B )
             OVRDBF     FILE(AB#PP6AB)  TOFILE(&TO/AB#PP6AB  )
             CALL       PGM(VRFR48) PARM(&XDATE &REC1 &REC2)
             CHGVAR     VAR(&OK  ) VALUE('Y')
             ENDDO

 /* VRFR50 - ABF6P01  */
             IF         (&XFILE *EQ 'ABF6P01 ') THEN(DO)
             OVRDBF     FILE(ABF6L02 )  TOFILE(&FROM/ABF6L02 )
             OVRDBF     FILE(ABF6P01B) TOFILE(&TO/ABF6P01B )
             CALL       PGM(VRFR50) PARM(&XDATE &REC1 &REC2)
             CHGVAR     VAR(&OK  ) VALUE('Y')
             ENDDO

 /* VRFR51 - AB#PP2B  */
             IF         (&XFILE *EQ 'AB#PP2B ') THEN(DO)
             OVRDBF     FILE(AB#PL2B1)  TOFILE(&FROM/AB#PL2B1)
             OVRDBF     FILE(AB#PP2BB) TOFILE(&TO/AB#PP2BB )
             CALL       PGM(VRFR51) PARM(&XDATE &REC1 &REC2)
             CHGVAR     VAR(&OK  ) VALUE('Y')
             ENDDO

 /* VRFR52 - AB#PP2FB */
             IF         (&XFILE *EQ 'AB#PP2F ') THEN(DO)
             OVRDBF     FILE(AB#PL2F1)  TOFILE(&FROM/AB#PL2F1)
             OVRDBF     FILE(AB#PP2FB) TOFILE(&TO/AB#PP2FB )
             CALL       PGM(VRFR52) PARM(&XDATE &REC1 &REC2)
             CHGVAR     VAR(&OK  ) VALUE('Y')
             ENDDO

 /* VRFR53 - AB#PP65  */
             IF         (&XFILE *EQ 'AB#PP65 ') THEN(DO)
             OVRDBF     FILE(AB#PL65C)  TOFILE(&FROM/AB#PL65C)
             OVRDBF     FILE(AB#PP65B)    TOFILE(&TO/AB#PP65B )
             CALL       PGM(VRFR53) PARM(&XDATE &REC1 &REC2)
             CHGVAR     VAR(&OK  ) VALUE('Y')
             ENDDO

 /* VRFR54 - NZTPP09  */
             IF         (&XFILE *EQ 'NZTPP09 ') THEN(DO)
             OVRDBF     FILE(NZTPP09 )  TOFILE(&FROM/NZTPP09 )
             OVRDBF     FILE(NZTPP09B)    TOFILE(&TO/NZTPP09B )
             CALL       PGM(VRFR54) PARM(&XDATE &REC1 &REC2)
             CHGVAR     VAR(&OK  ) VALUE('Y')
             ENDDO

 /* VRFR55 - ABBPP50  */
             IF         (&XFILE *EQ 'ABBPP50 ') THEN(DO)
             OVRDBF     FILE(ABBPL50B)  TOFILE(&FROM/ABBPL50B)
             OVRDBF     FILE(ABBPP50B)  TOFILE(&TO/ABBPP50B )
             CALL       PGM(VRFR55) PARM(&XDATE &REC1 &REC2)
             CHGVAR     VAR(&OK  ) VALUE('Y')
             ENDDO

             /**********/

 /* VXFR01 - AB#PPF1  */
             IF         (&XFILE *EQ 'AB#PPF1 ') THEN(DO)
             OVRDBF     FILE(AB#PLF1 )  TOFILE(&FROM/AB#PLF1 )
             CALL       PGM(VXFR01) PARM(&XDATE &REC1 &REC2)
             CHGVAR     VAR(&OK  ) VALUE('Y')
             ENDDO

 /* VXFR02 - AB#HP20  */
             IF         (&XFILE *EQ 'AB#HP20 ') THEN(DO)
             OVRDBF     FILE(AB#HL20A)  TOFILE(&FROM/AB#HL20A)
             CALL       PGM(VXFR02) PARM(&XDATE &REC1 &REC2)
             CHGVAR     VAR(&OK  ) VALUE('Y')
             ENDDO

 /* CHECK OK?  */
             IF         (&OK *EQ 'N') THEN(DO)
             CHGVAR     VAR(&IN41) VALUE('1')
             CHGVAR     VAR(&XMSG) VALUE('ERR: Register The Process +
                          in Refprmat PGM (UTLC20)!')
             GOTO       STP1
             ENDDO

 /* WRITE LOG */
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&WSTM)
             CALL       PGM(VJBR64) PARM(&XFILE &XDATE &WKTM &WSTM +
                          &REC1 &REC2)
 /* REORGANIZE */
        /*   RGZPFM     FILE(&FROM/&XFILE)    */
        /*   MONMSG     MSGID(CPF0000)        */

             DLTOVR     FILE(*ALL)
ENDPGM:
             ENDPGM
