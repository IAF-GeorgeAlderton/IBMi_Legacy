             PGM
 /** AC#C0Q ****************************************************/
 /*  CREATE CANCEL EDI(856) DATA BY ASN# (HONDA)               */
 /*  HONDA                                                     */
 /*  JW1 2016.06.13                                            */
 /**************************************************************/

             DCL        VAR(&ASN)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(10)

             CHGVAR     VAR(&PLIB) VALUE('HFILE1')
             CHGVAR     VAR(&WLIB) VALUE('HWFILE1')

 /* CLEAR WORK FILE */
             CLRPFM     FILE(&WLIB/AB#EP59C)
             CLRPFM     FILE(&WLIB/AB#EP67C)
             CLRPFM     FILE(&WLIB/AB#EP68C)
             CLRPFM     FILE(&WLIB/AB#EP69C)

 /* CALL    */
             OVRDBF     FILE(AB#EP59C) TOFILE(&WLIB/AB#EP59C )
             OVRDBF     FILE(AB#EP67C) TOFILE(&WLIB/AB#EP67C )
             OVRDBF     FILE(AB#EP68C) TOFILE(&WLIB/AB#EP68C )
             OVRDBF     FILE(AB#EP69C) TOFILE(&WLIB/AB#EP69C )
             CALL       AC#R0Q (&ASN &RTN)

             ENDPGM
