     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DFTACTGRP(*NO)
     H BNDDIR('RDB2000')
     FRDBWP41   IF   E           K DISK
     FRDBWP42   IF   E           K DISK
      //************************************************************************
      // RDBR42
      // LEC          2023/02/20
      // This program connects to SQL01 and Updates TVAPP05 and TVAPP06
      // with a workfile to be processed into ALGPP01 and ALGPP11.
      //************************************************************************
      /COPY *LIBL/RDBSRC,RDBPROTO
     D Id              S             10I 0
     D rc              S             10I 0
     D Count           S             10I 0
     D Uploaded        S              1    inz('2')
     D @ErrId          S              7A
     D @ErrText        S            100A

      /FREE

        //     Connect to the remote system using the Id created in the RDB
        //     configuration screen (RDBCFG)

         Id = RdbConnect('SQL01HT');
         If Id >= 0;

         //   After the connection is established, prepare the statement.

         //   Read all header records from workfile...

                DoW  NOT  %eof(RDBWP41);

                Read RDBWP41;

                  If %eof(RDBWP41);
                     Leave;
                  EndIf;

        //   U  P  D  A  T  E     H  E  A  D  E  R     S  T  A  T  U  S       ********

         rc = RdbPrepStmt(Id:
             'Update ﾛdboﾜ.ﾛTVAPP05ﾜ' +
             ' Set T5SFLG = ? ' +
             ' Where T5KOJO = ? and T5ROBN = ? and T5SYNO = ? and ' +
             ' T5TOHZ = ? ');


          rc = RdbSetStr(Id: 1: Uploaded);
          rc = RdbSetStr(Id: 2: R5KOJO);
          rc = RdbSetStr(Id: 3: R5ROBN);
          rc = RdbSetStr(Id: 4: R5SYNO);
          rc = RdbSetStr(Id: 5: %char(R5TOHZ));


         //     Execute the prepared statement with the set parameter values.
         rc = RdbPrepExec(Id);

                    If rc < 0;
                       RdbError(@ErrId: @ErrText);
                    EndIf;

         RdbFreeStmt(Id);

                EndDO;



         //   Read all detail records from workfile...

                DoW  NOT  %eof(RDBWP42);

                Read RDBWP42;

                  If %eof(RDBWP42);
                     Leave;
                  EndIf;

        //   U  P  D  A  T  E     D  E  T  A  I  L     S  T  A  T  U  S       ********

         rc = RdbPrepStmt(Id:
             'Update ﾛdboﾜ.ﾛTVAPP06ﾜ' +
             ' Set T6SFLG = ? ' +
             ' Where NUMBER = ? ');


          rc = RdbSetStr(Id: 1: Uploaded);
          rc = RdbSetNum(Id: 2: R6SEQ#);


         //     Execute the prepared statement with the set parameter values.
         rc = RdbPrepExec(Id);

                    If rc < 0;
                       RdbError(@ErrId: @ErrText);
                    EndIf;

         RdbFreeStmt(Id);

                EndDO;

         //     Close the connection to the remote system.
         RdbClose(Id);

         EndIf;

         *InLR = *On;
         Return;

      /END-FREE
