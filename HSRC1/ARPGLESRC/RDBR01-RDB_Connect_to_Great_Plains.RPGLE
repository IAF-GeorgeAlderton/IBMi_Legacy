     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DFTACTGRP(*NO)
     H BNDDIR('RDB2000')
     FRDBWP10   O  A E             DISK
     FRDBWP11   O  A E             DISK
     FRDBWP55   O  A E             DISK
     FRDBWP60   O  A E             DISK
      //************************************************************************
      // RDBR01
      // LEC          2016/12/02
      // This program connects to Great Plains SQL server and Pulls PO info
      // over to iSeries workfiles to be sent to vendor via EDI.
      //************************************************************************
      /COPY *LIBL/RDBSRC,RDBPROTO
     D Id              S             10I 0
     D rc              S             10I 0
     D Count           S             10I 0


     C     *Entry        PList
     C                   Parm                    In_PO            17
     C                   Parm                    In_LocnId        15

      /FREE

        //     Connect to the remote system using the Id created in the RDB
        //     configuration screen (RDBCFG)

         Id = RdbConnect('GRTPLAINS');
         If Id >= 0;

        //     After the connection is established, prepare the statement.
         rc = RdbPrepStmt(Id:
             'Select * from ﾛdboﾜ.ﾛPOP10100ﾜ' +
             ' where PONUMBER = ?');


         //     Set the value of the POnumber.
         rc = RdbSetStr(Id: 1: In_PO);

         //     Execute the prepared statement with the set parameter values.
         rc = RdbPrepExec(Id);

         //     Fetch the first record of the result set that was generated with
         //     previously executed statement.
         rc = RdbFetchNxt(Id);

         DoW rc = 0;
           R1PO#  = RdbAscStr(Id:'PONUMBER');
          If R1PO# = In_PO;
           Count += 1;
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
          EndIf;
         //     Fetch the next record of the result set
         rc = RdbFetchNxt(Id);
         EndDo;

         RdbFreeStmt(Id);

         // *****************************************************
         //    if vendor id, po number wasn't found, end program.
            If Count = *zero;
             RdbClose(Id);
             Eval *INLR = *On;
             Return;
            EndIf;


         //  ------------------------------------------------------------------------------
         //  Now get Purchase Order Detail from POP10110.
         //


         rc = RdbPrepStmt(Id:
             'Select * from ﾛdboﾜ.ﾛPOP10110ﾜ' +
             ' where PONUMBER = ?');


         //     Set the value of the POnumber.
         rc = RdbSetStr(Id: 1: In_PO);

         //     Execute the prepared statement with the set parameter values.
         rc = RdbPrepExec(Id);

         //     Fetch the first record of the result set that was generated with
         //     previously executed statement.
         rc = RdbFetchNxt(Id);

         DoW rc = 0;
           R2PO#        = RdbAscStr(Id:'PONUMBER');
          If R2PO# = In_PO;
           R2ORD  = RdbAscNum(Id:'ORD');
           R2CMID = RdbAscStr(Id:'COMMNTID');
           R2ITDS = RdbAscStr(Id:'ITEMDESC');
           R2VITM = RdbAscStr(Id:'VNDITNUM');
           R2VIDS = RdbAscStr(Id:'VNDITDSC');
           R2FOB  = RdbAscNum(Id:'FREEONBOARD');
           R2UOFM = RdbAscStr(Id:'UOFM');
           R2OQTY = RdbAscNum(Id:'QTYORDER');
           R2UCST = RdbAscNum(Id:'UNITCOST');
           R2ECST = RdbAscNum(Id:'EXTDCOST');
           R2OPDT = RdbAscStr(Id:'ORIGPRMDATE');
           R2PHN1 = RdbAscStr(Id:'PHONE1');
           R2FAX# = RdbAscStr(Id:'FAX');
           Write RDBWP111;
          EndIf;
         //     Fetch the next record of the result set
         rc = RdbFetchNxt(Id);
         EndDo;

         RdbFreeStmt(Id);

         //  ------------------------------------------------------------------------------
         //  Now get Purchase Order Comments from POP10550.
         //


         rc = RdbPrepStmt(Id:
             'Select * from ﾛdboﾜ.ﾛPOP10550ﾜ' +
             ' where POPNUMBE = ?');


         //     Set the value of the POnumber, comment id, order number
         rc = RdbSetStr(Id: 1: In_PO);

         //     Execute the prepared statement with the set parameter values.
         rc = RdbPrepExec(Id);

         //     Fetch the first record of the result set that was generated with
         //     previously executed statement.
         rc = RdbFetchNxt(Id);

         DoW rc = 0;
           R3PO#        = RdbAscStr(Id:'POPNUMBE');
          If R3PO# = In_PO;
           R3ORD  = RdbAscNum(Id:'ORD');
           R3CMID = RdbAscStr(Id:'COMMNTID');
           R3COM1 = RdbAscStr(Id:'COMMENT_1');
           R3COM2 = RdbAscStr(Id:'COMMENT_2');
           R3COM3 = RdbAscStr(Id:'COMMENT_3');
           R3COM4 = RdbAscStr(Id:'COMMENT_4');
           Write RDBWP551;
          EndIf;
         //     Fetch the next record of the result set
         rc = RdbFetchNxt(Id);
         EndDo;

         RdbFreeStmt(Id);

         //  ------------------------------------------------------------------------------
         //  Now get IAF Company Information from System File SY00600.
         //


         rc = RdbPrepStmt(Id:
             'Select * from ﾛdboﾜ.ﾛSY00600ﾜ' +
             ' where LOCATNID = ?');


         //     Set the value of the Location Id.
         rc = RdbSetStr(Id: 1: In_LocnId);

         //     Execute the prepared statement with the set parameter values.
         rc = RdbPrepExec(Id);

         //     Fetch the first record of the result set that was generated with
         //     previously executed statement.
         rc = RdbFetchNxt(Id);

         DoW rc = 0;
           R4LCID = RdbAscStr(Id:'LOCATNID');
           R4LCNM = RdbAscStr(Id:'LOCATNNM');
           R4ADCD = RdbAscStr(Id:'ADRSCODE');
           R4CONT = RdbAscStr(Id:'ADRCNTCT');
           R4ADR1 = RdbAscStr(Id:'ADDRESS1');
           R4ADR2 = RdbAscStr(Id:'ADDRESS2');
           R4ADR3 = RdbAscStr(Id:'ADDRESS3');
           R4CITY = RdbAscStr(Id:'CITY');
           R4CNTY = RdbAscStr(Id:'COUNTY');
           R4STAT = RdbAscStr(Id:'STATE');
           R4ZIPC = RdbAscStr(Id:'ZIPCODE');
           R4CNTR = RdbAscStr(Id:'COUNTRY');
           Write RDBWP601;
         //     Fetch the next record of the result set
         rc = RdbFetchNxt(Id);
         EndDo;

         RdbFreeStmt(Id);

         //     Close the connection to the remote system.
         RdbClose(Id);

         EndIf;

         *InLR = *On;
         Return;

      /END-FREE
