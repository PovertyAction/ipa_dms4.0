 * do everything in mata instead
 * pull variables we care about
 * find max col length
 * if more than 81, change to 81
 * if varname is longer, use varname
 * 


* stuck on how to get all variables, not just string and not just real 
* What to do about variable labels? 

mata: 
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

colwidths("C:/users/rsandino/Desktop/upgp.xlsx", "ID Duplicates")

end 


mata:
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


colformats("C:/users/rsandino/Desktop/upgp.xlsx", "ID Duplicates", "percent_difference", "percent_d2")
end 
