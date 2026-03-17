             PGM
             /** UTLC63A *****************************************/
             /*  UTILITY- REORGANIZE TARGET FILE                 */
             /*  J.WATANABE    2022.12.01                        */
             /****************************************************/
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(1)
/* A01 */
             CALL UTLC63 ('GCQPP31' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/GCQPP31)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* A02 */
             CALL UTLC63 ('AH#PP11' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/AH#PP11)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* A03 */
             CALL UTLC63 ('FCEPP01' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/FCEPP01)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* A04 */
             CALL UTLC63 ('ABF2P01' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/ABF2P01)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* A05 */
             CALL UTLC63 ('AB#PP78' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/AB#PP78)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* A06 */
             CALL UTLC63 ('AB#PP50' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/AB#PP50)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* A07 */
             CALL UTLC63 ('AB#PP40' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/AB#PP40)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* A08 */
             CALL UTLC63 ('AB#PP41' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/AB#PP41)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* A09 */
             CALL UTLC63 ('AB#PP42' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/AB#PP42)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* A10 */
             CALL UTLC63 ('AB#PP43' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/AB#PP43)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* A11 */
             CALL UTLC63 ('AB#PP44' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/AB#PP44)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* A12 */
             CALL UTLC63 ('AB#PP47' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/AB#PP47)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* A13 */
             CALL UTLC63 ('AB#PP2C' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/AB#PP2C)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* A14 */
             CALL UTLC63 ('AB#PP6A' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/AB#PP6A)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* A15 */
             CALL UTLC63 ('GDGPP05' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/GDGPP05)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* A16 */
             CALL UTLC63 ('AB#EPRA' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/AB#EPRA)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* A17 */
             CALL UTLC63 ('AB#PP2A' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/AB#PP2A)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* A18 */
             CALL UTLC63 ('ABBPP70' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/ABBPP70)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* A19 */
             CALL UTLC63 ('AB#PP75' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/AB#PP75)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* A20 */
             CALL UTLC63 ('AB#PP7W' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/AB#PP7W)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* A21 */
             CALL UTLC63 ('AB#PP2B' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/AB#PP2B)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* A22 */
             CALL UTLC63 ('AB#PP2F' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/AB#PP2F)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* A23 */
             CALL UTLC63 ('AH#PP70' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/AH#PP70)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* A24 */
             CALL UTLC63 ('XX     ' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(ZMODLIB10/ZMLOG1P)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* A25 */
             CALL UTLC63 ('ABBPP80' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/ABBPP80)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* A26 */
             CALL UTLC63 ('AB#PP65' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/AB#PP65)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* A27 */
             CALL UTLC63 ('ABBPP90' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/ABBPP90)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* A28 */
             CALL UTLC63 ('ABBPP91' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/ABBPP91)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* A29 */
             CALL UTLC63 ('AB#WP0G' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HWFILE1/AB#WP0G)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* A30 */
             CALL UTLC63 ('INVPP40' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/INVPP40)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* A31 */
             CALL UTLC63 ('INVPP41' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HWFILE1/INVPP41)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* A32 */
             CALL UTLC63 ('ABBPP9A' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/ABBPP9A)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* A33 */
             CALL UTLC63 ('ABBPP9B' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/ABBPP9B)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* A34 */
             CALL UTLC63 ('ABBPP9C' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/ABBPP9C)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* A35 */
             CALL UTLC63 ('ALCPP01' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/ALCPP01)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* A36 */
             CALL UTLC63 ('MBDPP01' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/MBDPP01)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* A37 */
             CALL UTLC63 ('MBDPP11' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/MBDPP11)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* A38 */
             CALL UTLC63 ('AAHPP01' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/AAHPP01)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* A39 */
             CALL UTLC63 ('NZTPP09' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/NZTPP09)
             MONMSG     MSGID(CPF0000)
             ENDDO

/* MONTHLY REFORMAT FILES *****************************/
   /* M01 */
             CALL UTLC63 ('AJVPPLG' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/AJVPPLG)
             MONMSG     MSGID(CPF0000)
             ENDDO
   /* M02 */
             CALL UTLC63 ('GDGPP02' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/GDGPP02)
             MONMSG     MSGID(CPF0000)
             ENDDO
   /* M03 */
             CALL UTLC63 ('JYUPPML' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/JYUPPML)
             MONMSG     MSGID(CPF0000)
             ENDDO
   /* M04 */
             CALL UTLC63 ('ALDPP25' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/ALDPP25)
             MONMSG     MSGID(CPF0000)
             ENDDO
   /* M05 */
             CALL UTLC63 ('AU#PP11' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/AU#PP11)
             MONMSG     MSGID(CPF0000)
             ENDDO
   /* M06 */
             CALL UTLC63 ('AU#PP21' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/AU#PP21)
             MONMSG     MSGID(CPF0000)
             ENDDO
   /* M07 */
             CALL UTLC63 ('ALDPP30' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/ALDPP30)
             MONMSG     MSGID(CPF0000)
             ENDDO
   /* M08 */
             CALL UTLC63 ('NZUPP01' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/NZUPP01)
             MONMSG     MSGID(CPF0000)
             ENDDO
   /* M09 */
             CALL UTLC63 ('AB#PP66' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/AB#PP66)
             MONMSG     MSGID(CPF0000)
             ENDDO
   /* M10 */
             CALL UTLC63 ('AB#HP10' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/AB#HP10)
             MONMSG     MSGID(CPF0000)
             ENDDO
   /* M11 */
             CALL UTLC63 ('AL#PP01' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/AL#PP01)
             MONMSG     MSGID(CPF0000)
             ENDDO
   /* M12 */
             CALL UTLC63 ('AL#PPA1' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/AL#PPA1)
             MONMSG     MSGID(CPF0000)
             ENDDO
   /* M13 */
             CALL UTLC63 ('ECSPP80' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/ECSPP80)
             MONMSG     MSGID(CPF0000)
             ENDDO
   /* M14 */
             CALL UTLC63 ('ALCPP01' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/ALCPP01)
             MONMSG     MSGID(CPF0000)
             ENDDO

   /* M15 */
             CALL UTLC63 ('JYUPPRL' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/JYUPPRL)
             MONMSG     MSGID(CPF0000)
             ENDDO

   /* M16 */
             CALL UTLC63 ('AB#EP40S' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/AB#EP40S)
             MONMSG     MSGID(CPF0000)
             ENDDO

   /* M17 */
             CALL UTLC63 ('ADKPP01 ' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/ADKPP01 )
             MONMSG     MSGID(CPF0000)
             ENDDO

   /* M18 */
             CALL UTLC63 ('KU#PP11 ' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/KU#PP11 )
             MONMSG     MSGID(CPF0000)
             ENDDO

   /* M19 */
             CALL UTLC63 ('AB#PP70 ' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/AB#PP70 )
             MONMSG     MSGID(CPF0000)
             ENDDO

   /* M20 */
             CALL UTLC63 ('AM#PP01 ' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/AM#PP01 )
             MONMSG     MSGID(CPF0000)
             ENDDO

   /* M21 */
             CALL UTLC63 ('ADKPP21 ' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/ADKPP21 )
             MONMSG     MSGID(CPF0000)
             ENDDO

   /* M22 */
             CALL UTLC63 ('ALDPP65 ' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/ALDPP65 )
             MONMSG     MSGID(CPF0000)
             ENDDO

   /* M23 */
             CALL UTLC63 ('STAPP10 ' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/STAPP10 )
             MONMSG     MSGID(CPF0000)
             ENDDO

   /* M23B EXCEPTION */
             CALL UTLC63 ('STAPP20 ' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/STAPP20 )
             MONMSG     MSGID(CPF0000)
             ENDDO

   /* M24 */
             CALL UTLC63 ('AB#EP71S' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/AB#EP71S)
             MONMSG     MSGID(CPF0000)
             ENDDO

   /* M25 */
             CALL UTLC63 ('ABAEP20S' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/ABAEP20S)
             MONMSG     MSGID(CPF0000)
             ENDDO

   /* M26 */
             CALL UTLC63 ('AB#EP50S' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/AB#EP50S)
             MONMSG     MSGID(CPF0000)
             ENDDO

   /* M27 */
             CALL UTLC63 ('AB#PP6A ' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/AB#PP6A )
             MONMSG     MSGID(CPF0000)
             ENDDO

   /* M28 */
             CALL UTLC63 ('ABF6P01 ' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/ABF6P01 )
             MONMSG     MSGID(CPF0000)
             ENDDO

   /* M29 */
             CALL UTLC63 ('AB#PP2B ' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/AB#PP2B )
             MONMSG     MSGID(CPF0000)
             ENDDO

   /* M30 */
             CALL UTLC63 ('AB#PP2F ' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/AB#PP2F )
             MONMSG     MSGID(CPF0000)
             ENDDO

   /* X01 */
             CALL UTLC63 ('AB#PPF1 ' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/AB#PPF1 )
             MONMSG     MSGID(CPF0000)
             ENDDO

/* REORGANIZE FILES */
/* B01 */
             CALL UTLC63 ('ABBPP50' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/ABBPP50)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* B02 */
             CALL UTLC63 ('FCCPP11' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/FCCPP11)
             MONMSG     MSGID(CPF0000)
             ENDDO
/* B03 */
             CALL UTLC63 ('GHCPP21' &RTN)
             IF         COND(&RTN = 'Y') THEN(DO)
             RGZPFM     FILE(HFILE1/GHCPP21)
             MONMSG     MSGID(CPF0000)
             ENDDO

/* REORGANIZE FORD FILES               */
/* JW6       CALL       PGM(AB#CF8)    */

ENDP:        ENDPGM
