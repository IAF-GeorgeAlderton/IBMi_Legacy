             PGM
             /** VJBC80 ***************************************************/
             /*  SAVE PROGRAM SOURCE HSRC1 --> HSRC1YYYYX                 */
             /*  J.WATANABE  2021.06.04                                   */
             /*************************************************************/
             DCL        VAR(&FR)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&TO)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&AL)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&MB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&RE)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&CR)  TYPE(*CHAR) LEN(4)
             DCL        VAR(&NC)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(1)

             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PGM ) TYPE(*CHAR) LEN(10)

             CHGVAR     VAR(&PGM) VALUE('VJBC80  ')

             CHGVAR     VAR(&FR)  VALUE('HSRC1   ')
             CHGVAR     VAR(&TO)  VALUE('HSRC12021A')
             CHGVAR     VAR(&AL)  VALUE('*ALL    ')
             CHGVAR     VAR(&MB)  VALUE('*FROMMBR')
             CHGVAR     VAR(&RE)  VALUE('*REPLACE')
             CHGVAR     VAR(&CR)  VALUE('*YES')
             CHGVAR     VAR(&NC)  VALUE('*NOCHK  ')
 /* CL */
       CPYF &FR/ACLSRC   &TO/ACLSRC  &AL &MB &RE CRTFILE(&CR) FMTOPT(&NC)
 /* RPG */
       CPYF &FR/ARPGSRC   &TO/ARPGSRC   &AL &MB &RE CRTFILE(&CR) FMTOPT(&NC)
 /* DDS */
       CPYF &FR/ADDSSRC   &TO/ADDSSRC   &AL &MB &RE CRTFILE(&CR) FMTOPT(&NC)
 /* DSP */
       CPYF &FR/ADSPSRC   &TO/ADSPSRC   &AL &MB &RE CRTFILE(&CR) FMTOPT(&NC)
 /* PRT */
       CPYF &FR/APRTSRC   &TO/APRTSRC   &AL &MB &RE CRTFILE(&CR) FMTOPT(&NC)

             ENDPGM
