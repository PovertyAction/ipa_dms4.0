*! version 3.0.0 Innovations for Poverty Action 30oct2018

/*
Non-globals: 
 versionvar - ipatrackversions
 progreport variables/options (target, & targetrate, keepmaster, and keepsurvey, sortby)
 importantvars - incomplete/missing 
 target
 dupvars
 childvars parentvars

  text audit infil: group name and exclude 
 what about sheetreplace/nolabel?
*/



/* =============================================================== 
   ===============================================================
   ============== IPA HIGH FREQUENCY CHECK TEMPLATE  ============= 
   ===============================================================
   =============================================================== */


use "${prepsurveydata}", clear


/* =============================================================== 
   ==================== Survey Tracking ==========================
   =============================================================== */


/* <============ Summarize completed surveys by date ============> */

ipatracksummary using "${trackout}", ///
  submit(${datevar}) ///
  target()   


/* <========== Track 2. Track surveys completed against planned ==========> */

if ${run_progreport} {        
progreport, ///
    master("${mastersurveydata}") /// 
    survey("${prepsurveydata}") /// 
    id(${surveyid}) /// 
    sortby() /// 
    keepmaster() /// 
    keepsurvey() ///
    filename("${trackout}") /// 
    target() ///
	surveyok
}


 /* <======== Track 3. Track form versions used by submission date ========> */
      
ipatrackversions formdef_version, /// 
  id(${surveyid}) ///
  enumerator(${enumid}) ///
  submit(${datevar}) ///
  saving("${trackout}") 

  

/* =============================================================== 
   ==================== High Frequency Checks ==================== 
   =============================================================== */
  
  
/* <=========== HFC 1. Check that all interviews were completed ===========> */


  ipacheckcomplete ${importantvars}, ///
    id(${surveyid}) ///
    enumerator(${enumid}) ///
    date(${datevar}) ///
    keepvars("${keepvars}") ///
    saving("${hfcout}") ///
    sheetreplace ${nolabel}
} 


/* <======== HFC 2. Check that there are no duplicate observations ========> */

  ipacheckdups ${dupvars}, ///
    id(${surveyid}) ///
    enumerator(${enumid}) ///
    submit(${datevar}) ///
    keepvars(${keepvars}) ///
    saving("${hfcout}") ///
    sheetreplace ${nolabel}



/* <================== HFC 9. Check specify other values ==================> */


  ipacheckspecify ${childvars}, ///
    parentvars(${parentvars}) ///
    id(${surveyid}) ///
    enumerator(${enumid}) ///
    submit(${datevar}) ///
    keepvars(${keepvars}) ///
    saving("${hfcout}") ///
    sheetreplace ${nolabel}


/* <============= HFC 11. Check for outliers in unconstrained =============> */

if ${run_outliers} {
  ipacheckoutliers ${outliervars}, id(${surveyid}) ///
    enumerator(${enumid}) ///
    submit(${datevar}) ///
    multiplier(${multiplier11}) ///
    keepvars(${keepvars}) ///
    ignore(${ignore11}) ///
    saving("${hfcout}") ///
    sctodb("${server}") ///
    sheetreplace ${nolabel} ${sd}
}


/* <============= HFC 12. Check for and output field comments =============> */

if !mi("${comments}") {
  ipacheckcomment ${comments}, 
    id(${surveyid}) ///
    media(${dir_media}) ///
    enumerator(${enumid}) ///
    submit(${datevar}) ///
    keepvars(${keepvars}) ///
    saving("${hfcout}") ///
    sheetreplace ${nolabel}
}


/* <=============== HFC 13. Output summaries for text audits ==============> */

if !mi("${textaudit}") {
  ipachecktextaudit ${textaudit} using "${infile}",  ///
    saving("${textauditdb}")  ///
    media("${sctomedia}") ///
    enumerator(${enumid}) ///
    keepvars(${keepvars})
}


   
/* ===============================================================
   =================== Analyze Back Check Data ===================
   =============================================================== */

if ${run_backcheck} {
  ipabcstats, ///
      surveydata("${sdataset}")  ///
      bcdata("${bdataset}")  ///
      id(${surveyid})              ///
      enumerator(${enumid})    ///
      enumteam(${enumteam})  ///
      backchecker(${bcer})   ///
      bcteam(${bcerteam})    ///
      t1vars(${type1_17})    ///
      t2vars(${type2_17})    ///
      t3vars(${type3_17})    ///
      ttest(${ttest17})      ///
      prtest(${prtest17})    ///
      signrank(${srtest17})  ///
      keepbc(${keepbc17})    ///
      keepsurvey(${keepsurvey17}) ///
      reliability(${reliability17}) ///
      filename("${bcfile}") showid("${bcshowrate}") ///
      ${bcexcludemi} okrange(${okrangestr17}) ///
      excludenum(${bcexcludenum}) excludestr(${bcexcludestr}) ///
      nodiffnum(${bcnodiffnum}) nodiffstr(${bcnodiffstr}) ///
      surveydate(${bcsdate}) bcdate(${bcbcdate}) ///
      ${bclower} ${bcupper} ${bcnosymbols} ${bctrim} ///
      ${bcshowall} ${bcfull} ${bcnolabel} ${bcreplace}
}
