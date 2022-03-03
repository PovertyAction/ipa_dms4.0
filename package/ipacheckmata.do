
// mata programs
// 1. add_lines 				- add dividing lines to excel outputs
// 2. add_flags 				- add colors to cells
// 3. colwidths 				- adjust column widths
// 4. colformats				- format cells 
// 5. putpic 					- insert picture in excel
// 6. format_sdb_summary		- format summary page of survey dashboard
// 7. format_sdb_summary_grp	- format grouped summary page of survey dashboard
// 8. format_sdb_prod 			- format productivity page of survey dashboard
// 9. format_sdb_prod_grp		- format grouped productivity page of survey dashboard

mata: 
mata clear

void add_lines(string scalar file, string scalar sheet, real vector rows, string scalar linewidth)
{
	class xl scalar b
	b = xl()
	b.load_book(file)
	b.set_sheet(sheet)
	b.set_mode("open")

	for (i = 1;i <= length(rows); i++) {
		b.set_bottom_border(rows[i], (1, st_nvar()), linewidth)
	}
	
	b.close_book()
}

void add_flags (string scalar file, string scalar sheet, string scalar color, real scalar col, real vector rows)
{
class xl scalar b
	b = xl()
	b.load_book(file)
	b.set_sheet(sheet)
	b.set_mode("open")
	
	for (i = 1;i <= length(rows); i++) {
		b.set_fill_pattern(rows[i] + 1, col, "solid", color)
	}
	
	b.close_book()
}

void colwidths(string scalar filename, string scalar sheet) 
{
class xl scalar b
real scalar i
real rowvector datawidths, varnamewidths
	b = xl()
	b.load_book(filename)
	b.set_sheet(sheet)
	b.set_mode("open")
	datawidths = colmax(strlen(st_sdata(. , .)))
	varnamewidths = colmax(strlen(st_varname(1..st_nvar())))
	for (i=1; i<=cols(datawidths); i++) {
		if	(datawidths[i] < varnamewidths[i]) {
			datawidths[i] = varnamewidths[i]
		}
		if (datawidths[i] > 81) {
			datawidths[i] = 81
		}
		b.set_column_width(i, i, datawidths[i] + 4)
	}
	b.close_book()
}

void colformats(string scalar filename, string scalar sheet, string vector varsofinterest, string scalar excelformat) 
{
	class xl scalar b
	real scalar endrow, index 
	b = xl()
	b.load_book(filename)
	b.set_sheet(sheet)
	b.set_mode("open")
	endrow = st_nobs() + 1
	for (i=1; i<=cols(varsofinterest); i++) {
		index = st_varindex(varsofinterest[i])
		b.set_number_format((2, endrow), index, excelformat)		
	} 
	b.close_book()
}

void putpic(string scalar filename, string scalar sheetname, string scalar picture, row, col)
{
	
	class xl scalar b

	b = xl()
	
	b.load_book(filename)
	b.set_sheet(sheetname)
	b.set_mode("open")
	
	b.put_picture(row, col, picture)
	
	b.close_book()
}

void format_sdb_summary(string scalar filename, string scalar sheetname, real scalar consent, real scalar dontknow, real scalar refuse, real scalar duration, string scalar firstdate, string scalar lastdate) 
{
	class xl scalar b

	b = xl()
	
	b.load_book(filename)
	b.set_sheet(sheetname)
	b.set_mode("open")
	
	b.set_column_width(1, 1, 2)
	b.set_column_width(2, 2, 42)
	b.set_column_width(3, 3, 16)
	
	b.set_border((1, st_nobs()), (2, 3), "thin")
	b.set_bottom_border((1, 1), (2, 3), "medium")
	
	b.set_font((1, st_nobs()), (2, 3), "calibri", 10)
	b.set_font((1, 1), (2, 3), "calibri", 11)
	b.set_font((2, 2), (2, 3), "calibri", 9)
	
	b.set_horizontal_align((1, st_nobs()), (3, 3), "center")
	b.set_font_bold((1, st_nobs()), (2, 2), "on")
	b.set_font_bold((2, 2), (2, 2), "off")
	b.set_font_italic((2, 2), (2, 2), "on")
	b.set_font_italic((1, st_nobs()), (3, 3), "on")
	
	b.set_sheet_merge(sheetname, (1, 1), (2, 3))
	b.set_horizontal_align((1, 1), (2, 3), "center")
	b.set_sheet_merge(sheetname, (2, 2), (2, 3))
	b.set_horizontal_align((2, 2), (2, 3), "center")
	b.set_sheet_merge(sheetname, (3, 3), (2, 3))
	b.set_horizontal_align((3, 3), (2, 3), "center")
	b.set_fill_pattern((3, 3), (2, 3), "solid", "255 192 0")
	b.set_number_format((4, 7), (3, 3), "number_sep")


	b.set_sheet_merge(sheetname, (8, 8), (2, 3))
	b.set_horizontal_align((8, 8), (2, 3), "center")
	b.set_fill_pattern((8, 8), (2, 3), "solid", "255 192 0")
	
	b.set_number_format((9, 9), (3, 3), "percent_d2")
	
	if (consent == 0) {
		b.put_string(9, 3, "-")
	}
	
	b.set_sheet_merge(sheetname, (10, 10), (2, 3))
	b.set_horizontal_align((10, 10), (2, 3), "center")
	b.set_fill_pattern((10, 10), (2, 3), "solid", "255 192 0")
	
	if (dontknow == 0) {
		b.put_string(12, 3, "-")
	}
	
	if (refuse == 0) {
		b.put_string(13, 3, "-")
	}
	
	b.set_number_format((11, 13), (3, 3), "percent_d2")
	
	b.set_sheet_merge(sheetname, (14, 14), (2, 3))
	b.set_horizontal_align((14, 14), (2, 3), "center")
	b.set_fill_pattern((14, 14), (2, 3), "solid", "255 192 0")
	b.set_number_format((15, 18), (3, 3), "number_sep")
		
	b.set_sheet_merge(sheetname, (19, 19), (2, 3))
	b.set_horizontal_align((19, 19), (2, 3), "center")
	b.set_fill_pattern((19, 19), (2, 3), "solid", "255 192 0")
	b.set_number_format((20, 23), (3, 3), "number_sep")
	
	if (duration == 0) {
		b.put_string(20, 3, "-")
		b.put_string(21, 3, "-")
		b.put_string(22, 3, "-")
		b.put_string(23, 3, "-")
	}

	b.set_sheet_merge(sheetname, (24, 24), (2, 3))
	b.set_horizontal_align((24, 24), (2, 3), "center")
	b.set_fill_pattern((24, 24), (2, 3), "solid", "255 192 0")
	b.set_number_format((25, 26), (3, 3), "number_sep")
	b.set_number_format((29, 29), (3, 3), "number_sep")
	
	
	b.put_string(27, 3, firstdate)
	b.put_string(28, 3, lastdate)
	
	b.close_book()

}

void format_sdb_summary_grp(string scalar filename, string scalar sheetname, real scalar consent, real scalar dontknow, real scalar refuse, real scalar duration) 
{
	class xl scalar b
	real scalar col
	
	b = xl()
	
	b.load_book(filename)
	b.set_sheet(sheetname)
	b.set_mode("open")
	
	b.set_font((1, st_nobs() + 1), (1, st_nvar()), "calibri", 11)
	b.set_font_italic((1, 1), (1, st_nvar()), "on")
	b.set_font_bold((1, 1), (1, st_nvar()), "on")
	b.set_bottom_border((1, 1), (1, st_nvar()), "medium")
	b.set_horizontal_align((1, st_nobs() + 1), (2, st_nvar()), "center")	
	
	b.set_number_format((2, st_nobs() + 1), (2, 2), "number_sep")
	col = 3
	if (consent == 1) {
		b.set_number_format((2, st_nobs() + 1), (col, col), "percent_d2")
		col = col + 1
	}
	b.set_number_format((2, st_nobs() + 1), (col, col), "percent_d2")
	col = col + 1
	if (dontknow == 1) {
		b.set_number_format((2, st_nobs() + 1), (col, col), "percent_d2")
		col = col + 1
	}
	if (refuse == 1) {
		b.set_number_format((2, st_nobs() + 1), (col, col), "percent_d2")
		col = col + 1
	}
	if (duration == 1) {
		b.set_number_format((2, st_nobs() + 1), (col, col + 3), "number_sep")
		col = col + 4
	}
	b.set_number_format((2, st_nobs() + 1), (col, col + 1), "number_sep")
	col = col + 2
	b.set_number_format((2, st_nobs() + 1), (col, col + 1), "date_d_mon_yy")
	col = col + 2
	b.set_number_format((2, st_nobs() + 1), (col, col), "number_sep")
	
	b.close_book()

}

void format_sdb_prod(string scalar filename, string scalar sheetname, string scalar period) 
{
	class xl scalar b

	b = xl()
	
	b.load_book(filename)
	b.set_sheet(sheetname)
	b.set_mode("open")
	
	b.set_font((1, st_nobs() + 1), (1, st_nvar()), "calibri", 11)
	b.set_font_italic((1, 1), (1, st_nvar()), "on")
	b.set_font_bold((1, 1), (1, st_nvar()), "on")
	b.set_bottom_border((1, 1), (1, st_nvar()), "medium")
	b.set_horizontal_align((1, st_nobs() + 1), (2, st_nvar()), "center")
	
	b.set_number_format((2, st_nobs() + 1), (1, 1), "number_sep")
	
	if (period == "daily") {
		b.set_number_format((2, st_nobs() + 1), (2, 2), "date_d_mon_yy")
		b.set_number_format((2, st_nobs() + 1), (3, 3), "number_sep")
	}
	else {
		b.set_number_format((2, st_nobs() + 1), (2, 3), "date_d_mon_yy")
		b.set_number_format((2, st_nobs() + 1), (4, 4), "number_sep")
	}
	
	b.close_book()

}

void format_sdb_prod_grp(string scalar filename, string scalar sheetname) 
{
	class xl scalar b
	
	b = xl()
	
	b.load_book(filename)
	b.set_sheet(sheetname)
	b.set_mode("open")
	
	b.set_font((1, st_nobs() + 1), (1, st_nvar()), "calibri", 11)
	b.set_font_italic((1, 1), (1, st_nvar()), "on")
	b.set_font_bold((1, 1), (1, st_nvar()), "on")
	b.set_bottom_border((1, 1), (1, st_nvar()), "medium")
	b.set_bottom_border((st_nobs(), st_nobs()), (1, st_nvar()), "medium")
	b.set_font_italic((st_nobs() + 1, st_nobs() + 1), (1, st_nvar()), "on")
	b.set_font_bold((st_nobs() + 1, st_nobs() + 1), (1, st_nvar()), "on")
	b.set_horizontal_align((1, st_nobs() + 1), (2, st_nvar()), "center")
	
	b.close_book()

}

void format_sdb_var_det(string scalar filename, string scalar sheetname, real scalar dontknow, real scalar refuse) 
{
	class xl scalar b
	real scalar col
	
	b = xl()
	
	b.load_book(filename)
	b.set_sheet(sheetname)
	b.set_mode("open")
	
	b.set_font((1, st_nobs() + 1), (1, st_nvar()), "calibri", 11)
	b.set_font_italic((1, 1), (1, st_nvar()), "on")
	b.set_font_bold((1, 1), (1, st_nvar()), "on")
	b.set_bottom_border((1, 1), (1, st_nvar()), "medium")
	b.set_horizontal_align((1, st_nobs() + 1), (3, st_nvar()), "center")
	
	b.set_number_format((1, st_nobs() + 1), (4, 5), "number_sep")
	b.set_number_format((1, st_nobs() + 1), (6, 6), "percent_d2")
	
	if (dontknow == 1) {
		b.set_number_format((1, st_nobs() + 1), (7, 7), "number_sep")
		b.set_number_format((1, st_nobs() + 1), (8, 8), "percent_d2")
		col = 9
	}
	else {
		col = 7
	}
	if (refuse == 1) {
		b.set_number_format((1, st_nobs() + 1), (col, col), "number_sep")
		b.set_number_format((1, st_nobs() + 1), (col + 1, col + 1), "percent_d2")
	}
	
	b.close_book()

}

mata mlib create lipadms, dir(PLUS) replace
mata mlib add lipadms *()
mata mlib index

end