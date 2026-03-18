     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DFTACTGRP(*NO)
      ******H BNDDIR('RDB2000')
     FRDBWP10   O  A E             DISK
      //************************************************************************
      // RDBR01
      // LEC          2016/12/02
      // This program connects to Great Plains SQL server and Pulls PO info
      // over to iSeries workfiles to be sent to vendor via EDI.
      //************************************************************************
      /COPY RDB40/RDBSRC,RDBPROTO
     D Id              S             10I 0
     D rc              S             10I 0


     C     *Entry        PList
     C                   Parm                    In_PO            17
     C                   Parm                    In_Vend          15

      /FREE

        //     Connect to the remote system using the Id created in the RDB
        //     configuration screen (RDBCFG)

         Id = RdbConnect('GRTPLAINS');
         If Id >= 0;

        //     After the connection is established, prepare the statement.
         rc = RdbPrepStmt(Id:
             'Select * from ﾛdboﾜ.ﾛPOP10010ﾜ' +
             ' where VendorId = ?');

         // The ?'s in a prepared statement are values to be set at a later time
         // number in the order they are found in the statement, beginning with

         //     Set the value of the VendorId
         rc = RdbSetStr(Id: 1: In_Vend);
         //
         //     Execute the prepared statement with the set parameter values.
         rc = RdbPrepExec(Id);

         //     Fetch the first record of the result set that was generated with
         //     previously executed statement.
         rc = RdbFetchNxt(Id);

         //     Fetch the next record of the result set
         rc = RdbFetchNxt(Id);
         DoW rc = 0;
           R1LEDT = RdbAscStr(Id:'LSTEDTDT');
           R1PPHO = RdbAscStr(Id:'PURCHPHONE1');
           R1PFAX = RdbAscStr(Id:'PURCHFAX');
           R1PO#  = RdbAscStr(Id:'PONUMBER');
           R1HOLD = RdbAscNum(Id:'HOLD');
           R1DCDT = RdbAscStr(Id:'DOCDATE');
           R1REV# = RdbAscNum(Id:'Revision_Number');
           R1SHPM = RdbAscStr(Id:'SHIPMTHD');
           R1PYTR = RdbAscStr(Id:'PYMTRMID');
           R1BYID = RdbAscStr(Id:'BUYERID');
           R1VNNM = RdbAscStr(Id:'VENDNAME');
           R1PAD1 = RdbAscStr(Id:'PURCHADDRESS1');
           R1PAD2 = RdbAscStr(Id:'PURCHADDRESS2');
           R1PAD3 = RdbAscStr(Id:'PURCHADDRESS3');
           R1PCTY = RdbAscStr(Id:'PURCHCITY');
           R1PSTA = RdbAscStr(Id:'PURCHSTATE');
           R1PZIP = RdbAscStr(Id:'PURCHZIPCODE');
           R1RQDT = RdbAscStr(Id:'REQDATE');
           R1VNID = RdbAscStr(Id:'VENDORID');
           R1CMID = RdbAscNum(Id:'CMPANYID');
           R1VCPD = RdbAscStr(Id:'VADCDPAD');
           Write RDBWP101;

         rc = RdbFetchNxt(Id);
         EndDo;

         RdbFreeStmt(Id);

         //     Close the connection to the remote system.
         RdbClose(Id);

         EndIf;

         *InLR = *On;
         Return;

      /END-FREE
