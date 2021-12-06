
// mata programs
// 1. add_lines 	- add dividing lines to excel outputs
// 2. add_flags 	- add colors to cells
// 3. colwidths 	- adjust column widths
// 4. colformats	- format cells 

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
		b.set_column_width(i, i, datawidths[i] + 2)
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

mata mlib create lipadms, dir(PERSONAL) replace
mata mlib add lipadms *()
mata mlib index
end