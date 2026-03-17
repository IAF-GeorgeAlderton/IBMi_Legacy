             PGM
 /** AB#C0Q1 ***************************************************/
 /*  EXTRACT EDI(856) DATA - HONDA                             */
 /*  HONDA                                                     */
 /*  JW1 2016.06.09                                            */
 /**************************************************************/
             DCL        VAR(&TIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&ASN)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&SHID) TYPE(*CHAR) LEN(10)

             CHGVAR     VAR(&TIME) VALUE('083641')
             CHGVAR     VAR(&ASN)  VALUE('00043861')
             CHGVAR     VAR(&SHID) VALUE('1606000125')

             CLRPFM     FILE(HWFILE1/AB#EP59C)
             CLRPFM     FILE(HWFILE1/AB#EP67C)
             CLRPFM     FILE(HWFILE1/AB#EP68C)
             CLRPFM     FILE(HWFILE1/AB#EP69C)

             CLRPFM     FILE(HWFILE1/AB#EP59D)
             CLRPFM     FILE(HWFILE1/AB#EP67D)
             CLRPFM     FILE(HWFILE1/AB#EP68D)
             CLRPFM     FILE(HWFILE1/AB#EP69D)
 /* AB#EP59 */
             CPYF       FROMFILE(HFILE1/AB#EP59SS) +
                          TOFILE(HWFILE1/AB#EP59D) MBROPT(*REPLACE) +
                          INCCHAR(*RCD 174 *EQ &TIME) +
                          FMTOPT(*MAP *DROP)
             CPYF       FROMFILE(HWFILE1/AB#EP59D) +
                          TOFILE(HWFILE1/AB#EP59C) MBROPT(*REPLACE) +
                          INCCHAR(*RCD 1 *EQ &SHID) +
                          FMTOPT(*MAP *DROP)
 /* AB#EP67 */
             CPYF       FROMFILE(HFILE1/AB#EP67SS) +
                          TOFILE(HWFILE1/AB#EP67D) MBROPT(*ADD) +
                          INCCHAR(*RCD 79 *EQ &TIME) FMTOPT(*MAP +
                          *DROP)
             CPYF       FROMFILE(HWFILE1/AB#EP67D) +
                          TOFILE(HWFILE1/AB#EP67C) MBROPT(*ADD) +
                          INCCHAR(*RCD 1 *EQ &SHID) +
                          FMTOPT(*MAP *DROP)
 /* AB#EP68 */
             CPYF       FROMFILE(HFILE1/AB#EP68SS) +
                          TOFILE(HWFILE1/AB#EP68D) MBROPT(*ADD) +
                          INCCHAR(*RCD 304 *EQ &TIME) +
                          FMTOPT(*MAP *DROP)
             CPYF       FROMFILE(HWFILE1/AB#EP68D) +
                          TOFILE(HWFILE1/AB#EP68C) MBROPT(*ADD) +
                          INCCHAR(*RCD 1 *EQ &SHID) +
                          FMTOPT(*MAP *DROP)
 /* AB#EP69 */
             CPYF       FROMFILE(HFILE1/AB#EP69SS) +
                          TOFILE(HWFILE1/AB#EP69D) MBROPT(*ADD) +
                          INCCHAR(*RCD 106 *EQ &TIME) +
                          FMTOPT(*MAP *DROP)
             CPYF       FROMFILE(HWFILE1/AB#EP69D) +
                          TOFILE(HWFILE1/AB#EP69C) MBROPT(*ADD) +
                          INCCHAR(*RCD 1 *EQ &SHID) +
                          FMTOPT(*MAP *DROP)

             ENDPGM
