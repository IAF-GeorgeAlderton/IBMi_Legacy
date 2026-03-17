      **************************************************************
      * On MS Sequel Server IAF.SQL.01 DB=PC Table = POSTLABEL     *
      * Which contans Virtual Location for Conveyance 4 Point Scan *
      * This progam uses RDB assets to pull that data into our table*
      * POSTLABEL which will be used by ALCR12.                     *
      * ----------------------------------------------------------  *
      *  Maintenance:                                               *
      *  Mod#    Pgmr       Date        Description                 *
      * ----------------------------------------------------------  *
      ***************************************************************
       ctl-opt debug  indent('. ') option(*srcstmt: *nodebugio)
       dftactgrp(*no) bnddir('RDB2000');

       /copy *libl/rdbsrc,rdbproto

       dcl-ds fieldDS extname('POSTLABEL') qualified;
       end-ds fieldDS ;

       dcl-s id int(10);
       dcl-s rc int(10);
       dcl-s Count int(10);
       dcl-s Completed char(50) inz('Completed');
       dcl-s sqlstmt char(200) inz;

        exec sql set option naming = *sys,commit = *none,usrprf = *user,
          dynusrprf = *user, datfmt = *iso, closqlcsr = *endmod;

       // Connect to the remote system using the Id created in the RDB
       // configuration screen (RDBCFG)

       id = RdbConnect('SQL01');

       if id >= 0;
         // After the connection is established, prepare the statement.
         rc = RdbPrepStmt(Id:'Select * From ﾛPCﾜ.ﾛdboﾜ.ﾛPOSTLABELﾜ ');
         // Execute the prepared statement with the set parameter values.
         rc = RdbPrepExec(Id);
         // Fetch the first record of the result set that was generated with
         // previously executed statement.
         rc = RdbFetchNxt(Id);

         // id>=0 and rc = 0 then clear records from postlabel,otherwise keep what we have
         if rc = 0;
           sqlstmt = 'delete from postlabel';
           exec sql execute immediate :sqlstmt;
         endif;

         // format and load fields for insert.
         dow rc = 0;
           fieldDS.idNbr = RdbAscNum(Id:'Id');
           fieldDS.prefix = RdbAscStr(Id:'Prefix  ');
           fieldDS.line1 = RdbAscStr(Id:'Line1Text');
           fieldDS.line2 = RdbAscStr(Id:'Line2Text');
           fieldDS.barcodetxt = RdbAscStr(Id:'BarcodeText');
           fieldDS.barcodetyp = RdbAscStr(Id:'BarcodeType');
           fieldDS.copies = RdbAscNum(Id:'Copies');
           fieldDS.changeBy = RdbAscStr(Id:'ChangeBy');
           fieldDS.changeDate = RdbAscDate(Id:'ChangeDate');
           fieldDS.selectby = RdbAscStr(Id:'SelectBy');
           fieldDS.selectDate = RdbAscDate(Id:'SelectDate');
           fieldDS.printBy  = RdbAscStr(Id:'PrintBy ');
           fieldDS.printDate = RdbAscDate(Id:'PrintDate');

           exec sql insert into postlabel values(:fieldDS);

           rc = RdbFetchNxt(Id);
         enddo;

         RdbFreeStmt(Id);
         RdbClose(Id);
       endif;

         *inlr = '1';
         return;
