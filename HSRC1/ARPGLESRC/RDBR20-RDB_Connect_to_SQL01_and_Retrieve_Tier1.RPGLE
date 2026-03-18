     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DFTACTGRP(*NO)
     H BNDDIR('RDB2000')
     FRDBWP20   UF A E           K DISK
     FRDBWP21   UF A E           K DISK
      //************************************************************************
      // RDBR20
      // LEC          2021/11/11
      // This program connects to SQL01 and Pulls Tier1 orders from \BA_Orders
      // into a workfile to be processed into AB#PP10.
      //************************************************************************
      /COPY *LIBL/RDBSRC,RDBPROTO
     D Id              S             10I 0
     D rc              S             10I 0
     D Count           S             10I 0
     D Completed       S             50    inz('Completed')
     D Status          S             50
     D ##orgCode       S             10
     D ##tierName      S             10
     D ##orderNo       S             15
     D ##dockCode      S              5
     D ##Blank         S             50

      /FREE

        //     Connect to the remote system using the Id created in the RDB
        //     configuration screen (RDBCFG)

         Id = RdbConnect('SQL01');
         If Id >= 0;

        //     After the connection is established, prepare the statement.


        //   G  E  T     U  N  P  R  O  C  E  S  S  E  D     O  R  D  E  R  S   *********

         rc = RdbPrepStmt(Id:
             'Select TBAKEY,DataValidationStatus,DockCode ' +
             'from ﾛdboﾜ.ﾛTBA_OrderStatusﾜ ' +
             ' where AS400ProcessStatus is null ');


         //     Execute the prepared statement with the set parameter values.
         rc = RdbPrepExec(Id);

         //     Fetch the first record of the result set that was generated with
         //     previously executed statement.
         rc = RdbFetchNxt(Id);

         DoW rc = 0;

           Status = RdbAscStr(Id:'DataValidationStatus');
           If Status = Completed;
           Count += 1;
           THINDX = RdbAscStr(Id:'TBAKEY');
           THNUKE = RdbAscStr(Id:'DockCode');
           THMSG  = 'Uploaded';
           Write RDBWP201;
           EndIf;

         //     Fetch the next record of the result set
         rc = RdbFetchNxt(Id);
         EndDo;

         RdbFreeStmt(Id);


        //   G  E  T    O  R  D  E  R    D  E  T  A  I  L    R  E  C  O  R  D  S   ********

                thindx = *blanks;
                SetLL (thindx) RDBWP20;

         //     get all orders that are completed and ready to be created on as400...
                DoW  NOT  %eof(RDBWP20);

                Read RDBWP20;

                  If %eof(RDBWP20);
                     Leave;
                  EndIf;

                ##tierName = %subst(thindx:1:10);
                ##orgCode = %subst(thindx:11:10);
                ##orderNo = %subst(thindx:21:15);
                ##dockCode = thnuke;

         rc = RdbPrepStmt(Id:
             'Select * from ﾛdboﾜ.ﾛTBA_Ordersﾜ' +
             ' where OrderNo = ? and OrgCode = ? and DockCode = ? and ' +
             ' Tier1Name = ? ');

         rc = RdbSetStr(Id: 1: ##orderNo);
         rc = RdbSetStr(Id: 2: ##orgCode);
         rc = RdbSetStr(Id: 3: ##dockCode);
         rc = RdbSetStr(Id: 4: ##tierName);

         //     Execute the prepared statement with the set parameter values.
         rc = RdbPrepExec(Id);

         //     Fetch the first record of the result set that was generated with
         //     previously executed statement.
         rc = RdbFetchNxt(Id);

         DoW rc = 0;

           Count += 1;
           TDINDX = RdbAscStr(Id:'TBAKEY');
           TDNAME = RdbAscStr(Id:'Tier1Name');
           TDORGC = RdbAscStr(Id:'OrgCode');
           TDODRN = RdbAscStr(Id:'OrderNo');
           TDSHID = %dec(%date(RdbAscDate(Id:'ShipDate')):*iso);
           TDSHIT = %dec(%time(RdbAscDate(Id:'ShipDate')):*hms)/100;
           TDMHN  = RdbAscStr(Id:'PartNo');
           TDQPC  = RdbAscNum(Id:'QPC');
           TDKBAN = RdbAscStr(Id:'KanbanNo');
           TDKSER = RdbAscStr(Id:'KanbanSerial');
           TDNUKE = RdbAscStr(Id:'DockCode');
           TDMAN# = RdbAscStr(Id:'Manifest');
           TDSUPP = RdbAscStr(Id:'Supplier');

           TDCRDT = %char(%dec(%date():*iso));
           TDCRTM = %char(%editc(%dec(%time():*hms):'X'));

           Write RDBWP211;

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
