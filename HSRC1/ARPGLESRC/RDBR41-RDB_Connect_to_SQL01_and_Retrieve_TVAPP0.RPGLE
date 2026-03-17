     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DFTACTGRP(*NO)
     H BNDDIR('RDB2000')
     FRDBWP41   UF A E           K DISK
     FRDBWP42   UF A E           K DISK
      //************************************************************************
      // RDBR41
      // LEC          2023/02/15
      // This program connects to SQL01 and Pulls TVAPP05 and TVAPP06
      // into a workfile to be processed into ALGPP01 and ALGPP11.
      //************************************************************************
      /COPY *LIBL/RDBSRC,RDBPROTO
     D Id              S             10I 0
     D rc              S             10I 0
     D Count           S             10I 0
     D Ready           S              1    inz('1')
     D LoadDate        S              8
     D CRDT            S              8
     D CRTM            S              6
     D @ErrId          S              7A
     D @ErrText        S            100A

      /FREE

        //     Connect to the remote system using the Id created in the RDB
        //     configuration screen (RDBCFG)

         Id = RdbConnect('SQL01HT');
         If Id >= 0;

        //     After the connection is established, prepare the statement.

        //   get create date and time...
                CRDT = %char(%dec(%date():*iso));
                CRTM = %char(%editc(%dec(%time():*hms):'X'));


        //   G  E  T     R  E  C  O  R  D  S     =     R  E  A  D  Y     S  T  A  T  U  S   ******

         rc = RdbPrepStmt(Id:
             'Select *  from ﾛdboﾜ.ﾛTVAPP05ﾜ where T5SFLG = ? ' );

         rc = RdbSetStr(Id: 1: Ready);

         //     Execute the prepared statement with the set parameter values.
         rc = RdbPrepExec(Id);

         //     Fetch the first record of the result set that was generated with
         //     previously executed statement.
         rc = RdbFetchNxt(Id);

         DoW rc = 0;

           R5DASY = RdbAscStr(Id:'T5DASY');
           R5SYKB = RdbAscStr(Id:'T5SYKB');
           R5KOJO = RdbAscStr(Id:'T5KOJO');
           R5ROBN = RdbAscStr(Id:'T5ROBN');
           R5HIN1 = RdbAscStr(Id:'T5HIN1');
           R5ZETI = RdbAscStr(Id:'T5ZETI');
           R5SYNO = RdbAscStr(Id:'T5SYNO');
           R5SYN1 = RdbAscStr(Id:'T5SYN1');
           R5TOHZ = %dec(RdbAscStr(Id:'T5TOHZ'):8:0);
           R5TOJI = %dec(RdbAscStr(Id:'T5TOJI'):6:0);
           R5SYOS = RdbAscStr(Id:'T5SYOS');
           R5ZASI = RdbAscStr(Id:'T5ZASI');
           R5KKI1 = %dec(RdbAscStr(Id:'T5KKI1'):6:0);
           R5KKIK = RdbAscStr(Id:'T5KKIK');
           R5YAJI = %dec(RdbAscStr(Id:'T5YAJI'):3:0);
           R5YAMT = %dec(RdbAscStr(Id:'T5YAMT'):3:0);
           R5YCO2 = %dec(RdbAscStr(Id:'T5YCO2'):5:3);
           R5TAJY = %dec(RdbAscStr(Id:'T5TAJY'):7:2);
           R5HAJY = %dec(RdbAscStr(Id:'T5HAJY'):4:1);
           R5LOSZ = %dec(RdbAscStr(Id:'T5LOSZ'):3:0);
           R5KK11 = %dec(RdbAscStr(Id:'T5KK11'):3:0);
           R5KK22 = %dec(RdbAscStr(Id:'T5KK22'):3:0);
           R5SETS = %dec(RdbAscStr(Id:'T5SETS'):2:0);
           R5SYHZ = %dec(RdbAscStr(Id:'T5SYHZ'):8:0);
           R5SYJI = %dec(RdbAscStr(Id:'T5SYJI'):6:0);
           R5HAKS = %dec(RdbAscStr(Id:'T5HAKS'):3:0);
           R5SJUR = %dec(RdbAscStr(Id:'T5SJUR'):6:2);
           R5TAJI = %dec(RdbAscStr(Id:'T5TAJI'):3:0);
           R5KABA = RdbAscStr(Id:'T5KABA');
           R5SYTF = RdbAscStr(Id:'T5SYTF');
           R5SFLG = RdbAscStr(Id:'T5SFLG');
           R5SEQ# = RdbAscNum(Id:'NUMBER');
           R5CRDT = CRDT;
           R5CRTM = CRTM;

           Write RDBWP411;

         //     Fetch the next record of the result set
         rc = RdbFetchNxt(Id);
         EndDo;

         RdbFreeStmt(Id);


        //   G  E  T     D  E  T  A  I  L     R  E  C  O  R  D  S   ********

                r5kojo = *blanks;
                SetLL (r5kojo) RDBWP41;

         //     get all detail records with lot id info...
                DoW  NOT  %eof(RDBWP41);

                Read RDBWP41;

                  If %eof(RDBWP41);
                     Leave;
                  EndIf;

         LoadDate = %char(r5tohz);

         rc = RdbPrepStmt(Id:
             'Select * from ﾛdboﾜ.ﾛTVAPP06ﾜ' +
             ' where T6KOJO = ? and T6ROBN = ? and T6SYNO = ? and ' +
             ' T6TOHZ = ? ');



         rc = RdbSetStr(Id: 1: R5KOJO);
         rc = RdbSetStr(Id: 2: R5ROBN);
         rc = RdbSetStr(Id: 3: R5SYNO);
         rc = RdbSetStr(Id: 4: LoadDate);

         //     Execute the prepared statement with the set parameter values.
         rc = RdbPrepExec(Id);

                    If rc < 0;
                       RdbError(@ErrId: @ErrText);
                    EndIf;

         //     Fetch the first record of the result set that was generated with
         //     previously executed statement.
         rc = RdbFetchNxt(Id);

         DoW rc = 0;

           R6DASY = RdbAscStr(Id:'T6DASY');
           R6SYKB = RdbAscStr(Id:'T6SYKB');
           R6KOJO = RdbAscStr(Id:'T6KOJO');
           R6ROBN = RdbAscStr(Id:'T6ROBN');
           R6SYNO = RdbAscStr(Id:'T6SYNO');
           R6TOHZ = %dec(RdbAscStr(Id:'T6TOHZ'):8:0);
           R6TOJI = %dec(RdbAscStr(Id:'T6TOJI'):6:0);
           R6SYOS = RdbAscStr(Id:'T6SYOS');
         //   R6SYHZ = %dec(RdbAscStr(Id:'T6SYHZ'):8:0);
         //   R6SYJI = %dec(RdbAscStr(Id:'T6SYJI'):6:0);
           R6LTAG = RdbAscStr(Id:'T6LTAG');
           R6SYTF = RdbAscStr(Id:'T6SYTF');
           R6SFLG = RdbAscStr(Id:'T6SFLG');
           R6SEQ# = RdbAscNum(Id:'NUMBER');
           R6CRDT = CRDT;
           R6CRTM = CRTM;

           Write RDBWP421;

         //     Fetch the next record of the result set
           rc = RdbFetchNxt(Id);
         EndDo;

         RdbFreeStmt(Id);

                EndDO;

         //     Close the connection to the remote system.
         RdbClose(Id);

         EndIf;

         *InLR = *On;
         Return;

      /END-FREE
