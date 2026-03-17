             PGM
             /** ABMC62 ************************/
             /* AUTO SETTING BACKUP作成      */
             /*   HOTTA.           2018.09.21  */
             /**********************************/

             /**********************************/
             /*  ※下記は別途戻す必要有り    */
             /*  過去３か月分のAB#PP01 N-3 <= X <= N-1  B1NOYY-MM-DD  */
             /*  未来２か月分のAB#PP10 N <= X <= N+1  BANOYY-MM-DD */
             /*   N-2月以降のABBPP50  N-2 <= X  BBRCDT  */
             /* QRY: HOBJ1/AB#PP01Q  AB#PP10Q  ABBPP50Q  */
             /**********************************/

             DLTF       FILE(HFILE1/ABMPPBK)
             MONMSG     MSGID(CPF3261 CPF2105)
             CRTSAVF    FILE(HFILE1/ABMPPBK) AUT(*ALL)

             SAVOBJ     OBJ(FCEPP01 FCEPP11 GHCPP21 AAMPP11 ABBPP01 +
                          AAFPP01 AAHPP01 AANPP01 ABHPP01 ADHPP01 +
                          AAPPP01 AEBPP01 AEBPP11 AKCPP01 AKBPP01 +
                          AKDPP01 AKEPP01 AKHPP01 MCENP13 FCEPP40 +
                          AGAPP31 IZAPP01 IZAPP10 AAJPP11 GADPP11 +
                          ABMPP00 ABMPP01 ABMPP11 ABMPP21 ABMPP31 +
                          ABMPP81 ABMPPB5 ABMPPB6 MRHPP21 FCEPP30 +
                          BTBPP05 BTAPP05 ABMPPL1 GDKPP01 ABBDS2 +
                          ABBDS3) LIB(HFILE1) DEV(*SAVF) +
                          OBJTYPE(*ALL) SAVF(HFILE1/ABMPPBK) +
                          SAVACT(*SYSDFN) DTACPR(*YES)
             MONMSG     MSGID(CPF0000)

 END:        ENDPGM
