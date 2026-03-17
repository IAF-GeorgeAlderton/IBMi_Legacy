             PGM
             /** T#TC10 ************************/
             /* SETTING # INQUERY(MACHINE GROUP*/
             /************************ TRNC01 **/

             CLRPFM     FILE(T#TWP10)
             CLRPFM     FILE(T#TWP11)

           /*ABHPP01 -> T#TWP10 */
             CALL       PGM(T#TR10)
           /*T#TWP10 -> T#TWP11 */
             CALL       PGM(T#TR11)

             CALL       PGM(T#TR12)




             ENDPGM
