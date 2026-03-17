             PGM
 /** AB#C0Q ****************************************************/
 /*  COPY TO EDI(856) DATA - HONDA                             */
 /*  HONDA                                                     */
 /*  JW1 2016.06.09                                            */
 /**************************************************************/
 /* AB#EP59 */
             CPYF       FROMFILE(HWFILE1/AB#EP59C) +
                          TOFILE(HFILE1/AB#EP59) MBROPT(*ADD) +
                          FMTOPT(*MAP *DROP)
 /* AB#EP67 */
             CPYF       FROMFILE(HWFILE1/AB#EP67C) +
                          TOFILE(HFILE1/AB#EP67) MBROPT(*ADD) +
                          FMTOPT(*MAP *DROP)
 /* AB#EP68 */
             CPYF       FROMFILE(HWFILE1/AB#EP68C) +
                          TOFILE(HFILE1/AB#EP68) MBROPT(*ADD) +
                          FMTOPT(*MAP *DROP)
 /* AB#EP69 */
             CPYF       FROMFILE(HWFILE1/AB#EP69C) +
                          TOFILE(HFILE1/AB#EP69) MBROPT(*ADD) +
                          FMTOPT(*MAP *DROP)

             ENDPGM
