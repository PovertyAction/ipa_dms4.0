* import_wbnp_hhs_2021.do
*
* 	Imports and aggregates "WB Nutrition Project - Household Survey" (ID: wbnp_hhs_2021) data.
*
*	Inputs:  "D:/Files/IPA SL DMS/05_data/02_survey/WB Nutrition Project - Household Survey_WIDE.csv"
*	Outputs: "D:/Files/IPA SL DMS/05_data/02_survey/WB Nutrition Project - Household Survey.dta"
*
*	Output by SurveyCTO November 24, 2021 1:15 PM.

* initialize Stata
clear all
set more off
set mem 100m

* initialize workflow-specific parameters
*	Set overwrite_old_data to 1 if you use the review and correction
*	workflow and allow un-approving of submissions. If you do this,
*	incoming data will overwrite old data, so you won't want to make
*	changes to data in your local .dta file (such changes can be
*	overwritten with each new import).
local overwrite_old_data 0

* initialize form-specific parameters
local csvfile "${cwd}/4_data/2_survey/WB Nutrition Project - Household Survey_WIDE.csv"
local dtafile "${cwd}/4_data/2_survey/WB Nutrition Project - Household Survey.dta"
local corrfile "${cwd}/4_data/2_survey/WB Nutrition Project - Household Survey_corrections.csv"
local note_fields1 ""
local text_fields1 "deviceid subscriberid simid devicephonenum username duration caseid field_comments textaudit pd_enums pd_phu pd_datetable enum_id enum_name community_id community district chiefdom_id chiefdom phu_id"
local text_fields2 "phu ea_shortcode treatment_status hhid_struct_num_disp hhid_hh_num_disp hhid hhm_rpt_count hhm_ind_* hhm_id_* fmemb_fn_* fmemb_sn_* fmemb_popn_* fmemb_fullname_* hl4_dsp_* hl5_dob_dmy_calc_*"
local text_fields3 "hl5_dob_my_calc_* hl5_dob_y_calc_* hl6_age_* ed11b_osp_* ed13_* ed13_osp_* hhm_add_dsp_* hhm_add_dsp_join hhm_rpt_cnt hhm_rpt_control hhm_u5_cnt hhm_u5_ind_join hhm_fem_13aa_cnt hhm_fem_13aa_ind_join"
local text_fields4 "hhm_mal_13aa_cnt hhm_mal_13aa_ind_join hhm_13aa_cnt hhm_13aa_ind_join hhm_18aa_ind_join hhm_u17_cnt hhm_u17_ind_join hhm_u17_name_join hhm_5_17_cnt hhm_5_17_ind_join hhm_fem_15_49_cnt"
local text_fields5 "hhm_fem_15_49_ind_join hhm_mal_15_19_cnt hhm_mal_15_19_ind_join hhm_name_1 hhm_name_2 hhm_name_3 hhm_name_4 hhm_name_5 hhm_name_6 hhm_name_7 hhm_name_8 hhm_name_9 hhm_name_10 hhm_name_11 hhm_name_12"
local text_fields6 "hhm_name_13 hhm_name_14 hhm_name_15 hhm_name_16 hhm_name_17 hhm_name_18 hhm_name_19 hhm_name_20 hhm_name_21 hhm_name_22 hhm_name_23 hhm_name_24 hhm_name_25 hhm_name_26 hhm_name_27 hhm_name_28"
local text_fields7 "hhm_name_29 hhm_name_30 hhm_name_31 hhm_name_32 hhm_name_33 hhm_name_34 hhm_name_35 hhm_name_36 hhm_name_37 hhm_name_38 hhm_name_39 hhm_name_40 hhm_name_41 hhm_name_42 hhm_name_43 hhm_name_44"
local text_fields8 "hhm_name_45 hhm_name_46 hhm_name_47 hhm_name_48 hhm_name_49 hhm_name_50 hhm_ch_rpt_count hhm_ch_ind_* hhm_ch_hr_ind_* hhm_ch_hr_id_* hhm_ch_hr_age_* hhm_ch_hr_gender_* hhm_ch_hr_fullname_*"
local text_fields9 "hl13b_name_* hl13b_id_* hl13b_age_* hl17b_name_* hl17b_id_* hl17b_age_* hl20_oth_name_* hl20_oth_id_* hl20_oth_age_* hhm_ch_ct_hr_ind_* hhm_ch_ct_name_* hhm_ch_ct_hr_id_* hhm_ch_cnt hhm_ch_ct_cnt"
local text_fields10 "hhm_ch_ct_ind_join hhm_ch_ct_hr_ind_join hhm_ch_ct_rand hhm_ch_ct_rand_sel hhm_ch_ct_rand_sel_ind hhm_5_17_sel_ind hhm_5_17_sel_name hhm_5_17_sel_id hhm_5_17_ct_ind hhm_5_17_ct_name hhm_5_17_ct_id"
local text_fields11 "hhm_ch_noct_15_17_cnt hhm_ch_noct_15_17_ind_join hhm_ch_15_17_cons_cnt hhm_ch_15_17_cons_ind_join iw_rpt_count iw_ind_* iw_hr_ind_* iw_hr_id_* iw_hr_fullname_* iw_hr_age_* iw_consent_* u5_rpt_count"
local text_fields12 "u5_ind_* u5_hr_ind_* u5_hr_id_* u5_hr_fullname_* u5_hr_age_* u5_ct_ind_pos_* u5_ct_hr_ind_* u5_ct_hr_id_* u5_ct_hr_name_* hc1a_osp hc1b_osp hc2_osp hc4_osp hc5_osp hc6_osp hc14_osp hc18 st_rpt_count"
local text_fields13 "st_ind_* st_other_name_* st_name_* st_rpt_cnt st_rpt_control eu1_osp eu4_osp eu5_osp eu6_osp eu8_osp eu9_osp tn_rpt_count tn_ind_* tn5_brand_type_osp_* tn5_other_type_osp_* tn6_* tn8_* tn11_*"
local text_fields14 "tn12_osp_* tn14_* tn15_* irs2 irs2_osp ws1_osp ws2_osp ws5_name ws6_day_index ws6_dow ws8_osp ws10 ws10_osp ws11_osp ws13_osp hw1_osp hw4_osp hw7 dc1_rpt_count dc1_ind_* dc2b_* survey_language_osp"
local text_fields15 "survey_accomp_enum survey_accomp_enum_osp comments instanceid"
local date_fields1 "hl5_dob_dmy_* hl5_dob_my_* hl5_dob_y_* dc4_* dc5_*"
local datetime_fields1 "submissiondate starttime endtime"

disp
disp "Starting import of: `csvfile'"
disp

* import data from primary .csv file
insheet using "`csvfile'", names clear

* drop extra table-list columns
cap drop reserved_name_for_field_*
cap drop generated_table_list_lab*

* continue only if there's at least one row of data to import
if _N>0 {
	* drop note fields (since they don't contain any real data)
	forvalues i = 1/100 {
		if "`note_fields`i''" ~= "" {
			drop `note_fields`i''
		}
	}
	
	* format date and date/time fields
	forvalues i = 1/100 {
		if "`datetime_fields`i''" ~= "" {
			foreach dtvarlist in `datetime_fields`i'' {
				cap unab dtvarlist : `dtvarlist'
				if _rc==0 {
					foreach dtvar in `dtvarlist' {
						tempvar tempdtvar
						rename `dtvar' `tempdtvar'
						gen double `dtvar'=.
						cap replace `dtvar'=clock(`tempdtvar',"MDYhms",2025)
						* automatically try without seconds, just in case
						cap replace `dtvar'=clock(`tempdtvar',"MDYhm",2025) if `dtvar'==. & `tempdtvar'~=""
						format %tc `dtvar'
						drop `tempdtvar'
					}
				}
			}
		}
		if "`date_fields`i''" ~= "" {
			foreach dtvarlist in `date_fields`i'' {
				cap unab dtvarlist : `dtvarlist'
				if _rc==0 {
					foreach dtvar in `dtvarlist' {
						tempvar tempdtvar
						rename `dtvar' `tempdtvar'
						gen double `dtvar'=.
						cap replace `dtvar'=date(`tempdtvar',"MDY",2025)
						format %td `dtvar'
						drop `tempdtvar'
					}
				}
			}
		}
	}

	* ensure that text fields are always imported as strings (with "" for missing values)
	* (note that we treat "calculate" fields as text; you can destring later if you wish)
	tempvar ismissingvar
	quietly: gen `ismissingvar'=.
	forvalues i = 1/100 {
		if "`text_fields`i''" ~= "" {
			foreach svarlist in `text_fields`i'' {
				cap unab svarlist : `svarlist'
				if _rc==0 {
					foreach stringvar in `svarlist' {
						quietly: replace `ismissingvar'=.
						quietly: cap replace `ismissingvar'=1 if `stringvar'==.
						cap tostring `stringvar', format(%100.0g) replace
						cap replace `stringvar'="" if `ismissingvar'==1
					}
				}
			}
		}
	}
	quietly: drop `ismissingvar'

	* consolidate unique ID into "key" variable
	replace key=instanceid if key==""
	drop instanceid


	* label variables
	label variable key "Unique submission ID"
	cap label variable submissiondate "Date/time submitted"
	cap label variable formdef_version "Form version used on device"
	cap label variable review_status "Review status"
	cap label variable review_comments "Comments made during review"
	cap label variable review_corrections "Corrections made during review"


	label variable gpslatitude "Auto-record GPS (latitude)"
	note gpslatitude: "Auto-record GPS (latitude)"

	label variable gpslongitude "Auto-record GPS (longitude)"
	note gpslongitude: "Auto-record GPS (longitude)"

	label variable gpsaltitude "Auto-record GPS (altitude)"
	note gpsaltitude: "Auto-record GPS (altitude)"

	label variable gpsaccuracy "Auto-record GPS (accuracy)"
	note gpsaccuracy: "Auto-record GPS (accuracy)"

	label variable enum_id "Enumerator ID"
	note enum_id: "Enumerator ID"

	label variable enum_confirm ""
	note enum_confirm: ""
	label define enum_confirm 1 "YES" 0 "NO" -999 "DON'T KNOW"
	label values enum_confirm enum_confirm

	label variable community_id "Select Community"
	note community_id: "Select Community"

	label variable comm_confirm ""
	note comm_confirm: ""
	label define comm_confirm 1 "YES" 0 "NO"
	label values comm_confirm comm_confirm

	label variable hhid_struct_num "Building/Compound Number"
	note hhid_struct_num: "Building/Compound Number"

	label variable hhid_hh_num "Household Number"
	note hhid_hh_num: "Household Number"

	label variable hhid_confirm ""
	note hhid_confirm: ""
	label define hhid_confirm 1 "YES" 0 "NO"
	label values hhid_confirm hhid_confirm

	label variable consent "Do you consent to this interview?"
	note consent: "Do you consent to this interview?"
	label define consent 1 "YES" 0 "NO"
	label values consent consent

	label variable hhm_cnt "How many people live in your household including yourself? We mean only the peop"
	note hhm_cnt: "How many people live in your household including yourself? We mean only the people (men, women and children) that usually eat from the same pot as you."

	* label variable tmp_hhm_corr "Discrepancy in household member count You earlier stated that there are \${hhm_c"
	* note tmp_hhm_corr: "Discrepancy in household member count You earlier stated that there are \${hhm_cnt} household members in your household, however, we have listed a total of \${hhm_rpt_cnt} members. Can you confirm that \${hhm_rpt_cnt} is the actual number of members in your household?"
	* label define tmp_hhm_corr 1 "YES" 0 "NO"
	* label values tmp_hhm_corr tmp_hhm_corr

	label variable hc1a "(HC1A) What is the religion of the head of the household?"
	note hc1a: "(HC1A) What is the religion of the head of the household?"
	label define hc1a 1 "NO RELIGION" 2 "CHRISTIAN" 3 "ISLAM" 4 "TRADITIONAL" -666 "OTHER RELIGION (SPECIFY)"
	label values hc1a hc1a

	label variable hc1a_osp "(HC1.O) Other specify: Religion of the head of the household"
	note hc1a_osp: "(HC1.O) Other specify: Religion of the head of the household"

	label variable hc1b "(HC1B) What is the mother tongue/native language of the head of the household?"
	note hc1b: "(HC1B) What is the mother tongue/native language of the head of the household?"
	label define hc1b 1 "KRIO" 2 "MENDE" 3 "TEMNE" 4 "MANDINGO" 5 "LOKO" 6 "SHERBRO" 7 "LIMBA" 8 "KISSI" 9 "KONO" 10 "SUSU" 11 "FULLAH" 12 "KRIM" 13 "YALUNKA" 14 "KORANKO" 15 "VAI" -666 "OTHER LANGUAGE (SPECIFY)"
	label values hc1b hc1b

	label variable hc1b_osp "(HC1B.O) Other specify: Mother tongue/native language of the head of the househo"
	note hc1b_osp: "(HC1B.O) Other specify: Mother tongue/native language of the head of the household?"

	label variable hc2 "(HC2) To what ethnic group does the head of the household belong?"
	note hc2: "(HC2) To what ethnic group does the head of the household belong?"
	label define hc2 1 "KRIO" 2 "MENDE" 3 "TEMNE" 4 "MANDINGO" 5 "LOKO" 6 "SHERBRO" 7 "LIMBA" 8 "KISSI" 9 "KONO" 10 "SUSU" 11 "FULLAH" 12 "KRIM" 13 "YALUNKA" 14 "KORANKO" 15 "VAI" -666 "OTHER LANGUAGE (SPECIFY)"
	label values hc2 hc2

	label variable hc2_osp "(HC2) Other specify: What ethnic group does the head of the household belong"
	note hc2_osp: "(HC2) Other specify: What ethnic group does the head of the household belong"

	label variable hc3 "(HC3) How many rooms do members of this household usually use for sleeping?"
	note hc3: "(HC3) How many rooms do members of this household usually use for sleeping?"

	label variable hc4 "(HC4) Main material of the dwelling floor?"
	note hc4: "(HC4) Main material of the dwelling floor?"
	label define hc4 1 "EARTH / SAND" 2 "DUNG" 3 "WOOD PLANKS" 4 "PALM / BAMBOO" 5 "PARQUET OR POLISHED WOOD" 6 "VINYL OR ASPHALT STRIPS" 7 "CERAMIC TILES" 8 "CEMENT" 9 "CARPET" -666 "OTHER (SPECIFY)"
	label values hc4 hc4

	label variable hc4_osp "(HC4.O) Other specify: Main material of the dwelling floor."
	note hc4_osp: "(HC4.O) Other specify: Main material of the dwelling floor."

	label variable hc5 "(HC5) Main material of the roof"
	note hc5: "(HC5) Main material of the roof"
	label define hc5 1 "NO ROOF" 2 "THATCH / PALM LEAF" 3 "SOD" 4 "RUSTIC MAT" 5 "PALM / BAMBOO" 6 "WOOD PLANKS" 7 "CARDBOARD" 8 "METAL / TIN / CORRUGATED IRON SHEETS (ZINC)" 9 "WOOD" 10 "CALAMINE / CEMENT FIBRE" 11 "CERAMIC TILES" 12 "CEMENT" 13 "ROOFING SHINGLES" -666 "OTHER (SPECIFY)"
	label values hc5 hc5

	label variable hc5_osp "(HC5.O) Other specify: Main material of the dwelling roof."
	note hc5_osp: "(HC5.O) Other specify: Main material of the dwelling roof."

	label variable hc6 "(HC6) Main material of the exterior walls."
	note hc6: "(HC6) Main material of the exterior walls."
	label define hc6 1 "NO WALLS" 2 "CANE / PALM / TRUNKS" 3 "DIRT" 4 "BAMBOO WITH MUD" 5 "STONE WITH MUD" 6 "UNCOVERED ADOBE" 7 "PLYWOOD" 8 "CARDBOARD" 9 "REUSED WOOD" 10 "CORRUGATED IRON SHEETS (ZINC)" 11 "CEMENT" 12 "STONE WITH LIME / CEMENT2" 13 "BRICKS" 14 "CEMENT BLOCKS" 15 "COVERED ADOBE" 16 "WOOD PLANKS / SHINGLES" -666 "OTHER (SPECIFY)"
	label values hc6 hc6

	label variable hc6_osp "(HC6.O) Other specify: Main material of the dwelling exterior wall."
	note hc6_osp: "(HC6.O) Other specify: Main material of the dwelling exterior wall."

	label variable hc7_label ""
	note hc7_label: ""
	label define hc7_label 1 "Yes, Working" 2 "Yes, Not Working" 0 "No"
	label values hc7_label hc7_label

	label variable hc7a "(HC7A) A fixed telephone line"
	note hc7a: "(HC7A) A fixed telephone line"
	label define hc7a 1 "Yes, Working" 2 "Yes, Not Working" 0 "No"
	label values hc7a hc7a

	label variable hc7b "(HC7B) A radio"
	note hc7b: "(HC7B) A radio"
	label define hc7b 1 "Yes, Working" 2 "Yes, Not Working" 0 "No"
	label values hc7b hc7b

	label variable hc7c "(HC7C) A Charcoal iron"
	note hc7c: "(HC7C) A Charcoal iron"
	label define hc7c 1 "Yes, Working" 2 "Yes, Not Working" 0 "No"
	label values hc7c hc7c

	label variable hc7d "(HC7D) A Bed"
	note hc7d: "(HC7D) A Bed"
	label define hc7d 1 "Yes, Working" 2 "Yes, Not Working" 0 "No"
	label values hc7d hc7d

	label variable hc7e "(HC7E) A Sofa"
	note hc7e: "(HC7E) A Sofa"
	label define hc7e 1 "Yes, Working" 2 "Yes, Not Working" 0 "No"
	label values hc7e hc7e

	label variable hc7f "(HC7F) A Generator"
	note hc7f: "(HC7F) A Generator"
	label define hc7f 1 "Yes, Working" 2 "Yes, Not Working" 0 "No"
	label values hc7f hc7f

	label variable hc7g "(HC7G) A Modern Stove"
	note hc7g: "(HC7G) A Modern Stove"
	label define hc7g 1 "Yes, Working" 2 "Yes, Not Working" 0 "No"
	label values hc7g hc7g

	label variable hc8 "(HC8) Does your household have electricity?"
	note hc8: "(HC8) Does your household have electricity?"
	label define hc8 1 "YES, INTERCONNECTED GRID" 2 "YES, OFF-GRID (GENERATOR/ISOLATED SYSTEM)" 0 "NO"
	label values hc8 hc8

	label variable hc9_labels ""
	note hc9_labels: ""
	label define hc9_labels 1 "Yes, Working" 2 "Yes, Not Working" 0 "No"
	label values hc9_labels hc9_labels

	label variable hc9a "(HC9A) A television"
	note hc9a: "(HC9A) A television"
	label define hc9a 1 "Yes, Working" 2 "Yes, Not Working" 0 "No"
	label values hc9a hc9a

	label variable hc9b "(HC9B) A refrigerator or Freezer"
	note hc9b: "(HC9B) A refrigerator or Freezer"
	label define hc9b 1 "Yes, Working" 2 "Yes, Not Working" 0 "No"
	label values hc9b hc9b

	label variable hc9c "(HC9C) Electrical Iron"
	note hc9c: "(HC9C) Electrical Iron"
	label define hc9c 1 "Yes, Working" 2 "Yes, Not Working" 0 "No"
	label values hc9c hc9c

	label variable hc9d "-"
	note hc9d: "-"
	label define hc9d 1 "Yes, Working" 2 "Yes, Not Working" 0 "No"
	label values hc9d hc9d

	label variable hc9e "(HC9D) Fan"
	note hc9e: "(HC9D) Fan"
	label define hc9e 1 "Yes, Working" 2 "Yes, Not Working" 0 "No"
	label values hc9e hc9e

	label variable hc10_labels ""
	note hc10_labels: ""
	label define hc10_labels 1 "Yes, Working" 2 "Yes, Not Working" 0 "No"
	label values hc10_labels hc10_labels

	label variable hc10a "(HC10A) A watch"
	note hc10a: "(HC10A) A watch"
	label define hc10a 1 "Yes, Working" 2 "Yes, Not Working" 0 "No"
	label values hc10a hc10a

	label variable hc10b "(HC10B) A bicycle"
	note hc10b: "(HC10B) A bicycle"
	label define hc10b 1 "Yes, Working" 2 "Yes, Not Working" 0 "No"
	label values hc10b hc10b

	label variable hc10c "(HC10C) A motorcycle or scooter"
	note hc10c: "(HC10C) A motorcycle or scooter"
	label define hc10c 1 "Yes, Working" 2 "Yes, Not Working" 0 "No"
	label values hc10c hc10c

	label variable hc10d "(HC10D) An animal-drawn cart"
	note hc10d: "(HC10D) An animal-drawn cart"
	label define hc10d 1 "Yes, Working" 2 "Yes, Not Working" 0 "No"
	label values hc10d hc10d

	label variable hc10e "(HC10E) A car, truck or van"
	note hc10e: "(HC10E) A car, truck or van"
	label define hc10e 1 "Yes, Working" 2 "Yes, Not Working" 0 "No"
	label values hc10e hc10e

	label variable hc10f "(HC10F) A boat with a motor"
	note hc10f: "(HC10F) A boat with a motor"
	label define hc10f 1 "Yes, Working" 2 "Yes, Not Working" 0 "No"
	label values hc10f hc10f

	label variable hc10g "(HC10G) A boat without a motor (Paddle)"
	note hc10g: "(HC10G) A boat without a motor (Paddle)"
	label define hc10g 1 "Yes, Working" 2 "Yes, Not Working" 0 "No"
	label values hc10g hc10g

	label variable hc11 "(HC11) Does any member of your household have a computer or a tablet?"
	note hc11: "(HC11) Does any member of your household have a computer or a tablet?"
	label define hc11 1 "YES" 0 "NO" -999 "DON'T KNOW"
	label values hc11 hc11

	label variable hc12 "(HC12) Does any member of your household have a mobile telephone?"
	note hc12: "(HC12) Does any member of your household have a mobile telephone?"
	label define hc12 1 "YES" 0 "NO" -999 "DON'T KNOW"
	label values hc12 hc12

	label variable hc13 "(HC13) Does your household have access to internet at home?"
	note hc13: "(HC13) Does your household have access to internet at home?"
	label define hc13 1 "YES" 0 "NO" -999 "DON'T KNOW"
	label values hc13 hc13

	label variable hc14 "(HC14) Do you or someone living in this household own this dwelling?"
	note hc14: "(HC14) Do you or someone living in this household own this dwelling?"
	label define hc14 1 "OWN" 2 "RENT" -666 "OTHER (SPECIFY)"
	label values hc14 hc14

	label variable hc14_osp "(HC14.O) Other specify: Do you rent this dwelling from someone not living in thi"
	note hc14_osp: "(HC14.O) Other specify: Do you rent this dwelling from someone not living in this household?"

	label variable hc15 "(HC15) Does any member of this household own any land that can be used for agric"
	note hc15: "(HC15) Does any member of this household own any land that can be used for agriculture?"
	label define hc15 1 "YES" 0 "NO" -999 "DON'T KNOW"
	label values hc15 hc15

	label variable hc16a "(HC16) How many acres of agricultural land do members of this household own?"
	note hc16a: "(HC16) How many acres of agricultural land do members of this household own?"

	label variable hc16b "(HC16.B) Please indate the agricultural land unit"
	note hc16b: "(HC16.B) Please indate the agricultural land unit"
	label define hc16b 1 "Acres" 2 "Bushel"
	label values hc16b hc16b

	label variable hc17 "(HC17A) Does this household own any livestock, herds, other farm animals, or pou"
	note hc17: "(HC17A) Does this household own any livestock, herds, other farm animals, or poultry?"
	label define hc17 1 "YES" 0 "NO" -999 "DON'T KNOW"
	label values hc17 hc17

	label variable hc18 "(HC18) Which of the following animals does this household have?"
	note hc18: "(HC18) Which of the following animals does this household have?"

	label variable hc18a "(HC18A) Milk cows or Bulls"
	note hc18a: "(HC18A) Milk cows or Bulls"

	label variable hc18b "(HC18B) Other Cattle"
	note hc18b: "(HC18B) Other Cattle"

	label variable hc18d "(HC18D) Goats"
	note hc18d: "(HC18D) Goats"

	label variable hc18e "(HC18E) Sheep"
	note hc18e: "(HC18E) Sheep"

	label variable hc18f "(HC18F) Chickens"
	note hc18f: "(HC18F) Chickens"

	label variable hc18g "(HC18G) Pigs"
	note hc18g: "(HC18G) Pigs"

	label variable hc18h "(HC18H) Ducks"
	note hc18h: "(HC18H) Ducks"

	label variable hc19 "(HC19) Does any member of this household have a bank account?"
	note hc19: "(HC19) Does any member of this household have a bank account?"
	label define hc19 1 "YES" 0 "NO" -999 "DON'T KNOW"
	label values hc19 hc19

	label variable tmp_st "Temp Field: Expected to be all missing"
	note tmp_st: "Temp Field: Expected to be all missing"
	label define tmp_st 1 "CASH FOR WORK" 2 "SOCIAL SAFETY NET (SSN)" 3 "RAPID EBOLA SOCIAL SAFETY NET (RE-SSN)" 4 "RAPID COVID-19 SOCIAL SAFETY NET" 5 "PENSION BENEFITS"
	label values tmp_st tmp_st

	label variable eu1 "(EU1) In your household, what type of cookstove is mainly used for cooking?"
	note eu1: "(EU1) In your household, what type of cookstove is mainly used for cooking?"
	label define eu1 1 "ELECTRIC STOVE" 2 "SOLAR COOKER LIQUEFIED PETROLEUM GAS (LPG)/ COOKING GAS STOVE" 3 "COOKING GAS STOVE" 4 "PIPED NATURAL GAS STOVE" 5 "BIOGAS STOVE" 6 "LIQUID FUEL STOVE" 7 "MANUFACTURED SOLID FUEL STOVE" 8 "TRADITIONAL SOLID FUEL STOVE" 9 "THREE STONE STOVE / OPEN FIRE" -666 "OTHER (SPECIFY)" 0 "NO FOOD COOKED IN HOUSEHOLD"
	label values eu1 eu1

	label variable eu1_osp "(EU1.O) Other specify: What type of cookstove is mainly used for cooking?"
	note eu1_osp: "(EU1.O) Other specify: What type of cookstove is mainly used for cooking?"

	label variable eu2 "-"
	note eu2: "-"
	label define eu2 1 "YES" 0 "NO" -999 "DON'T KNOW"
	label values eu2 eu2

	label variable eu3 "(EU3) Does it have a fan?"
	note eu3: "(EU3) Does it have a fan?"
	label define eu3 1 "YES" 0 "NO" -999 "DON'T KNOW"
	label values eu3 eu3

	label variable eu4 "(EU4) What type of fuel or energy source is used in this cookstove?"
	note eu4: "(EU4) What type of fuel or energy source is used in this cookstove?"
	label define eu4 1 "ALCOHOL / ETHANOL" 2 "GASOLINE / DIESEL" 3 "KEROSENE / PARAFFIN" 4 "COAL / LIGNITE" 5 "CHARCOAL" 6 "WOOD" 7 "CROP RESIDUE / GRASS /STRAW / SHRUBS" 8 "ANIMAL DUNG / WASTE" 9 "PROCESSED BIOMASS (PELLETS) OR WOODCHIPS" 10 "GARBAGE / PLASTIC" 11 "SAWDUST" -666 "OTHER (SPECIFY)"
	label values eu4 eu4

	label variable eu4_osp "(EU4.O) Other specify: What type of fuel or energy source is used in this cookst"
	note eu4_osp: "(EU4.O) Other specify: What type of fuel or energy source is used in this cookstove?"

	label variable eu5 "(EU5) Is the cooking usually done in the house, in a separate building, or outdo"
	note eu5: "(EU5) Is the cooking usually done in the house, in a separate building, or outdoors?"
	label define eu5 1 "IN MAIN HOUSE: NO SEPARATE ROOM" 2 "IN MAIN HOUSE: IN A SEPARATE ROOM" 3 "IN A SEPARATE BUILDING" 4 "OUTDOORS: OPEN AIR" 5 "OUTDOORS: ON VERANDA OR COVERED PORCH" 6 "OUTSIDE HUT" -666 "OTHER (SPECIFY)"
	label values eu5 eu5

	label variable eu5_osp "(EU5.O) Other specify: Where is cooking usually done?"
	note eu5_osp: "(EU5.O) Other specify: Where is cooking usually done?"

	label variable eu6 "(EU6) What does your household mainly use for space heating when needed?"
	note eu6: "(EU6) What does your household mainly use for space heating when needed?"
	label define eu6 1 "CENTRAL HEATING" 2 "MANUFACTURED SPACE HEATER" 3 "TRADITIONAL SPACE HEATER" 4 "MANUFACTURED COOKSTOVE" 5 "TRADITIONAL COOKSTOVE" 6 "THREE STONE STOVE / OPEN FIRE" 0 "NO SPACE HEATING IN HOUSEHOLD" -666 "OTHER (SPECIFY)"
	label values eu6 eu6

	label variable eu6_osp "(EU6.O) Other specify: What does your household mainly use for space heating whe"
	note eu6_osp: "(EU6.O) Other specify: What does your household mainly use for space heating when needed?"

	label variable eu7 "(EU7) Does it have a chimney?"
	note eu7: "(EU7) Does it have a chimney?"
	label define eu7 1 "YES" 0 "NO" -999 "DON'T KNOW"
	label values eu7 eu7

	label variable eu8 "(EU8) What type of fuel and energy source is used in this heater?"
	note eu8: "(EU8) What type of fuel and energy source is used in this heater?"
	label define eu8 1 "SOLAR AIR HEATER" 2 "ELECTRICITY" 3 "PIPED NATURAL GAS" 4 "LIQUEFIED PETROLEUM GAS (LPG)/ COOKING GAS" 5 "BIOGAS" 6 "ALCOHOL / ETHANOL" 7 "GASOLINE / DIESEL" 8 "KEROSENE / PARAFFIN" 9 "COAL / LIGNITE" 10 "CHARCOAL" 11 "WOOD" 12 "CROP RESIDUE / GRASS /STRAW / SHRUBS" 13 "ANIMAL DUNG / WASTE" 14 "PROCESSED BIOMASS (PELLETS) OR WOODCHIPS" 15 "GARBAGE / PLASTIC" 16 "SAWDUST" -666 "OTHER (SPECIFY)"
	label values eu8 eu8

	label variable eu8_osp "(EU8.O) Other specify: What type of fuel and energy source is used in this heate"
	note eu8_osp: "(EU8.O) Other specify: What type of fuel and energy source is used in this heater?"

	label variable eu9 "(EU9) At night, what does your household mainly use to light the household?"
	note eu9: "(EU9) At night, what does your household mainly use to light the household?"
	label define eu9 1 "ELECTRICITY" 2 "SOLAR LANTERN" 3 "RECHARGEABLE FLASHLIGHT, TORCH OR LANTERN" 4 "BATTERY POWERED FLASHLIGHT, TORCH OR LANTERN" 5 "BIOGAS LAMP" 6 "GASOLINE LAMP" 7 "KEROSENE OR PARAFFIN LAMP" 8 "CHARCOAL" 9 "WOOD" 10 "CROP RESIDUE / GRASS / STRAW / SHRUBS" 11 "ANIMAL DUNG / WASTE" 12 "OIL LAMP" 13 "CANDLE" 14 "NO LIGHTING IN HOUSEHOLD" -666 "OTHER (SPECIFY)"
	label values eu9 eu9

	label variable eu9_osp "(EU9_b) Other specify: What does your household mainly use to light the househol"
	note eu9_osp: "(EU9_b) Other specify: What does your household mainly use to light the household?"

	label variable tn1 "(TN1) Does your household have any mosquito nets?"
	note tn1: "(TN1) Does your household have any mosquito nets?"
	label define tn1 1 "YES" 0 "NO" -999 "DON'T KNOW"
	label values tn1 tn1

	label variable tn2 "(TN2) How many mosquito nets does your household have?"
	note tn2: "(TN2) How many mosquito nets does your household have?"

	label variable irs1 "(IRS1) At any time in the past 12 months, has anyone come into your dwelling to "
	note irs1: "(IRS1) At any time in the past 12 months, has anyone come into your dwelling to spray the interior walls against mosquitoes?"
	label define irs1 1 "YES" 0 "NO" -999 "DON'T KNOW"
	label values irs1 irs1

	label variable irs2 "(IRS2) Who sprayed the dwelling?"
	note irs2: "(IRS2) Who sprayed the dwelling?"

	label variable irs2_osp "Other specify: Who sprayed the dwelling?"
	note irs2_osp: "Other specify: Who sprayed the dwelling?"

	label variable ws1 "(WS1) What is the main source of drinking water used by members of your househol"
	note ws1: "(WS1) What is the main source of drinking water used by members of your household?"
	label define ws1 11 "PIPED WATER: PIPED INTO DWELLING" 12 "PIPED WATER: PIPED TO YARD / PLOT" 13 "PIPED WATER: PIPED TO NEIGHBOUR" 14 "PIPED WATER: PUBLIC TAP / STANDPIPE" 21 "TUBE WELL / BOREHOLE" 31 "DUG WELL: PROTECTED WELL" 32 "DUG WELL: UNPROTECTED WELL" 41 "SPRING: PROTECTED SPRING" 42 "SPRING: UNPROTECTED SPRING" 51 "RAINWATER" 61 "TANKER-TRUCK" 71 "CART WITH SMALL TANK" 72 "WATER KIOSK" 81 "SURFACE WATER (RIVER, DAM, LAKE, POND, STREAM, CANAL, IRRIGATION CHANNEL)" 91 "PACKAGED WATER: BOTTLED WATER" 92 "PACKAGED WATER: SACHET WATER" -666 "OTHER (SPECIFY)"
	label values ws1 ws1

	label variable ws1_osp "(WS1.O) Other specify: Main source of drinking water used by members of your hou"
	note ws1_osp: "(WS1.O) Other specify: Main source of drinking water used by members of your household"

	label variable ws2 "(WS2) What is the main source of water used by members of your household for oth"
	note ws2: "(WS2) What is the main source of water used by members of your household for other purposes such as cooking and handwashing?"
	label define ws2 11 "PIPED WATER: PIPED INTO DWELLING" 12 "PIPED WATER: PIPED TO YARD / PLOT" 13 "PIPED WATER: PIPED TO NEIGHBOUR" 14 "PIPED WATER: PUBLIC TAP / STANDPIPE" 21 "TUBE WELL / BOREHOLE" 31 "DUG WELL: PROTECTED WELL" 32 "DUG WELL: UNPROTECTED WELL" 41 "SPRING: PROTECTED SPRING" 42 "SPRING: UNPROTECTED SPRING" 51 "RAINWATER" 61 "TANKER-TRUCK" 71 "CART WITH SMALL TANK" 72 "WATER KIOSK" 81 "SURFACE WATER (RIVER, DAM, LAKE, POND, STREAM, CANAL, IRRIGATION CHANNEL)" 91 "PACKAGED WATER: BOTTLED WATER" 92 "PACKAGED WATER: SACHET WATER" -666 "OTHER (SPECIFY)"
	label values ws2 ws2

	label variable ws2_osp "(WS1.O) Other specify: main source of water used by members of your household fo"
	note ws2_osp: "(WS1.O) Other specify: main source of water used by members of your household for other purposes such as cooking and handwashing?"

	label variable ws3 "(WS3) Where is that water source located?"
	note ws3: "(WS3) Where is that water source located?"
	label define ws3 1 "IN OWN DWELLING" 2 "IN OWN YARD / PLOT" 3 "ELSEWHERE"
	label values ws3 ws3

	label variable ws4 "(WS4) How long does it take for members of your household to go there, get water"
	note ws4: "(WS4) How long does it take for members of your household to go there, get water, and come back?"

	label variable ws5 "(WS5A) Who usually goes to this source to collect the water for your household?"
	note ws5: "(WS5A) Who usually goes to this source to collect the water for your household?"
	label define ws5 1 "\${hhm_name_1}" 2 "\${hhm_name_2}" 3 "\${hhm_name_3}" 4 "\${hhm_name_4}" 5 "\${hhm_name_5}" 6 "\${hhm_name_6}" 7 "\${hhm_name_7}" 8 "\${hhm_name_8}" 9 "\${hhm_name_9}" 10 "\${hhm_name_10}" 11 "\${hhm_name_11}" 12 "\${hhm_name_12}" 13 "\${hhm_name_13}" 14 "\${hhm_name_14}" 15 "\${hhm_name_15}" 16 "\${hhm_name_16}" 17 "\${hhm_name_17}" 18 "\${hhm_name_18}" 19 "\${hhm_name_19}" 20 "\${hhm_name_20}" 21 "\${hhm_name_21}" 22 "\${hhm_name_22}" 23 "\${hhm_name_23}" 24 "\${hhm_name_24}" 25 "\${hhm_name_25}" 26 "\${hhm_name_26}" 27 "\${hhm_name_27}" 28 "\${hhm_name_28}" 29 "\${hhm_name_29}" 30 "\${hhm_name_30}" 31 "\${hhm_name_31}" 32 "\${hhm_name_32}" 33 "\${hhm_name_33}" 34 "\${hhm_name_34}" 35 "\${hhm_name_35}" 36 "\${hhm_name_36}" 37 "\${hhm_name_37}" 38 "\${hhm_name_38}" 39 "\${hhm_name_39}" 40 "\${hhm_name_40}" 41 "\${hhm_name_41}" 42 "\${hhm_name_42}" 43 "\${hhm_name_43}" 44 "\${hhm_name_44}" 45 "\${hhm_name_45}" 46 "\${hhm_name_46}" 47 "\${hhm_name_47}" 48 "\${hhm_name_48}" 49 "\${hhm_name_49}" 50 "\${hhm_name_50}" 0 "None Household Member"
	label values ws5 ws5

	label variable ws6 "(WS6) Since last \${ws6_dow}, how many times has this \${ws5_name} collected wat"
	note ws6: "(WS6) Since last \${ws6_dow}, how many times has this \${ws5_name} collected water?"

	label variable ws7 "(WS7) In the last month, has there been any time when your household did not hav"
	note ws7: "(WS7) In the last month, has there been any time when your household did not have sufficient quantities of drinking water?"
	label define ws7 1 "YES, AT LEAST ONCE" 0 "NO, ALWAYS SUFFICIENT" -999 "DON'T KNOW"
	label values ws7 ws7

	label variable ws8 "(WS8) What was the main reason that you were unable to access water in sufficien"
	note ws8: "(WS8) What was the main reason that you were unable to access water in sufficient quantities when needed?"
	label define ws8 1 "WATER NOT AVAILABLE FROM SOURCE" 2 "WATER TOO EXPENSIVE" 3 "SOURCE NOT ACCESSIBLE" -666 "OTHER (SPECIFY)" -999 "DON'T KNOW"
	label values ws8 ws8

	label variable ws8_osp "(WS8.O) Other specify: main reason that you were unable to access water in suffi"
	note ws8_osp: "(WS8.O) Other specify: main reason that you were unable to access water in sufficient quantities when needed"

	label variable ws9 "(WS9) Do you or any other member of this household do anything to the water to m"
	note ws9: "(WS9) Do you or any other member of this household do anything to the water to make it safer to drink?"
	label define ws9 1 "YES" 0 "NO" -999 "DON'T KNOW"
	label values ws9 ws9

	label variable ws10 "(WS10) What do you usually do to make the water safer to drink?"
	note ws10: "(WS10) What do you usually do to make the water safer to drink?"

	label variable ws10_osp "(WS10.O) Other specify: What do you usually do to make the water safer to drink?"
	note ws10_osp: "(WS10.O) Other specify: What do you usually do to make the water safer to drink?"

	label variable ws11 "(WS11) What kind of toilet facility do members of your household usually use?"
	note ws11: "(WS11) What kind of toilet facility do members of your household usually use?"
	label define ws11 11 "FLUSH / POUR FLUSH: FLUSH TO PIPED SEWER SYSTEM" 12 "FLUSH / POUR FLUSH: FLUSH TO SEPTIC TANK" 13 "FLUSH / POUR FLUSH: FLUSH TO PIT LATRINE" 14 "FLUSH / POUR FLUSH: FLUSH TO OPEN DRAIN" 18 "FLUSH / POUR FLUSH: FLUSH TO DK WHERE" 21 "PIT LATRINE: VENTILATED IMPROVED PIT LATRINE" 22 "PIT LATRINE: PIT LATRINE WITH SLAB" 23 "PIT LATRINE: PIT LATRINE WITHOUT SLAB / OPEN PIT" 31 "COMPOSTING TOILET" 41 "BUCKET" 51 "HANGING TOILET :HANGING LATRINE" 0 "NO FACILITY / BUSH / FIELD:" -666 "OTHER (SPECIFY):"
	label values ws11 ws11

	label variable ws11_osp "(WS11.O) Other specify: What kind of toilet facility do members of your househol"
	note ws11_osp: "(WS11.O) Other specify: What kind of toilet facility do members of your household usually use."

	label variable ws12 "(WS12) Has your ever been emptied?"
	note ws12: "(WS12) Has your ever been emptied?"
	label define ws12 1 "YES, EMPTIED" 2 "WITHIN THE LAST 5 YEARS" 3 "MORE THAN 5 YEARS AGO" 4 "DON’T KNOW WHEN" 0 "NO, NEVER EMPTIED" -999 "DON'T KNOW"
	label values ws12 ws12

	label variable ws13 "(WS13) The last time it was emptied, where were the contents emptied to?"
	note ws13: "(WS13) The last time it was emptied, where were the contents emptied to?"
	label define ws13 1 "REMOVED BY SERVICE PROVIDER: TO A TREATMENT PLANT" 2 "REMOVED BY SERVICE PROVIDER:BURIED IN A COVERED PIT" 3 "REMOVED BY SERVICE PROVIDER: TO DON’T KNOW WHERE" 4 "EMPTIED BY HOUSEHOLD: BURIED IN A COVERED PIT" 5 "EMPTIED BY HOUSEHOLD: TO UNCOVERED PIT, OPEN GROUND, WATER BODY OR ELSEWHERE" -666 "OTHER (SPECIFY)" -999 "DON'T KNOW"
	label values ws13 ws13

	label variable ws13_osp "(WS13.O) Other specify: The last time it was emptied, where were the contents em"
	note ws13_osp: "(WS13.O) Other specify: The last time it was emptied, where were the contents emptied to"

	label variable ws14 "(WS14) Where is this toilet facility located?"
	note ws14: "(WS14) Where is this toilet facility located?"
	label define ws14 1 "IN OWN DWELLING" 2 "IN OWN YARD / PLOT" 3 "ELSEWHERE"
	label values ws14 ws14

	label variable ws15 "(WS15) Do you share this facility with others who are not members of your househ"
	note ws15: "(WS15) Do you share this facility with others who are not members of your household?"
	label define ws15 1 "YES" 0 "NO" -999 "DON'T KNOW"
	label values ws15 ws15

	label variable ws16 "(WS16) Do you share this facility only with members of other households that you"
	note ws16: "(WS16) Do you share this facility only with members of other households that you know, or is the facility open to the use of the general public?"
	label define ws16 1 "SHARED WITH KNOWN HOUSEHOLDS (NOT PUBLIC)" 2 "SHARED WITH GENERAL PUBLIC"
	label values ws16 ws16

	label variable ws17 "(WS17) How many households in total use this toilet facility, including your own"
	note ws17: "(WS17) How many households in total use this toilet facility, including your own household?"

	label variable hw1 "(HW1) Can you please show me where members of your household most often wash the"
	note hw1: "(HW1) Can you please show me where members of your household most often wash their hands?"
	label define hw1 1 "OBSERVED: FIXED FACILITY OBSERVED (SINK / TAP) IN DWELLING" 2 "OBSERVED: FIXED FACILITY OBSERVED (SINK / TAP) IN IN YARD /PLOT" 3 "OBSERVED MOBILE OBJECT: (BUCKET/JUG/KETTLE)" 4 "NOT OBSERVED: NO HANDWASHING PLACE IN DWELLING /YARD / PLOT" 5 "NOT OBSERVED: NO PERMISSION TO SEE" -666 "OTHER REASON (SPECIFY)"
	label values hw1 hw1

	label variable hw1_osp "(HW1.O) Other specify: Observed handwashing location"
	note hw1_osp: "(HW1.O) Other specify: Observed handwashing location"

	label variable hw2 "(HW2) Observe presence of water at the place for handwashing."
	note hw2: "(HW2) Observe presence of water at the place for handwashing."
	label define hw2 1 "WATER IS AVAILABLE" 2 "WATER IS NOT AVAILABLE"
	label values hw2 hw2

	label variable hw3 "(HW3) Is soap or detergent or ash/mud/sand present at the place for handwashing?"
	note hw3: "(HW3) Is soap or detergent or ash/mud/sand present at the place for handwashing?"
	label define hw3 1 "YES, PRESENT" 0 "NO, NOT PRESENT"
	label values hw3 hw3

	label variable hw4 "(HW4) Where do you or other members of your household most often wash your hands"
	note hw4: "(HW4) Where do you or other members of your household most often wash your hands?"
	label define hw4 1 "OBSERVED: FIXED FACILITY OBSERVED (SINK / TAP) IN DWELLING" 2 "OBSERVED: FIXED FACILITY OBSERVED (SINK / TAP) IN YARD /PLOT" 3 "OBSERVED MOBILE OBJECT: (BUCKET/JUG/KETTLE)" 4 "NOT OBSERVED: NO HANDWASHING PLACE IN DWELLING /YARD / PLOT" 5 "NOT OBSERVED: NO PERMISSION TO SEE" -666 "OTHER REASON (SPECIFY)"
	label values hw4 hw4

	label variable hw4_osp "(HW4.O) Other specify: Where do you or other members of your household most ofte"
	note hw4_osp: "(HW4.O) Other specify: Where do you or other members of your household most often wash your hands?"

	label variable hw5 "(HW5) Do you have any soap or detergent or ash/mud/sand in your house for washin"
	note hw5: "(HW5) Do you have any soap or detergent or ash/mud/sand in your house for washing hands?"
	label define hw5 1 "YES" 0 "NO" -999 "DON'T KNOW"
	label values hw5 hw5

	label variable hw6 "(HW6) Can you please show it to me?"
	note hw6: "(HW6) Can you please show it to me?"
	label define hw6 1 "YES, SHOWN" 0 "NO, NOT SHOWN"
	label values hw6 hw6

	label variable hw7 "(HW7) Record your observation. Record all that apply."
	note hw7: "(HW7) Record your observation. Record all that apply."

	label variable dc0a "(DC1) Have any of the usual members of this household died during the last 5 yea"
	note dc0a: "(DC1) Have any of the usual members of this household died during the last 5 years, including children who died just after birth ?"
	label define dc0a 1 "YES" 0 "NO" -999 "DON'T KNOW"
	label values dc0a dc0a

	label variable dc0b "(DC1) How many of the usual members of this household died during the last 5 yea"
	note dc0b: "(DC1) How many of the usual members of this household died during the last 5 years, including children who died just after birth ?"

	label variable main_respondent "Who was the main respondent to this survey?"
	note main_respondent: "Who was the main respondent to this survey?"
	label define main_respondent 1 "\${hhm_name_1}" 2 "\${hhm_name_2}" 3 "\${hhm_name_3}" 4 "\${hhm_name_4}" 5 "\${hhm_name_5}" 6 "\${hhm_name_6}" 7 "\${hhm_name_7}" 8 "\${hhm_name_8}" 9 "\${hhm_name_9}" 10 "\${hhm_name_10}" 11 "\${hhm_name_11}" 12 "\${hhm_name_12}" 13 "\${hhm_name_13}" 14 "\${hhm_name_14}" 15 "\${hhm_name_15}" 16 "\${hhm_name_16}" 17 "\${hhm_name_17}" 18 "\${hhm_name_18}" 19 "\${hhm_name_19}" 20 "\${hhm_name_20}" 21 "\${hhm_name_21}" 22 "\${hhm_name_22}" 23 "\${hhm_name_23}" 24 "\${hhm_name_24}" 25 "\${hhm_name_25}" 26 "\${hhm_name_26}" 27 "\${hhm_name_27}" 28 "\${hhm_name_28}" 29 "\${hhm_name_29}" 30 "\${hhm_name_30}" 31 "\${hhm_name_31}" 32 "\${hhm_name_32}" 33 "\${hhm_name_33}" 34 "\${hhm_name_34}" 35 "\${hhm_name_35}" 36 "\${hhm_name_36}" 37 "\${hhm_name_37}" 38 "\${hhm_name_38}" 39 "\${hhm_name_39}" 40 "\${hhm_name_40}" 41 "\${hhm_name_41}" 42 "\${hhm_name_42}" 43 "\${hhm_name_43}" 44 "\${hhm_name_44}" 45 "\${hhm_name_45}" 46 "\${hhm_name_46}" 47 "\${hhm_name_47}" 48 "\${hhm_name_48}" 49 "\${hhm_name_49}" 50 "\${hhm_name_50}" 0 "None Household Member"
	label values main_respondent main_respondent

	label variable survey_language "What is the main language used to conduct the interview?"
	note survey_language: "What is the main language used to conduct the interview?"
	label define survey_language 1 "KRIO" 2 "MENDE" 3 "TEMNE" 4 "MANDINGO" 5 "LOKO" 6 "SHERBRO" 7 "LIMBA" 8 "KISSI" 9 "KONO" 10 "SUSU" 11 "FULLAH" 12 "KRIM" 13 "YALUNKA" 14 "KORANKO" 15 "VAI" -666 "OTHER LANGUAGE (SPECIFY)"
	label values survey_language survey_language

	label variable survey_language_osp "Specify Other language used for the interview"
	note survey_language_osp: "Specify Other language used for the interview"

	label variable survey_accomp "Was this survey accompanied?"
	note survey_accomp: "Was this survey accompanied?"
	label define survey_accomp 1 "YES" 0 "NO"
	label values survey_accomp survey_accomp

	label variable survey_accomp_enum "Who accompanied this survey?"
	note survey_accomp_enum: "Who accompanied this survey?"

	label variable survey_accomp_enum_osp "What is the other position of the person who accomapnied this survey"
	note survey_accomp_enum_osp: "What is the other position of the person who accomapnied this survey"

	label variable gps_backuplatitude "Your device was unable to record GPS automatically, Please go outside and manual"
	note gps_backuplatitude: "Your device was unable to record GPS automatically, Please go outside and manually record the GPS for this household, If this you are unable to record GPS after 2 minutes, please proceed and report this to your team leader. Please ensure that your location setting is turned on (latitude)"

	label variable gps_backuplongitude "Your device was unable to record GPS automatically, Please go outside and manual"
	note gps_backuplongitude: "Your device was unable to record GPS automatically, Please go outside and manually record the GPS for this household, If this you are unable to record GPS after 2 minutes, please proceed and report this to your team leader. Please ensure that your location setting is turned on (longitude)"

	label variable gps_backupaltitude "Your device was unable to record GPS automatically, Please go outside and manual"
	note gps_backupaltitude: "Your device was unable to record GPS automatically, Please go outside and manually record the GPS for this household, If this you are unable to record GPS after 2 minutes, please proceed and report this to your team leader. Please ensure that your location setting is turned on (altitude)"

	label variable gps_backupaccuracy "Your device was unable to record GPS automatically, Please go outside and manual"
	note gps_backupaccuracy: "Your device was unable to record GPS automatically, Please go outside and manually record the GPS for this household, If this you are unable to record GPS after 2 minutes, please proceed and report this to your team leader. Please ensure that your location setting is turned on (accuracy)"

	label variable comments "General Comments"
	note comments: "General Comments"



	capture {
		foreach rgvar of varlist fmemb_fn_* {
			label variable `rgvar' "What is the first name of household member?"
			note `rgvar': "What is the first name of household member?"
		}
	}

	capture {
		foreach rgvar of varlist fmemb_sn_* {
			label variable `rgvar' "What is last name of household member?"
			note `rgvar': "What is last name of household member?"
		}
	}

	capture {
		foreach rgvar of varlist fmemb_popn_* {
			label variable `rgvar' "What name is the household member commonly known by, i.e. his/her popular name?"
			note `rgvar': "What name is the household member commonly known by, i.e. his/her popular name?"
		}
	}

	capture {
		foreach rgvar of varlist hl3_* {
			label variable `rgvar' "HL3. What is the relationship of \${fmemb_fullname} to the head of household)?"
			note `rgvar': "HL3. What is the relationship of \${fmemb_fullname} to the head of household)?"
			label define `rgvar' 1 "HEAD" 2 "SPOUSE / PARTNER" 3 "SON / DAUGHTER" 4 "SON-IN-LAW / DAUGHTER-IN-LAW" 5 "GRANDCHILD" 6 "PARENT" 7 "PARENT-IN-LAW" 8 "BROTHER / SISTER" 9 "BROTHER-IN-LAW / SISTER-IN-LAW" 10 "UNCLE/AUNT" 11 "NIECE / NEPHEW" 12 "OTHER RELATIVE" 13 "ADOPTED / FOSTER / STEPCHILD" 14 "SERVANT (LIVE-IN)" 15 "OTHER (NOT RELATED)" -999 "DON'T KNOW"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hl4_* {
			label variable `rgvar' "HL4. Is \${fmemb_fullname} male or female?"
			note `rgvar': "HL4. Is \${fmemb_fullname} male or female?"
			label define `rgvar' 0 "MALE" 1 "FEMALE"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hl5_age_sel_* {
			label variable `rgvar' "HL4.B Do you know date of birth or age of \${fmemb_fullname}?"
			note `rgvar': "HL4.B Do you know date of birth or age of \${fmemb_fullname}?"
			label define `rgvar' 1 "Yes" 2 "Yes, but only month and year" 3 "Yes, but only year" 4 "No but I can estimate the age"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hl5_dob_dmy_* {
			label variable `rgvar' "HL5.What is \${fmemb_fullname}'s date of birth?"
			note `rgvar': "HL5.What is \${fmemb_fullname}'s date of birth?"
		}
	}

	capture {
		foreach rgvar of varlist hl5_dob_my_* {
			label variable `rgvar' "HL5.What is \${fmemb_fullname}'s month and year of birth"
			note `rgvar': "HL5.What is \${fmemb_fullname}'s month and year of birth"
		}
	}

	capture {
		foreach rgvar of varlist hl5_dob_y_* {
			label variable `rgvar' "HL5.What is \${fmemb_fullname}'s year of birth?"
			note `rgvar': "HL5.What is \${fmemb_fullname}'s year of birth?"
		}
	}

	capture {
		foreach rgvar of varlist hl6_age_est_* {
			label variable `rgvar' "HL6. How old is \${fmemb_fullname}?"
			note `rgvar': "HL6. How old is \${fmemb_fullname}?"
		}
	}

	capture {
		foreach rgvar of varlist hl7_* {
			label variable `rgvar' "HL7. Did \${fmemb_fullname} stay here last night?"
			note `rgvar': "HL7. Did \${fmemb_fullname} stay here last night?"
			label define `rgvar' 1 "YES" 0 "NO" -999 "DON'T KNOW"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist ed4_* {
			label variable `rgvar' "ED4. Has \${fmemb_fullname}'s ever attended school or any Early Childhood Educat"
			note `rgvar': "ED4. Has \${fmemb_fullname}'s ever attended school or any Early Childhood Education programme?"
			label define `rgvar' 1 "YES" 0 "NO" -999 "DON'T KNOW"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist ed5a_* {
			label variable `rgvar' "ED5A. What is the highest level or year of school \${fmemb_fullname}'s has ever "
			note `rgvar': "ED5A. What is the highest level or year of school \${fmemb_fullname}'s has ever attended?"
			label define `rgvar' 0 "PRE-SCHOOL/KINDERGARDEN" 1 "PRIMARY" 2 "JUNIOR SECONDARY" 3 "SENIOR SECONDARY" 4 "VOC/TECH/NUR/TEACHING" -999 "DON’T KNOW"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist ed5a_a_* {
			label variable `rgvar' "ED5A.A Grade/year completed"
			note `rgvar': "ED5A.A Grade/year completed"
		}
	}

	capture {
		foreach rgvar of varlist ed5b_* {
			label variable `rgvar' "ED5B. What is the highest class/form or year of school \${fmemb_fullname}'s has "
			note `rgvar': "ED5B. What is the highest class/form or year of school \${fmemb_fullname}'s has ever attended?"
			label define `rgvar' 1 "PRESCHOOL/KINDERGARDEN" 2 "PRIMARY 1" 3 "PRIMARY 2" 4 "PRIMARY 3" 5 "PRIMARY 4" 6 "PRIMARY 5" 7 "PRIMARY 6" 8 "JSS 1" 9 "JSS 2" 10 "JSS 3" 11 "SSS 1" 12 "SSS 2" 13 "SSS 3"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist ed6_* {
			label variable `rgvar' "ED6. Did \${fmemb_fullname}'s ever complete that (grade/year)?"
			note `rgvar': "ED6. Did \${fmemb_fullname}'s ever complete that (grade/year)?"
			label define `rgvar' 1 "YES" 0 "NO" -999 "DON'T KNOW"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist ed9_* {
			label variable `rgvar' "ED9. At any time during the 2021/22 school year did \${fmemb_fullname}'s attend "
			note `rgvar': "ED9. At any time during the 2021/22 school year did \${fmemb_fullname}'s attend school or any Early Childhood Education programme?"
			label define `rgvar' 1 "YES" 0 "NO" -999 "DON'T KNOW"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist ed10_* {
			label variable `rgvar' "ED10.. During 2021/22 school year, which level and grade or year is \${fmemb_ful"
			note `rgvar': "ED10.. During 2021/22 school year, which level and grade or year is \${fmemb_fullname}'s attending?"
			label define `rgvar' 0 "PRE-SCHOOL/KINDERGARDEN" 1 "PRIMARY" 2 "JUNIOR SECONDARY" 3 "SENIOR SECONDARY" 4 "VOC/TECH/NUR/TEACHING" -999 "DON’T KNOW"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist ed11a_* {
			label variable `rgvar' "ED11A. Is (he/she) attending a public school?"
			note `rgvar': "ED11A. Is (he/she) attending a public school?"
			label define `rgvar' 1 "YES" 0 "NO" -999 "DON'T KNOW"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist ed11b_* {
			label variable `rgvar' "(ED11B) If NO, who controls and manages the school?"
			note `rgvar': "(ED11B) If NO, who controls and manages the school?"
			label define `rgvar' 1 "GOVT./ PUBLIC" 2 "RELIGIOUS/ FAITH ORG." 3 "PRIVATE" -666 "OTHER (SPECIFY)" -999 "DON’T KNOW"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist ed11b_osp_* {
			label variable `rgvar' "ED11.O. OTHER (SPECIFY)"
			note `rgvar': "ED11.O. OTHER (SPECIFY)"
		}
	}

	capture {
		foreach rgvar of varlist ed12_* {
			label variable `rgvar' "ED12. In the 2021/22 school year, has \${fmemb_fullname}'s received any school t"
			note `rgvar': "ED12. In the 2021/22 school year, has \${fmemb_fullname}'s received any school tuition support?"
			label define `rgvar' 1 "YES" 0 "NO" -999 "DON'T KNOW"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist ed13_* {
			label variable `rgvar' "ED13. Who provided the tuition support?"
			note `rgvar': "ED13. Who provided the tuition support?"
		}
	}

	capture {
		foreach rgvar of varlist ed13_osp_* {
			label variable `rgvar' "ED13.O. OTHER (SPECIFY)"
			note `rgvar': "ED13.O. OTHER (SPECIFY)"
		}
	}

	capture {
		foreach rgvar of varlist ed14_* {
			label variable `rgvar' "ED14. For the 2021/22 school year, has \${fmemb_fullname}'s received any materia"
			note `rgvar': "ED14. For the 2021/22 school year, has \${fmemb_fullname}'s received any material support or cash to buy shoes, exercise books, notebooks, school uniforms or other school supplies?"
			label define `rgvar' 1 "YES" 0 "NO" -999 "DON'T KNOW"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist ed15_* {
			label variable `rgvar' "ED15. At any time during the 2020/21 school year did \${fmemb_fullname}'s attend"
			note `rgvar': "ED15. At any time during the 2020/21 school year did \${fmemb_fullname}'s attend school or any Early Childhood Education programme?"
			label define `rgvar' 1 "YES" 0 "NO" -999 "DON'T KNOW"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist ed16a_* {
			label variable `rgvar' "ED16A. During 2020/21 school year, which level or year did \${fmemb_fullname}'s "
			note `rgvar': "ED16A. During 2020/21 school year, which level or year did \${fmemb_fullname}'s attend?"
			label define `rgvar' 0 "PRE-SCHOOL/KINDERGARDEN" 1 "PRIMARY" 2 "JUNIOR SECONDARY" 3 "SENIOR SECONDARY" 4 "VOC/TECH/NUR/TEACHING" -999 "DON’T KNOW"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist ed16b_* {
			label variable `rgvar' "ED16B. During 2020/21 school year, which class/form or year did \${fmemb_fullnam"
			note `rgvar': "ED16B. During 2020/21 school year, which class/form or year did \${fmemb_fullname}'s attend?"
			label define `rgvar' 1 "PRESCHOOL/KINDERGARDEN" 2 "PRIMARY 1" 3 "PRIMARY 2" 4 "PRIMARY 3" 5 "PRIMARY 4" 6 "PRIMARY 5" 7 "PRIMARY 6" 8 "JSS 1" 9 "JSS 2" 10 "JSS 3" 11 "SSS 1" 12 "SSS 2" 13 "SSS 3"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hhm_add_yn_* {
			label variable `rgvar' "\${enum_name}, Add another member?"
			note `rgvar': "\${enum_name}, Add another member?"
			label define `rgvar' 1 "YES" 0 "NO"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hl12_* {
			label variable `rgvar' "HL12. Is \${hhm_ch_hr_fullname}'s natural mother alive?"
			note `rgvar': "HL12. Is \${hhm_ch_hr_fullname}'s natural mother alive?"
			label define `rgvar' 1 "YES" 0 "NO" -999 "DON'T KNOW"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hl13a_* {
			label variable `rgvar' "HL13A. Does \${hhm_ch_hr_fullname}'s natural mother live in this household?"
			note `rgvar': "HL13A. Does \${hhm_ch_hr_fullname}'s natural mother live in this household?"
			label define `rgvar' 1 "YES" 0 "NO" -999 "DON'T KNOW"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hl13b_* {
			label variable `rgvar' "HL13B. What is the name of \${hhm_ch_hr_fullname}'s natural mother?"
			note `rgvar': "HL13B. What is the name of \${hhm_ch_hr_fullname}'s natural mother?"
			label define `rgvar' 1 "\${hhm_name_1}" 2 "\${hhm_name_2}" 3 "\${hhm_name_3}" 4 "\${hhm_name_4}" 5 "\${hhm_name_5}" 6 "\${hhm_name_6}" 7 "\${hhm_name_7}" 8 "\${hhm_name_8}" 9 "\${hhm_name_9}" 10 "\${hhm_name_10}" 11 "\${hhm_name_11}" 12 "\${hhm_name_12}" 13 "\${hhm_name_13}" 14 "\${hhm_name_14}" 15 "\${hhm_name_15}" 16 "\${hhm_name_16}" 17 "\${hhm_name_17}" 18 "\${hhm_name_18}" 19 "\${hhm_name_19}" 20 "\${hhm_name_20}" 21 "\${hhm_name_21}" 22 "\${hhm_name_22}" 23 "\${hhm_name_23}" 24 "\${hhm_name_24}" 25 "\${hhm_name_25}" 26 "\${hhm_name_26}" 27 "\${hhm_name_27}" 28 "\${hhm_name_28}" 29 "\${hhm_name_29}" 30 "\${hhm_name_30}" 31 "\${hhm_name_31}" 32 "\${hhm_name_32}" 33 "\${hhm_name_33}" 34 "\${hhm_name_34}" 35 "\${hhm_name_35}" 36 "\${hhm_name_36}" 37 "\${hhm_name_37}" 38 "\${hhm_name_38}" 39 "\${hhm_name_39}" 40 "\${hhm_name_40}" 41 "\${hhm_name_41}" 42 "\${hhm_name_42}" 43 "\${hhm_name_43}" 44 "\${hhm_name_44}" 45 "\${hhm_name_45}" 46 "\${hhm_name_46}" 47 "\${hhm_name_47}" 48 "\${hhm_name_48}" 49 "\${hhm_name_49}" 50 "\${hhm_name_50}" 0 "None Household Member"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist tmp_hl13b_check_* {
			label variable `rgvar' "Please review: \${hl13b_name} is \${hl13b_age} years old. Please confirm that sh"
			note `rgvar': "Please review: \${hl13b_name} is \${hl13b_age} years old. Please confirm that she is the actual natural mother of \${hhm_ch_hr_fullname} who is \${hhm_ch_hr_age} years old"
			label define `rgvar' 1 "YES" 0 "NO" -999 "DON'T KNOW"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hl15_* {
			label variable `rgvar' "HL15. Where does \${hhm_ch_hr_fullname}'s natural mother live?"
			note `rgvar': "HL15. Where does \${hhm_ch_hr_fullname}'s natural mother live?"
			label define `rgvar' 1 "ABROAD" 2 "IN ANOTHER HOUSEHOLD IN THE SAME REGION" 3 "IN ANOTHER HOUSEHOLD IN ANOTHER REGION" 4 "INSTITUTION IN THIS COUNTRY" -999 "DON'T KNOW"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hl16_* {
			label variable `rgvar' "HL16. Is \${hhm_ch_hr_fullname}'s natural father alive?"
			note `rgvar': "HL16. Is \${hhm_ch_hr_fullname}'s natural father alive?"
			label define `rgvar' 1 "YES" 0 "NO" -999 "DON'T KNOW"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hl17a_* {
			label variable `rgvar' "HL17A. Does \${hhm_ch_hr_fullname}'s natural father live in this household?"
			note `rgvar': "HL17A. Does \${hhm_ch_hr_fullname}'s natural father live in this household?"
			label define `rgvar' 1 "YES" 0 "NO" -999 "DON'T KNOW"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hl17b_* {
			label variable `rgvar' "HL17B. What is the name of \${hhm_ch_hr_fullname}'s natural father?"
			note `rgvar': "HL17B. What is the name of \${hhm_ch_hr_fullname}'s natural father?"
			label define `rgvar' 1 "\${hhm_name_1}" 2 "\${hhm_name_2}" 3 "\${hhm_name_3}" 4 "\${hhm_name_4}" 5 "\${hhm_name_5}" 6 "\${hhm_name_6}" 7 "\${hhm_name_7}" 8 "\${hhm_name_8}" 9 "\${hhm_name_9}" 10 "\${hhm_name_10}" 11 "\${hhm_name_11}" 12 "\${hhm_name_12}" 13 "\${hhm_name_13}" 14 "\${hhm_name_14}" 15 "\${hhm_name_15}" 16 "\${hhm_name_16}" 17 "\${hhm_name_17}" 18 "\${hhm_name_18}" 19 "\${hhm_name_19}" 20 "\${hhm_name_20}" 21 "\${hhm_name_21}" 22 "\${hhm_name_22}" 23 "\${hhm_name_23}" 24 "\${hhm_name_24}" 25 "\${hhm_name_25}" 26 "\${hhm_name_26}" 27 "\${hhm_name_27}" 28 "\${hhm_name_28}" 29 "\${hhm_name_29}" 30 "\${hhm_name_30}" 31 "\${hhm_name_31}" 32 "\${hhm_name_32}" 33 "\${hhm_name_33}" 34 "\${hhm_name_34}" 35 "\${hhm_name_35}" 36 "\${hhm_name_36}" 37 "\${hhm_name_37}" 38 "\${hhm_name_38}" 39 "\${hhm_name_39}" 40 "\${hhm_name_40}" 41 "\${hhm_name_41}" 42 "\${hhm_name_42}" 43 "\${hhm_name_43}" 44 "\${hhm_name_44}" 45 "\${hhm_name_45}" 46 "\${hhm_name_46}" 47 "\${hhm_name_47}" 48 "\${hhm_name_48}" 49 "\${hhm_name_49}" 50 "\${hhm_name_50}" 0 "None Household Member"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist tmp_hl17b_check_* {
			label variable `rgvar' "Please review: \${hl17b_name} is \${hl17b_age} years old. Please confirm that sh"
			note `rgvar': "Please review: \${hl17b_name} is \${hl17b_age} years old. Please confirm that she is the actual natural father of \${hhm_ch_hr_fullname} who is \${hhm_ch_hr_age} years old"
			label define `rgvar' 1 "YES" 0 "NO" -999 "DON'T KNOW"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hl19_* {
			label variable `rgvar' "HL20. Where does \${hhm_ch_hr_fullname}'s natural father live?"
			note `rgvar': "HL20. Where does \${hhm_ch_hr_fullname}'s natural father live?"
			label define `rgvar' 1 "ABROAD" 2 "IN ANOTHER HOUSEHOLD IN THE SAME REGION" 3 "IN ANOTHER HOUSEHOLD IN ANOTHER REGION" 4 "INSTITUTION IN THIS COUNTRY" -999 "DON'T KNOW"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hl20_ct_* {
			label variable `rgvar' "HL20A. Does \${hhm_ch_hr_fullname}'s have a primary caretaker?"
			note `rgvar': "HL20A. Does \${hhm_ch_hr_fullname}'s have a primary caretaker?"
			label define `rgvar' 1 "YES" 0 "NO" -999 "DON'T KNOW"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist hl20_oth_* {
			label variable `rgvar' "HL20B. Who is the primary caretaker of \${hhm_ch_hr_fullname}'s?"
			note `rgvar': "HL20B. Who is the primary caretaker of \${hhm_ch_hr_fullname}'s?"
			label define `rgvar' 1 "\${hhm_name_1}" 2 "\${hhm_name_2}" 3 "\${hhm_name_3}" 4 "\${hhm_name_4}" 5 "\${hhm_name_5}" 6 "\${hhm_name_6}" 7 "\${hhm_name_7}" 8 "\${hhm_name_8}" 9 "\${hhm_name_9}" 10 "\${hhm_name_10}" 11 "\${hhm_name_11}" 12 "\${hhm_name_12}" 13 "\${hhm_name_13}" 14 "\${hhm_name_14}" 15 "\${hhm_name_15}" 16 "\${hhm_name_16}" 17 "\${hhm_name_17}" 18 "\${hhm_name_18}" 19 "\${hhm_name_19}" 20 "\${hhm_name_20}" 21 "\${hhm_name_21}" 22 "\${hhm_name_22}" 23 "\${hhm_name_23}" 24 "\${hhm_name_24}" 25 "\${hhm_name_25}" 26 "\${hhm_name_26}" 27 "\${hhm_name_27}" 28 "\${hhm_name_28}" 29 "\${hhm_name_29}" 30 "\${hhm_name_30}" 31 "\${hhm_name_31}" 32 "\${hhm_name_32}" 33 "\${hhm_name_33}" 34 "\${hhm_name_34}" 35 "\${hhm_name_35}" 36 "\${hhm_name_36}" 37 "\${hhm_name_37}" 38 "\${hhm_name_38}" 39 "\${hhm_name_39}" 40 "\${hhm_name_40}" 41 "\${hhm_name_41}" 42 "\${hhm_name_42}" 43 "\${hhm_name_43}" 44 "\${hhm_name_44}" 45 "\${hhm_name_45}" 46 "\${hhm_name_46}" 47 "\${hhm_name_47}" 48 "\${hhm_name_48}" 49 "\${hhm_name_49}" 50 "\${hhm_name_50}" 0 "None Household Member"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist tmp_hl20_oth_check_* {
			label variable `rgvar' "Please review: \${hl20_oth_name} is \${hl20_oth_age} years old. Please confirm t"
			note `rgvar': "Please review: \${hl20_oth_name} is \${hl20_oth_age} years old. Please confirm that she is the actual caretaker of \${hhm_ch_hr_fullname} who is \${hhm_ch_hr_age} years old"
			label define `rgvar' 1 "YES" 0 "NO" -999 "DON'T KNOW"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist ch_15_17_consent_yn_* {
			label variable `rgvar' "May we interview \${hhm_ch_hr_fullname}?"
			note `rgvar': "May we interview \${hhm_ch_hr_fullname}?"
			label define `rgvar' 1 "YES" 0 "NO"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist st_other_name_* {
			label variable `rgvar' "What is the name of the other EXTERNAL ASSISTANCE PROGRAMME?"
			note `rgvar': "What is the name of the other EXTERNAL ASSISTANCE PROGRAMME?"
		}
	}

	capture {
		foreach rgvar of varlist st1a_* {
			label variable `rgvar' "(ST1A) Are you aware of \${st_name}"
			note `rgvar': "(ST1A) Are you aware of \${st_name}"
			label define `rgvar' 1 "YES" 0 "NO" -999 "DON'T KNOW"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist st1b_* {
			label variable `rgvar' "(ST1B) Has your household or anyone in your household received assistance throug"
			note `rgvar': "(ST1B) Has your household or anyone in your household received assistance through \${st_name}?"
			label define `rgvar' 1 "YES" 0 "NO" -999 "DON'T KNOW"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist st1cb_* {
			label variable `rgvar' "YEARS"
			note `rgvar': "YEARS"
		}
	}

	capture {
		foreach rgvar of varlist st1ca_* {
			label variable `rgvar' "MONTHS"
			note `rgvar': "MONTHS"
		}
	}

	capture {
		foreach rgvar of varlist st1_add_yn_* {
			label variable `rgvar' "Do you know ANY OTHER EXTERNAL ASSISTANCE PROGRAMME that a household member of y"
			note `rgvar': "Do you know ANY OTHER EXTERNAL ASSISTANCE PROGRAMME that a household member of yours will have benefitted from?"
			label define `rgvar' 1 "YES" 0 "NO"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist tn3_* {
			label variable `rgvar' "(TN3) \${enum_name} Did you observe mosquito tent number \${tn_ind}?"
			note `rgvar': "(TN3) \${enum_name} Did you observe mosquito tent number \${tn_ind}?"
			label define `rgvar' 1 "OBSERVED" 0 "NOT OBSERVED"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist tn4_* {
			label variable `rgvar' "(TN4) How many months ago did your household get the mosquito net?"
			note `rgvar': "(TN4) How many months ago did your household get the mosquito net?"
		}
	}

	capture {
		foreach rgvar of varlist tn5_* {
			label variable `rgvar' "(TN5) Observe or ask the brand/type of mosquito net."
			note `rgvar': "(TN5) Observe or ask the brand/type of mosquito net."
			label define `rgvar' 11 "PERMANET" 12 "OLYSET" 13 "DURANET" 16 "OTHER BRAND" 36 "OTHER TYPE" -999 "DON'T KNOW BRAND/TYPE"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist tn5_brand_type_osp_* {
			label variable `rgvar' "(TN5.O1) Observe or ask the brand of mosquito net."
			note `rgvar': "(TN5.O1) Observe or ask the brand of mosquito net."
		}
	}

	capture {
		foreach rgvar of varlist tn5_other_type_osp_* {
			label variable `rgvar' "(TN5.O2) Observe or ask the other type of mosquito net."
			note `rgvar': "(TN5.O2) Observe or ask the other type of mosquito net."
		}
	}

	capture {
		foreach rgvar of varlist tn7_* {
			label variable `rgvar' "(TN7) Since you got the net, was it ever soaked or dipped in a liquid to kill or"
			note `rgvar': "(TN7) Since you got the net, was it ever soaked or dipped in a liquid to kill or repel mosquitoes?"
			label define `rgvar' 1 "YES" 0 "NO" -999 "DON'T KNOW"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist tn9_* {
			label variable `rgvar' "(TN9) How many months ago was the net last soaked or dipped? Record in months"
			note `rgvar': "(TN9) How many months ago was the net last soaked or dipped? Record in months"
		}
	}

	capture {
		foreach rgvar of varlist tn10_* {
			label variable `rgvar' "(TN10) Did you get the net through a March 2020 mass distribution campaign, duri"
			note `rgvar': "(TN10) Did you get the net through a March 2020 mass distribution campaign, during an antenatal care visit, or during an immunization visit?"
			label define `rgvar' 1 "YES, MARCH 2020 CAMPAIGN" 2 "YES, ANC" 3 "YES, IMMUNIZATION" 0 "NO" -999 "DON'T KNOW"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist tn12_* {
			label variable `rgvar' "(TN12) Where did you get the net?"
			note `rgvar': "(TN12) Where did you get the net?"
			label define `rgvar' 1 "GOVERNMENT HEALTH FACILITY" 2 "PRIVATE HEALTH FACILITY" 3 "PHARMACY" 4 "SHOP / MARKET / STREET" 5 "COMMUNITY HEALTH WORKER" 6 "RELIGIOUS INSTITUTION" 7 "SCHOOL" -666 "OTHER (SPECIFY)" -999 "DON'T KNOW"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist tn12_osp_* {
			label variable `rgvar' "Other specify: Where did you get the net?"
			note `rgvar': "Other specify: Where did you get the net?"
		}
	}

	capture {
		foreach rgvar of varlist tn13_* {
			label variable `rgvar' "(TN13) Did anyone sleep under this mosquito net last night?"
			note `rgvar': "(TN13) Did anyone sleep under this mosquito net last night?"
			label define `rgvar' 1 "YES" 0 "NO" -999 "DON'T KNOW"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist tn15_* {
			label variable `rgvar' "(TN15) Who slept under this mosquito net last night?"
			note `rgvar': "(TN15) Who slept under this mosquito net last night?"
		}
	}

	capture {
		foreach rgvar of varlist dc2b_* {
			label variable `rgvar' "(DC2B) Please, tell me the name of household member #\${dc1_ind} who died in the"
			note `rgvar': "(DC2B) Please, tell me the name of household member #\${dc1_ind} who died in the past 5 years, starting with his/her first name."
		}
	}

	capture {
		foreach rgvar of varlist dc3_* {
			label variable `rgvar' "(DC3) Was \${dc2b} male or female?"
			note `rgvar': "(DC3) Was \${dc2b} male or female?"
			label define `rgvar' 0 "MALE" 1 "FEMALE"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist dc4_* {
			label variable `rgvar' "(DC4_DOB) What was \${dc2b}'s date of birth?"
			note `rgvar': "(DC4_DOB) What was \${dc2b}'s date of birth?"
		}
	}

	capture {
		foreach rgvar of varlist dc5_* {
			label variable `rgvar' "(DC5_DOD) What was the date of death of \${dc2b}?"
			note `rgvar': "(DC5_DOD) What was the date of death of \${dc2b}?"
		}
	}

	capture {
		foreach rgvar of varlist dc6_* {
			label variable `rgvar' "How old was \${dc2b} when (he/she) died?"
			note `rgvar': "How old was \${dc2b} when (he/she) died?"
		}
	}

	capture {
		foreach rgvar of varlist dc6_units_* {
			label variable `rgvar' "YEARS / MONTHS / DAYS"
			note `rgvar': "YEARS / MONTHS / DAYS"
			label define `rgvar' 1 "YEARS" 2 "MONTHS" 3 "DAYS"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist dc7_* {
			label variable `rgvar' "(DC7) Is \${dc2b}’s biological mother alive?"
			note `rgvar': "(DC7) Is \${dc2b}’s biological mother alive?"
			label define `rgvar' 1 "YES" 0 "NO" -999 "DON'T KNOW"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist dc8a_* {
			label variable `rgvar' "(DC8A) Does \${dc2b}’s biological mother live in this household?"
			note `rgvar': "(DC8A) Does \${dc2b}’s biological mother live in this household?"
			label define `rgvar' 1 "YES" 0 "NO" -999 "DON'T KNOW"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist dc8d_* {
			label variable `rgvar' "(DC8D) What is the name of the mother?"
			note `rgvar': "(DC8D) What is the name of the mother?"
			label define `rgvar' 1 "\${hhm_name_1}" 2 "\${hhm_name_2}" 3 "\${hhm_name_3}" 4 "\${hhm_name_4}" 5 "\${hhm_name_5}" 6 "\${hhm_name_6}" 7 "\${hhm_name_7}" 8 "\${hhm_name_8}" 9 "\${hhm_name_9}" 10 "\${hhm_name_10}" 11 "\${hhm_name_11}" 12 "\${hhm_name_12}" 13 "\${hhm_name_13}" 14 "\${hhm_name_14}" 15 "\${hhm_name_15}" 16 "\${hhm_name_16}" 17 "\${hhm_name_17}" 18 "\${hhm_name_18}" 19 "\${hhm_name_19}" 20 "\${hhm_name_20}" 21 "\${hhm_name_21}" 22 "\${hhm_name_22}" 23 "\${hhm_name_23}" 24 "\${hhm_name_24}" 25 "\${hhm_name_25}" 26 "\${hhm_name_26}" 27 "\${hhm_name_27}" 28 "\${hhm_name_28}" 29 "\${hhm_name_29}" 30 "\${hhm_name_30}" 31 "\${hhm_name_31}" 32 "\${hhm_name_32}" 33 "\${hhm_name_33}" 34 "\${hhm_name_34}" 35 "\${hhm_name_35}" 36 "\${hhm_name_36}" 37 "\${hhm_name_37}" 38 "\${hhm_name_38}" 39 "\${hhm_name_39}" 40 "\${hhm_name_40}" 41 "\${hhm_name_41}" 42 "\${hhm_name_42}" 43 "\${hhm_name_43}" 44 "\${hhm_name_44}" 45 "\${hhm_name_45}" 46 "\${hhm_name_46}" 47 "\${hhm_name_47}" 48 "\${hhm_name_48}" 49 "\${hhm_name_49}" 50 "\${hhm_name_50}" 0 "None Household Member"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist dc9a_* {
			label variable `rgvar' "(DC9A) Apart from his/her mother, was there someone in this household who was \$"
			note `rgvar': "(DC9A) Apart from his/her mother, was there someone in this household who was \${dc2b}’s primary caretaker at the time of his/her death?"
			label define `rgvar' 1 "YES" 0 "NOBODY" -999 "DON'T KNOW"
			label values `rgvar' `rgvar'
		}
	}

	capture {
		foreach rgvar of varlist dc9b_* {
			label variable `rgvar' "(DC8D) What is the name of the primary caretaker ?"
			note `rgvar': "(DC8D) What is the name of the primary caretaker ?"
			label define `rgvar' 1 "\${hhm_name_1}" 2 "\${hhm_name_2}" 3 "\${hhm_name_3}" 4 "\${hhm_name_4}" 5 "\${hhm_name_5}" 6 "\${hhm_name_6}" 7 "\${hhm_name_7}" 8 "\${hhm_name_8}" 9 "\${hhm_name_9}" 10 "\${hhm_name_10}" 11 "\${hhm_name_11}" 12 "\${hhm_name_12}" 13 "\${hhm_name_13}" 14 "\${hhm_name_14}" 15 "\${hhm_name_15}" 16 "\${hhm_name_16}" 17 "\${hhm_name_17}" 18 "\${hhm_name_18}" 19 "\${hhm_name_19}" 20 "\${hhm_name_20}" 21 "\${hhm_name_21}" 22 "\${hhm_name_22}" 23 "\${hhm_name_23}" 24 "\${hhm_name_24}" 25 "\${hhm_name_25}" 26 "\${hhm_name_26}" 27 "\${hhm_name_27}" 28 "\${hhm_name_28}" 29 "\${hhm_name_29}" 30 "\${hhm_name_30}" 31 "\${hhm_name_31}" 32 "\${hhm_name_32}" 33 "\${hhm_name_33}" 34 "\${hhm_name_34}" 35 "\${hhm_name_35}" 36 "\${hhm_name_36}" 37 "\${hhm_name_37}" 38 "\${hhm_name_38}" 39 "\${hhm_name_39}" 40 "\${hhm_name_40}" 41 "\${hhm_name_41}" 42 "\${hhm_name_42}" 43 "\${hhm_name_43}" 44 "\${hhm_name_44}" 45 "\${hhm_name_45}" 46 "\${hhm_name_46}" 47 "\${hhm_name_47}" 48 "\${hhm_name_48}" 49 "\${hhm_name_49}" 50 "\${hhm_name_50}" 0 "None Household Member"
			label values `rgvar' `rgvar'
		}
	}




	/* append old, previously-imported data (if any)
	cap confirm file "`dtafile'"
	if _rc == 0 {
		* mark all new data before merging with old data
		gen new_data_row=1
		
		* pull in old data
		append using "`dtafile'"
		
		* drop duplicates in favor of old, previously-imported data if overwrite_old_data is 0
		* (alternatively drop in favor of new data if overwrite_old_data is 1)
		sort key
		by key: gen num_for_key = _N
		drop if num_for_key > 1 & ((`overwrite_old_data' == 0 & new_data_row == 1) | (`overwrite_old_data' == 1 & new_data_row ~= 1))
		drop num_for_key

		* drop new-data flag
		drop new_data_row
	}
	*/
	
	* save data to Stata format
	save "`dtafile'", replace

	* show codebook and notes
	* codebook
	* notes list
}

disp
disp "Finished import of: `csvfile'"
disp

* OPTIONAL: LOCALLY-APPLIED STATA CORRECTIONS
*
* Rather than using SurveyCTO's review and correction workflow, the code below can apply a list of corrections
* listed in a local .csv file. Feel free to use, ignore, or delete this code.
*
*   Corrections file path and filename:  D:/Files/IPA SL DMS/05_data/02_survey/WB Nutrition Project - Household Survey_corrections.csv
*
*   Corrections file columns (in order): key, fieldname, value, notes

capture confirm file "`corrfile'"
if _rc==0 {
	disp
	disp "Starting application of corrections in: `corrfile'"
	disp

	* save primary data in memory
	preserve

	* load corrections
	insheet using "`corrfile'", names clear
	
	if _N>0 {
		* number all rows (with +1 offset so that it matches row numbers in Excel)
		gen rownum=_n+1
		
		* drop notes field (for information only)
		drop notes
		
		* make sure that all values are in string format to start
		gen origvalue=value
		tostring value, format(%100.0g) replace
		cap replace value="" if origvalue==.
		drop origvalue
		replace value=trim(value)
		
		* correct field names to match Stata field names (lowercase, drop -'s and .'s)
		replace fieldname=lower(subinstr(subinstr(fieldname,"-","",.),".","",.))
		
		* format date and date/time fields (taking account of possible wildcards for repeat groups)
		forvalues i = 1/100 {
			if "`datetime_fields`i''" ~= "" {
				foreach dtvar in `datetime_fields`i'' {
					* skip fields that aren't yet in the data
					cap unab dtvarignore : `dtvar'
					if _rc==0 {
						gen origvalue=value
						replace value=string(clock(value,"DMYhms",2025),"%25.0g") if strmatch(fieldname,"`dtvar'")
						* allow for cases where seconds haven't been specified
						replace value=string(clock(origvalue,"DMYhm",2025),"%25.0g") if strmatch(fieldname,"`dtvar'") & value=="." & origvalue~="."
						drop origvalue
					}
				}
			}
			if "`date_fields`i''" ~= "" {
				foreach dtvar in `date_fields`i'' {
					* skip fields that aren't yet in the data
					cap unab dtvarignore : `dtvar'
					if _rc==0 {
						replace value=string(clock(value,"DMY",2025),"%25.0g") if strmatch(fieldname,"`dtvar'")
					}
				}
			}
		}

		* write out a temp file with the commands necessary to apply each correction
		tempfile tempdo
		file open dofile using "`tempdo'", write replace
		local N = _N
		forvalues i = 1/`N' {
			local fieldnameval=fieldname[`i']
			local valueval=value[`i']
			local keyval=key[`i']
			local rownumval=rownum[`i']
			file write dofile `"cap replace `fieldnameval'="`valueval'" if key=="`keyval'""' _n
			file write dofile `"if _rc ~= 0 {"' _n
			if "`valueval'" == "" {
				file write dofile _tab `"cap replace `fieldnameval'=. if key=="`keyval'""' _n
			}
			else {
				file write dofile _tab `"cap replace `fieldnameval'=`valueval' if key=="`keyval'""' _n
			}
			file write dofile _tab `"if _rc ~= 0 {"' _n
			file write dofile _tab _tab `"disp"' _n
			file write dofile _tab _tab `"disp "CAN'T APPLY CORRECTION IN ROW #`rownumval'""' _n
			file write dofile _tab _tab `"disp"' _n
			file write dofile _tab `"}"' _n
			file write dofile `"}"' _n
		}
		file close dofile
	
		* restore primary data
		restore
		
		* execute the .do file to actually apply all corrections
		do "`tempdo'"

		* re-save data
		save "`dtafile'", replace
	}
	else {
		* restore primary data		
		restore
	}

	disp
	disp "Finished applying corrections in: `corrfile'"
	disp
}
