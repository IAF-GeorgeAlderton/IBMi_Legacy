     H OPTION(*SRCSTMT : *NODEBUGIO)
     H DFTACTGRP(*NO)
     H BNDDIR('RDB2000')
      //************************************************************************
      // RDBR15
      // LEC          2021/09/02
      // This program connects to SQL01 Database and Inserts Records
      // from the Toyota EDI Workfile - AB#WP15 into TKS_EDIData.
      //************************************************************************
      /COPY *LIBL/RDBSRC,RDBPROTO
     FAB#WP15   UF   E             DISK
     FAL#PL21   IF   E           K DISK

     D Id              S             10I 0
     D rc              S             10I 0
     D Count           S             10I 0
     D @ErrId          S              7A
     D @ErrText        S            100A
     D  ##NAMC         S              5                                         plant code
     D  ##count        S              5S 0                                      container count
     D  ##PartialQty   S              5S 0                                      partial qty remainin
     D  ##unloaddttm   S             20                                         unload date/time
     D  ##cd1dttm      S             20                                         crossdock1 date/time
     D  ##cd2dttm      S             20                                         crossdock2 date/time
     D  SysDate        S               Z   inz(Z'2001-01-01-00.00.00.000000')   DEFAULT Value
     D  ##shipdttm     S               Z                                        ship date/time
     D  ##rectype      S              2                                         record type
     D  ##computer     S             10    inz('AS/400')                        computer name
     D  ##username     S             10    inz('QPGMR')                         user name
     D  ##odrn         S             20                                         order number
     D XPos            S              5S 0
     D SPos            S              5S 0
     D TPos            S              5S 0

     D                 DS
     D  DT                     1      8
     D  TM                     9     14
     D  microsecs             15     20  0 inz(0)
     D  DTTM                   1     20  0

      /FREE

             SysDate = %timestamp();

      //     Connect to the remote system using the Id created in the SQL01 database
      //     configuration screen (RDBCFG)

         Id = RdbConnect('SQL01');
          If Id >= 0;

      //     After the connection is established, read record from toyota edi workfile.

            Read AB#WP15;

                DoW NOT %eof;

       // get plant code (NAMC)...
            Chain (ewnony) AL#PL21;
                  If %found(AL#PL21) and C2SKJY = *blank;
                  ##NAMC = C2NAMC;
                  Else;
                  ##NAMC = *blanks;
                  EndIf;

       // set the order number correctly...
            If ewnony = 3503 or ewnony = 323;
            ##odrn = ewman#;
            Else;
            ##odrn = ewodrn;
            Endif;

       // calculate container count = ordered qty / qpc...
            If ewsyos > *zero;
            ##count = ewsury / ewsyos;
            Else;
            ##count = *zero;
            Endif;

            If ewsyos > *zero;
            ##PartialQty = %Rem(ewsury : ewsyos);
            If ##PartialQty > *zero;
               ##count += 1;
            EndIf;
            Else;
            ##PartialQty = *zero;
            EndIf;

       // format date and time stamps...
            DT = ewshid;
            TM = ewshit;
            ##shipdttm  = %timestamp(DTTM);

            ##unloaddttm =  %trim(ewuldt) + ' ' +  %trim(ewultm);
            ##cd1dttm    =  %trim(ewcd1d) + ' ' +  %trim(ewcd1t);
            ##cd2dttm    =  %trim(ewcd2d) + ' ' +  %trim(ewcd2t);

       // set record type...
       //     service parts = 'SP'
       //     supplemental order = 'SO'
       //     trial part order = 'TO'
       //     regular order = 'DO'

                    ##rectype = *blanks;
                    XPos = %scan('X':##odrn);
                    SPos = %scan('S':##odrn);
                    TPos = %scan('T':##odrn);


               Select;
               When ewnony = 0323;
                    ##rectype = 'SP';
               When ewnony = 3503 and XPos > *zero;
                    ##rectype = 'SO';
               When ewnony <> 3503 and SPos > *zero;
                    ##rectype = 'SO';
               When TPos > *zero;
                    ##rectype = 'TO';
               Other;
                    ##rectype = 'DO';
               EndSl;

                //     Then, prepare the SQL statement.
                  rc = RdbPrepStmt(Id:
                      'insert into dbo.TKS_EDIData +
                      (DeliveryCode, FactoryCode, NAMC, SupplierCode, +
                      DockCode, SupplierName, OrderNumber, ContainerNumber, +
                      ContainerCount, QuantityPerContainer, KanbanNumber, +
                      Company, BC, PartNumber, PartDescription, PalletCode, +
                      StoreAddress, LinesideAddress, SRRoute, +
                      SRLoadShipDateTime, SRUnloadShipDateTime, CD1Route, +
                      CD1LoadShipDateTime, CD1UnloadShipDateTime, CD2Route, +
                      CD2LoadShipDateTime, CD2UnloadShipDateTime, +
                      MRRoute, MRLoadShipDateTime, MRUnLoadShipDateTime,  +
                      MROS, ShipDate, RecordType, ComputerName, UserName, +
                      LoadDate) +
                      values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, +
                             ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, +
                             ?, ?, ?, ?, ?, ?)');

         //     Set the value of the statement parameters
                  rc = RdbSetNum(Id: 1: ewnony);
                  rc = RdbSetStr(Id: 2: ewnkoj);
                  rc = RdbSetStr(Id: 3: ##NAMC);
                  rc = RdbSetStr(Id: 4: ewsire);
                  rc = RdbSetStr(Id: 5: ewnuke);
                  rc = RdbSetStr(Id: 6: ewsirk);
                  rc = RdbSetStr(Id: 7: ##odrn);
                  rc = RdbSetNum(Id: 8: 0);
                  rc = RdbSetNum(Id: 9: ##count);
                  rc = RdbSetNum(Id: 10: ewsyos);
                  rc = RdbSetStr(Id: 11: ewsban);
                  rc = RdbSetStr(Id: 12: ewcnam);
                  rc = RdbSetStr(Id: 13: '  ');
                  rc = RdbSetStr(Id: 14: ewmhin);
                  rc = RdbSetStr(Id: 15: ewpanm);
                  rc = RdbSetStr(Id: 16: '  ');
                  rc = RdbSetStr(Id: 17: ewstad);
                  rc = RdbSetStr(Id: 18: ewliad);
                  rc = RdbSetStr(Id: 19: ewsurt);
                  rc = RdbSetStr(Id: 20: '  ');
                  rc = RdbSetStr(Id: 21: ##unloaddttm);
                  rc = RdbSetStr(Id: 22: ewcd1c);
                  rc = RdbSetStr(Id: 23: ##cd1dttm);
                  rc = RdbSetStr(Id: 24: '  ');
                  rc = RdbSetStr(Id: 25: ewcd2c);
                  rc = RdbSetStr(Id: 26: ##cd2dttm);
                  rc = RdbSetStr(Id: 27: '  ');
                  rc = RdbSetStr(Id: 28: ewmnrt);
                  rc = RdbSetStr(Id: 29: '  ');
                  rc = RdbSetStr(Id: 30: '  ');
                  rc = RdbSetStr(Id: 31: ewsban);
                  rc = RdbSetDate(Id: 32: ##shipdttm);
                  rc = RdbSetStr(Id: 33: ##rectype);
                  rc = RdbSetStr(Id: 34: ##computer);
                  rc = RdbSetStr(Id: 35: ##username);
                  rc = RdbSetDate(Id: 36: SysDate);
         //                          37
         //                          38
         //                          39


         //     Execute the prepared SQL statement.
                  rc = RdbPrepExec(Id);
                   If rc < 0;
                      RdbError(@ErrId: @ErrText);
                   EndIf;

                  RdbFreeStmt(Id);

                EWRTYP = ##rectype;
                Update AB#WP151;

                Read AB#WP15;

                EndDo;


          EndIf;

         *InLR = *On;
         Return;

      /END-FREE
