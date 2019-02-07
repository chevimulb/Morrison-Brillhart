def basecheck(q,base,a,UB):
	if q<0:
		e=[1]
		q=-1*q
	else:
		e=[0]
	if len(a)>1:
		j=1
		while j<len(a):
			while q%a[j]==0:
				q=q/a[j]
				if len(e)<j+1:
					while len(e)<j:
						e.append(0)
					e.append(1)
				else:
					e[j]=(e[j]+1)%2
			j=j+1
	if q!=1:
		i=0
		while i<len(base) and q!=1:
			if q%base[i]==0:
				a.append(base[i])
				while q%base[i]==0:
					q=q/base[i]
					if len(e)<len(a):
						while len(e)<len(a)-1:
							e.append(0)
						e.append(1)
					else:
						e[-1]=(e[-1]+1)%2
			i=i+1
	if base[-1]^2>UB:
		bound=UB
	else:
		bound=base[-1]^2
	if q!=1 and q<bound:
		a.append(q)
		while len(e)<len(a)-1:
			e.append(0)
		e.append(1)
		q=1
	if q==1:
		check=1
	else:
		check=0
	R=[check,a,e]
	return R