PGM

             CLRPFM     FILE(TSKWP03)

             /*テーブルを作成１*/
             /* GCQPP11 -> TSKWP03 */
             CALL       PGM(TSKR03)

             /*テーブルを作成２*/
             /* ECSPL08 -> TSKWP03 */
             CALL       PGM(TSKR05)

             /*テーブルに値をセット*/
             /* ECSPL05 -> TSKWP03 */
             CALL       PGM(TSKR04)








ENDPGM
