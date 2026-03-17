**free
DCL-F AM#WP28 DISK(*EXT) USAGE(*OUTPUT);

dcl-ds pgmStat psds;
num_ords int(20) pos(372);
end-ds;


  dcl-ds ords dim(10) qualified inz;
     order varchar(12);
     supplier varchar(8);
     plant varchar(8);
     dock varchar(3);
     num_exceptions int(10);
     dcl-ds exceptions dim(5);
            exceptionCode varchar(8);
            comments varchar(100);
     end-ds;
     num_skids int(10);
     dcl-ds skids dim(15);
            palletization varchar(2);
            skidId varchar(3);

          num_kanbans int(10);
          dcl-ds kanbans dim(200);
                 lineSideAddress varchar(10);
                 partNumber varchar(12);
                 kanban varchar(4);
                 qpc varchar(5);
                 boxNumber varchar(3);
                 rfId varchar(12);
                 manifestNumber varchar(8);
                 kanbanCut varchar(1);
          end-ds;
          num_rfidDetails int(10);
          dcl-ds rfidDetails dim(5);
                 rfid varchar(12);
                 type varchar(5);
          end-ds;
     end-ds;
end-ds;


dcl-s msg char(52);
dcl-s o int(10);
dcl-s s int(10);
dcl-s k int(10);

data-into ords
        %data('/qntc/IAF-AS400-FILE/AS400-TRANS/PC/Upload/jsontest/sdz01.json'
            : 'doc=file case=any countprefix=num_ allowextra=yes')
        %parser('YAJLINTO');


  for o = 1 to num_ords;

    if ords(o).order = *blanks;
      leave;
    ENDIF;

    JSORD# = ords(o).order;
    JSSUPP = ords(o).supplier;
    JSNAMC = ords(o).plant;
    JSNUKE = ords(o).dock;


      for s = 1 to ords(o).num_skids;
        if ords(o).skids(s).skidid = *blanks;
          Leave;
        ENDIF;


        JSSKID = ords(o).skids(s).skidid;
        JSPALT = ords(o).skids(s).palletization;
        JSRFID = ords(o).skids(s).rfidDetails(1).rfid;

          for k = 1 to ords(o).skids(s).num_kanbans;
            if ords(o).skids(s).kanbans(k).kanban = *blanks;
              leave;
            ENDIF;

             JSKANB = ords(o).skids(s).kanbans(k).kanban;
             JSLSAD = ords(o).skids(s).kanbans(k).lineSideAddress;
             JSPART = ords(o).skids(s).kanbans(k).partNumber;
             JSQPC =  ords(o).skids(s).kanbans(k).qpc;
             JSBOXN = ords(o).skids(s).kanbans(k).boxNumber;
             JSMAN# = ords(o).skids(s).kanbans(k).manifestNumber;
             JSCRFI = ords(o).skids(s).kanbans(k).rfid;

             write AM#WP281;

          ENDFOR;
      ENDFOR;
  ENDFOR;
 *inlr = *on;
return;

