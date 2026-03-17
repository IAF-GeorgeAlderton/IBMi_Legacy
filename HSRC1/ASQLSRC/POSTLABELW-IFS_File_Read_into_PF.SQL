  drop table hfile1.postlabelw if exists;

  create table hfile1.postlabelw(
    idNbr int not null default 0,
    prefix varchar(10) ccsid 37 not null default '',
    line1 varchar(50) ccsid 37 not null  default '',
    line2 varchar(50) ccsid 37 not null  default '',
    barcodetxt varchar(50) ccsid 37 not null  default '',
    barcodetyp char(1) ccsid 37 not null default '',
    copies int not null default 0,
    changeBy varchar(50) ccsid 37 not null default '',
    changeDate timestamp not null default current_timestamp,
    selectBy varchar(50) ccsid 37 not null default '',
    selectDate timestamp not null default current_timestamp,
    printBy varchar(50) ccsid 37 not null default '',
    printDate timestamp not null default current_timestamp,
      primary key (barcodetxt) )
    rcdfmt postlbr;

  Label on table hfile1.postlabelw is 'Virtual Locations: SQL-01 DB=PC';

  Label on column hfile1.postlabelw
    (idNbr text is 'ID',
     prefix text is 'Prefix',
     line1 text is 'Line 1',
     line2 text is 'Line 2',
     barcodetxt text is 'Barcode Text',
     barcodetyp text is 'Barcode Type',
     copies text is 'Copies',
     changeBy text is 'Changed By',
     changeDate text is 'Change Date',
     selectBy text is 'Select By',
     selectDate text is 'Select Date',
     printBy text is 'Print By',
     printDate text is 'Print Date');


