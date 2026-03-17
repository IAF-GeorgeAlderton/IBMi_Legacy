             PGM
 /** AC#C0Q ****************************************************/
 /*  CREATE CANCEL EDI(856) DATA BY ASN# (HONDA)               */
 /*  HONDA                                                     */
 /*  JW1 2016.06.13                                            */
 /**************************************************************/

             DCL        VAR(&ASN)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&RTN)  TYPE(*CHAR) LEN(1)

             DCL        VAR(&WSID)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PDEVT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PIGCD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WLIB)  TYPE(*CHAR) LEN(8)
             DCL        VAR(&PRT)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRTG)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&TYPE)  TYPE(*CHAR) LEN(1)

             RTVJOBA    JOB(&WSID) USER(&USER)
             CALL       PGM(AGAR01) PARM(&WSID &PDEVT &PIGCD)
             CALL       PGM(AGAR00) PARM(&WSID &PRT &TYPE &PRTG)
             CALL       PGM(ALBC00) PARM(&USER &WLIB)

       /*    CHGVAR     VAR(*LIBL) VALUE('HFILE1')    */
       /*    CHGVAR     VAR(&WLIB) VALUE('HWFILE1')   */

 /* CLEAR WORK FILE */
             CLRPFM     FILE(*LIBL/AB#EP59C)
             CLRPFM     FILE(*LIBL/AB#EP67C)
             CLRPFM     FILE(*LIBL/AB#EP68C)
             CLRPFM     FILE(*LIBL/AB#EP69C)

 /* OVRER DBF */
             OVRDBF     FILE(AB#EP59S) TOFILE(*LIBL/AB#EP59S )
             OVRDBF     FILE(AB#EP67S) TOFILE(*LIBL/AB#EP67S )
             OVRDBF     FILE(AB#EP68S) TOFILE(*LIBL/AB#EP68S )
             OVRDBF     FILE(AB#EP69S) TOFILE(*LIBL/AB#EP69S )

 /* CALL    */
             OVRDBF     FILE(AB#EP59C) TOFILE(*LIBL/AB#EP59C )
             OVRDBF     FILE(AB#EP67C) TOFILE(*LIBL/AB#EP67C )
             OVRDBF     FILE(AB#EP68C) TOFILE(*LIBL/AB#EP68C )
             OVRDBF     FILE(AB#EP69C) TOFILE(*LIBL/AB#EP69C )

             CALL       AC#R0Q (&ASN &RTN)

             IF         COND(&RTN *EQ ' ') THEN(DO)
 /* AB#EP59 */
             CPYF       FROMFILE(*LIBL/AB#EP59C) +
                          TOFILE(*LIBL/AB#EP59) MBROPT(*ADD) +
                          FMTOPT(*MAP *DROP)
 /* AB#EP67 */
             CPYF       FROMFILE(*LIBL/AB#EP67C) +
                          TOFILE(*LIBL/AB#EP67) MBROPT(*ADD) +
                          FMTOPT(*MAP *DROP)
 /* AB#EP68 */
             CPYF       FROMFILE(*LIBL/AB#EP68C) +
                          TOFILE(*LIBL/AB#EP68) MBROPT(*ADD) +
                          FMTOPT(*MAP *DROP)
 /* AB#EP69 */
             CPYF       FROMFILE(*LIBL/AB#EP69C) +
                          TOFILE(*LIBL/AB#EP69) MBROPT(*ADD) +
                          FMTOPT(*MAP *DROP)

 /* SAVE EP59,67,68,69 FILE */
             CALL       PGM(EDSR6H)

             ENDDO

             ENDPGM
