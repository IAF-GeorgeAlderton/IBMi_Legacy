             PGM
             /** AAAC80 ************************/
             /* THE NUMBER OF LOCATIONS LIST   */
             /* TCH 2001.06.11                 */
             /************************ AAAC80 **/

             CLRPFM     FILE(AAAWP80)
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(AAAWP81)
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(AAAWP82)
             MONMSG     MSGID(CPF0000)

             DLTF       FILE(AAAWP83)
             MONMSG     MSGID(CPF0000)

             CALL       PGM(AAAR80)

             RUNQRY     QRY(HOBJ1/QAAAWP81)
             RUNQRY     QRY(HOBJ1/QAAAWP82)
             RUNQRY     QRY(HOBJ1/QAAAWP83)

             ENDPGM
