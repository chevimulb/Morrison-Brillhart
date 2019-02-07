def reduction(e,h):
	j=e.ncols()-1
	while j>=0:
		if e.column(j)!=0:
			i=0
			while i<e.nrows():
				if e[i,j]==1 and sum(e.row(i)[j+1:])==0:
					k=i+1
					while k<e.nrows():
						if e[k,j]==1 and sum(e.row(k)[j+1:])==0:
							e.add_multiple_of_row(k,i,1)
							e=e%2
							h.add_multiple_of_row(k,i,1)
							e=e%2
						k=k+1
					i=e.nrows()-1
				i=i+1
		j=j-1
	e=e%2
	h=h%2
	set=matrix(ZZ,[])
	l=0
	while l<e.nrows():
		if e.row(l)==0:
			if set==0:
				set=matrix(ZZ,h.row(l))
			else:
				set=set.insert_row(set.nrows(),h.row(l))
		l=l+1
	return set