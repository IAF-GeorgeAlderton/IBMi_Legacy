             PGM
             /***INVC16 ****************************************/
             /* INVENTORY -- CV MODULES --->  .CSV FILE        */
             /**************************************************/

             DCL        VAR(&CSVNAM) TYPE(*CHAR) LEN(30)
             DCL        VAR(&SYSTIM) TYPE(*CHAR) LEN(6)

      /*****************************************************************/
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&SYSTIM)
             CHGVAR     VAR(&CSVNAM) VALUE('MOD_INV_' *CAT &SYSTIM +
                          *TCAT '_')

      /*****************************************************************/
      /*  CLEAR MODULE INVENTORY WORK FILE - INVWP15                   */
             CLRPFM     FILE(INVWP15)
             MONMSG     MSGID(CPF0000)

      /*****************************************************************/
      /*  PURGE MODULE INVENTORY SAVE FILE - INVPP15S                  */
             CALL       PGM(APLR494)

      /*****************************************************************/
      /*  MOVE MODULE INVENTORY FILE TO WORKFILE  -  INVWP15           */
             CALL       PGM(INVR16)

      /*****************************************************************/
      /*  CREATE .CSV FILE AND WRITE TO IFS                            */
             CALL       PGM(APLC94) PARM('2' 'INVWP15' 'HWFILE1' +
                          &CSVNAM 'C' 'Y' 'Y')

      /*****************************************************************/
      /*  COPY TO CURRENT MODULE INVENTORY TO SAVE FILE                */
             CPYF       FROMFILE(INVPP15) TOFILE(INVPP15S) MBROPT(*ADD)

      /*****************************************************************/
      /*  CLEAR INVENTORY FILE                                         */
             CLRPFM     FILE(INVPP15)
             MONMSG     MSGID(CPF0000)

      /*****************************************************************/

             ENDPGM
