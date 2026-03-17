             PGM

             DCL        VAR(&PLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WLIB) TYPE(*CHAR) LEN(10)

             CHGVAR     VAR(&PLIB) VALUE('HFILE1')
             CHGVAR     VAR(&WLIB) VALUE('HWFILE1')
 /* AB#EP59 */
             CPYF       FROMFILE(&WLIB/AB#EP59C) +
                          TOFILE(&PLIB/AB#EP59) MBROPT(*ADD) +
                          FMTOPT(*MAP *DROP)
 /* AB#EP67 */
             CPYF       FROMFILE(&WLIB/AB#EP67C) +
                          TOFILE(&PLIB/AB#EP67) MBROPT(*ADD) +
                          FMTOPT(*MAP *DROP)
 /* AB#EP68 */
             CPYF       FROMFILE(&WLIB/AB#EP68C) +
                          TOFILE(&PLIB/AB#EP68) MBROPT(*ADD) +
                          FMTOPT(*MAP *DROP)
 /* AB#EP69 */
             CPYF       FROMFILE(&WLIB/AB#EP69C) +
                          TOFILE(&PLIB/AB#EP69) MBROPT(*ADD) +
                          FMTOPT(*MAP *DROP)

             ENDPGM
