
use "../test/WB Nutrition Project - Household Survey", clear

keep starttime endtime

gen date = dofc(starttime)
format %td date

forval i = 0/23 {
	gen hh`i' = `i' >= hh(starttime) & `i' <= hh(endtime)
}

keep date hh*

collapse (sum) hh*, by(date)

forval i = 0/23 {
	lab var hh`i' "`i'"
}


export excel date using "timeuse.xlsx", replace sheet("timeuse") cell(B2)

egen rowmin = rowmin(hh*)
egen rowmax = rowmax(hh*)

mata: st_numscalar("min", colmin(st_data(., "rowmin")))
loc minval = scalar(min)
mata: st_numscalar("max", colmax(st_data(., "rowmax")))
loc maxval = scalar(max)

mata:
mata clear

void colorpallete(string scalar file, string scalar sheet, real scalar min, real scalar max)
{
	class xl scalar b
	string scalar time_lab
	real scalar range
	real scalar value
	string scalar rgb
	
	
	b = xl()
	b.load_book(file)
	b.set_sheet(sheet)
	b.set_mode("open")
	
	b.set_sheet_gridlines(sheet, "off")
	b.set_column_width(2, 2, 13)
	b.set_column_width(3, 27, 3)

	for (i = 0;i <= 23; i++) {
		if (i == 0) {
			time_lab = "Midnight"
		}
		else if (i >= 0 & i <= 11) {
			time_lab = strofreal(i) + " AM"
		}
		else if (i == 12) {
			time_lab = "12 Noon"
		}
		else {
			time_lab = strofreal(i - 12) + " PM"
		}
		b.put_string(st_nobs() + 2, i + 3, time_lab)
	}
	
	b.set_text_rotate((st_nobs() + 2, st_nobs() + 2), (3, 27), 90)
	b.set_vertical_align((st_nobs() + 2, st_nobs() + 2), (3, 27), "top")
	
	range = max - min
	for (i = 1; i <= 24; i++) {
		for (j = 1; j <= st_nobs(); j++) {
			value = st_data(j, i + 1)
			value = floor(value/range * 100)
			rgb = "0 " + strofreal(value) + " 0"
			b.set_fill_pattern((j + 1, j + 1), (i + 2, i + 2), "solid", rgb)
		}
	}
	
	b.close_book()
}

end

mata: colorpallete("timeuse.xlsx", "timeuse", `minval', `maxval')