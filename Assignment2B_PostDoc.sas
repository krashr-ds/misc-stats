
proc format;
    value pdocF
        0 = 'Post Doc'
        1 = 'Not Post Doc';
    value maritalF
        0 = 'Not married'
        1 = 'Married';
    value agdeptF
        0 = 'Not agricultural'
        1 = 'Agricultural';
run;

data work.import;
	set work.import;
    format  pdoc pdocF.
            marital maritalF.
            agdept agdeptF.;
    
    /* Labels */
    label docrank = 'Rank of Doct Prg';
    label instituteid = 'ID of Doct Prg';
    label under = 'Selectivity of Undergrad Prg';
run;

ods graphics / imagemap=on;
proc glimmix data=work.import method=quad;
   class instituteid 
         marital(ref = 'Not married') 
         agdept(ref = 'Not agricultural');
   model pdoc(event='Post Doc') = age marital docrank under agdept marital*agdept under*agdept / s dist=binary link=logit oddsratio;
   random int / sub=instituteid s cl;
  lsmeans marital*agdept / cl diff oddsratio PLOT=diffplot adjust=tukey;
run;


ods graphics off;


