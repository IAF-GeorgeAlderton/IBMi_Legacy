     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DFTACTGRP(*NO)
     H BNDDIR('RDB2000')
      //************************************************************************
      // RDBR55
      // LEC          2024/07/09
      // This program connects to SQL03 Database SQL server and Inserts
      // records for File/Field cross-reference file.

      //************************************************************************
     FFFDPP01   IF   E           K DISK
      /COPY *LIBL/RDBSRC,RDBPROTO

     D Id              S             10I 0
     D rc              S             10I 0
     D  SysDate        S               Z   inz(Z'2001-01-01-00.00.00.000000')   DEFAULT Value
     D SDate           S              8S 0
     D STime           S              6S 0
     D @ErrId          S              7A
     D @ErrText        S            100A
     D Pos             S              5S 0
     D @FileName       S             10A   inz('FFDPP01')
     D @LibrName       S             10A   inz('HFILE1')
     D EmailSent       S              1A

      /FREE

         dcl-pr AM#C405 extpgm;
           Parm1 char(10) ;
         end-pr ;


      //     Connect to the remote system using the Id created in the RDB
      //     configuration screen (RDBCFG)

         Id = RdbConnect('SQL03T');
          If Id >= 0;

      //     after the connection is established....

      //   =======================================================
      //            DELETE all records the table...

      //     prepare the SQL statement...
               rc = RdbPrepStmt(Id:
                    'delete from dbo.fieldDefinition +
                      where LibraryName = ?');

      //     set the value of the statement parameters.
               rc = RdbSetStr(Id: 1:@LibrName);

      //     Execute the prepared SQL statement to delete records from table...
               rc = RdbPrepExec(Id);

                  RdbFreeStmt(Id);

      //   =======================================================

      //   process all records in file/field cross reference
             DoW  NOT  %eof(FFDPP01);

              Read FFDPP01;

               If %eof(FFDPP01);
                 Leave;
               EndIf;

               SysDate = %timestamp();
               SDate = %dec(%date():*iso);
               STime = %dec(%time():*hms);

      //     insert record into table...
      //     prepare the SQL statement...
               rc = RdbPrepStmt(Id:
                    'insert into dbo.fieldDefinition +
                    (FileName, LibraryName, FileDescription, FieldName, +
                    FieldLength, FieldDecimalPos, FieldDescription, +
                    FieldType, FieldAlias) +
                    values(?, ?, ?, ?, ?, ?, ?, ?, ?)');

      //     set the value of the statement parameters.
               rc = RdbSetStr(Id: 1: FILE);
               rc = RdbSetStr(Id: 2: LIBR);
               rc = RdbSetStr(Id: 3: FILDSC);
               rc = RdbSetStr(Id: 4: FLDNAM);
               rc = RdbSetStr(Id: 5: FLDLEN);
               rc = RdbSetStr(Id: 6: FLDDEC);
               rc = RdbSetStr(Id: 7: FLDDSC);
               rc = RdbSetStr(Id: 8: FLDTYP);
               rc = RdbSetStr(Id: 9: FLDAKA);


      //     Execute the prepared SQL statement to insert record into table...
               rc = RdbPrepExec(Id);

                  RdbFreeStmt(Id);

             EndDo;

          Else;
               RdbError(@ErrId: @ErrText);

               Pos = %scan('Time-out' : @ErrText);
                 If Pos > *zero and EmailSent <> 'Y';
                  // call pgm to send email with critical error message...
                  AM#C405(@FileName) ;
                  EmailSent = 'Y';
                 EndIf;
          EndIf;


          //
          //     Close the connection to the remote system.
         RdbClose(Id);

         *InLR = *On;
         Return;

      /END-FREE
