             PGM
             /** AB#C1J **********************************************/
             /*  CHECK OBJECT LOCK AND SEND NOTIFICATION             */
             /*       T.SAKAKI      2016.10.26                       */
             /********************************************** AB#C1J **/

             DLTF       FILE(HWFILE1/AB#WP1J)
             MONMSG     MSGID(CPF3261 CPF2105)
             DLTF       FILE(HWFILE1/AB#WP1J1)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTPF      FILE(HWFILE1/AB#WP1J) RCDLEN(256) IGCDTA(*YES)
             CRTPF      FILE(HWFILE1/AB#WP1J1) RCDLEN(80) IGCDTA(*YES)

             WRKOBJLCK  OBJ(HFILE1/AB#EP57) OBJTYPE(*FILE) MBR(*ALL) +
                          OUTPUT(*PRINT)
             CPYSPLF    FILE(QPDSPOLK) TOFILE(HWFILE1/AB#WP1J) +
                          SPLNBR(*LAST) MBROPT(*ADD)
             DLTSPLF    FILE(QPDSPOLK) SPLNBR(*LAST)

             WRKOBJLCK  OBJ(HFILE1/AB#EP59) OBJTYPE(*FILE) MBR(*ALL) +
                          OUTPUT(*PRINT)
             CPYSPLF    FILE(QPDSPOLK) TOFILE(HWFILE1/AB#WP1J) +
                          SPLNBR(*LAST) MBROPT(*ADD)
             DLTSPLF    FILE(QPDSPOLK) SPLNBR(*LAST)

             WRKOBJLCK  OBJ(HFILE1/AB#EP60) OBJTYPE(*FILE) MBR(*ALL) +
                          OUTPUT(*PRINT)
             CPYSPLF    FILE(QPDSPOLK) TOFILE(HWFILE1/AB#WP1J) +
                          SPLNBR(*LAST) MBROPT(*ADD)
             DLTSPLF    FILE(QPDSPOLK) SPLNBR(*LAST)

             WRKOBJLCK  OBJ(HFILE1/AB#EP66) OBJTYPE(*FILE) MBR(*ALL) +
                          OUTPUT(*PRINT)
             CPYSPLF    FILE(QPDSPOLK) TOFILE(HWFILE1/AB#WP1J) +
                          SPLNBR(*LAST) MBROPT(*ADD)
             DLTSPLF    FILE(QPDSPOLK) SPLNBR(*LAST)

             WRKOBJLCK  OBJ(HFILE1/AB#EP70) OBJTYPE(*FILE) MBR(*ALL) +
                          OUTPUT(*PRINT)
             CPYSPLF    FILE(QPDSPOLK) TOFILE(HWFILE1/AB#WP1J) +
                          SPLNBR(*LAST) MBROPT(*ADD)
             DLTSPLF    FILE(QPDSPOLK) SPLNBR(*LAST)

             WRKOBJLCK  OBJ(HFILE1/AB#EP73) OBJTYPE(*FILE) MBR(*ALL) +
                          OUTPUT(*PRINT)
             CPYSPLF    FILE(QPDSPOLK) TOFILE(HWFILE1/AB#WP1J) +
                          SPLNBR(*LAST) MBROPT(*ADD)
             DLTSPLF    FILE(QPDSPOLK) SPLNBR(*LAST)

             CALL       PGM(AB#R1J)

             ENDPGM
