def MoBri(N,k=None,FB=None,UB=None,LIM=None,QL=None):
	print "N =",N
	import time
	load("factorbase.sage")
	load("legendre.sage")
	load("basecheck.sage")
	load("reduction.sage")
	load("factorcheck.sage")
	load("complcheck.sage")
	if k==None:
		k=input('Ist ein Faktor k erwuenscht? Falls nein, waehle k=1. Fuer k=0 wird ein Idealwert abhaengig von N errechnet. k=')
	if FB==None:
		FB=input('Wie gross soll die Faktorbasis sein? Fuer FB=0 werden Erfahrungswerte verwendet. FB=')
	if UB==None:
		UB=input('Obergrenze fuer Faktoren ausserhalb der Faktorbasis? Fuer UB=0 werden Erfahrungswerte verwendet. UB=')
	if LIM==None:
		LIM=input('Wie viele glatte Q sollen gesucht werden? Fuer LIM=0 wird ein Idealwert errechnet. Fuer LIM=-1 maximal viele. LIM=')
	if QL==None:	
		QL=input('Bis zu welchem Index soll die Folge Q hoechstens berrechnet werden? QL=')
	if k==0: 				
		l=list(primes(7,32))
		i=1
		comp1=0
		comp2=0
		while i<98 and comp1<8:
			if legendre(i*N,3)!=-1 and legendre(i*N,5)!=-1:
				val=0
				sum=0
				j=0
				while j<8:
					if legendre(i*N,l[j])!=-1:
						val=val+1
						sum=sum+1/l[j]
					j=j+1
				if val>comp1:
					comp1=val
					comp2=sum
					k=i
				elif val==comp1:
					if sum>comp2:
						comp1=val
						comp2=sum
						k=i
			i=i+1
	nod=floor(log(N,10))+1
	if FB==0 or UB==0:
		if nod<=20:
			fp=60
			up=3000
		elif nod in [21,22,23]:
			fp=150
			up=10000
		elif nod in [24,25]:
			fp=200
			up=14400
		elif nod in [26,27,28]:
			fp=300
			up=22500
		elif nod in [29,30]:
			fp=400
			up=29000
		elif nod in [31,32]:
			fp=450
			up=36000
		elif nod in [33,34]:
			fp=500
			up=36000
		elif nod in [35,36]:
			fp=550
			up=36000
		elif nod in [37,38]:
			fp=600
			up=44000
		elif nod in [39,40]:
			fp=650
			up=53000
		elif nod>40:
			fp=1000
			up=63000
	if UB==0:
		UB=up
	if FB==0:
		FB=fp
	
	limcheck=0
	if LIM==0:
		limcheck=1
		if nod<=30:
			lf=0.8
		elif nod in [31,32,33,34]:
			lf=0.82
		elif nod>=35:
			lf=0.84
		LIM=lf*FB
	elif LIM==-1:
		LIM=QL
	start=time.time()
	[factors,base]=factorbase(N,k,FB)
	print "Faktoren in Faktorbasis gefunden:",factors
	a=[-1]							#Vektor der alle Faktoren der Q enthält
	Qsmooth=[]
	Asmooth=[]
	E=matrix(ZZ,1,0,0)					#Matrix, die später Exponentenvektoren der glatten Q enthält
	q=[floor(sqrt(N))]
	P=[q[0]]
	A=[q[0]]
	Q=[(q[0]^2)-N]
	[check,a,e]=basecheck(Q[0],base,a,UB)
	if E!=0 and E.ncols()<len(a):
		E=E.transpose()
		while E.nrows()<len(a):
			E=E.insert_row(E.nrows(),zero_vector(E.ncols()))
		E=E.transpose()
	while len(e)<len(a):
		e.append(0)
	if check==1:
		Qsmooth.append(Q[0])
		Asmooth.append(A[0])
		E=matrix(ZZ,e)

	q.append(floor((P[0]+q[0])/abs(Q[0])))
	P.append(q[1]*abs(Q[0])-P[0])
	A.append(q[1]*A[0]+1)
	Q.append(1+(P[0]-P[1])*q[1])
	[check,a,e]=basecheck(Q[1],base,a,UB)
	if E!=0 and E.ncols()<len(a):
		E=E.transpose()
		while E.nrows()<len(a):
			E=E.insert_row(E.nrows(),zero_vector(E.ncols()))
		E=E.transpose()
	while len(e)<len(a):
		e.append(0)
	if check==1:
		Qsmooth.append(Q[1])
		Asmooth.append(A[1])
		if E==0:
			E=matrix(ZZ,e)
		else:
			E=E.insert_row(E.nrows(),e)
		

	i=2
	n=min(500,QL)
	while complcheck(N,factors)[0]!=2 and len(Q)<QL and E.nrows()<LIM:
		elen=0
		while i<=n and E.nrows()<LIM:
			q.append(floor((q[0]+P[i-1])/abs(Q[i-1])))
			P.append(q[i]*abs(Q[i-1])-P[i-1])
			A.append((q[i]*A[i-1]+A[i-2])%N)
			Q.append(abs(Q[i-2])+(P[i-1]-P[i])*q[i])
			if i%2==0:
				Q[i]=-1*Q[i]
			[check,a,e]=basecheck(Q[i],base,a,UB)					#basecheck überprüft Q auf Glätte und gibt Exponentenvektor e aus
			if E!=0 and E.ncols()<len(a):
				E=E.transpose()
				while E.nrows()<len(a):
					E=E.insert_row(E.nrows(),zero_vector(E.ncols()))
				E=E.transpose()
			while len(e)<len(a):
				e.append(0)
			if check==1:
				Qsmooth.append(Q[i])
				Asmooth.append(A[i])
				if E==0:
					E=matrix(ZZ,e)
				else:
					E=E.insert_row(E.nrows(),e)
			i=i+1
			if limcheck==1:
				LIM=lf*max(FB,(len(a)-1))
		if E and E.rows()>elen:								#Gaußverfahren nur wenn Anzahl glatter Q sich erhöht hat
			h=identity_matrix(E.nrows())
			set=reduction(E,h)
			y=0
			while y<set.nrows():
				Aset=1
				Qset=1
				j=0
				while j<set.ncols():
					if set[y,j]==1:
						Qset=Qset*Qsmooth[j]
						Aset=(Aset*Asmooth[j])%N
					j=j+1
				Qset=sqrt(Qset)
				if gcd(Aset-Qset,N)!=1 and gcd(Aset-Qset,N)!=N:
					factors=factorcheck(factors,gcd(Aset-Qset,N))
					#print gcd(Aset-Qset,N)
				if gcd(Aset+Qset,N)!=1 and gcd(Aset+Qset,N)!=N:
					factors=factorcheck(factors,gcd(Aset+Qset,N))
					#print gcd(Aset+Qset,N)
				y=y+1
				if complcheck(N,factors)[0]==2:
					print "Primfaktorzerlegung komplett"
					end=time.time()
					time=end-start
					print "Zeit: ", time
					return factors
			elen=E.nrows()
		n=n+500
		if n>QL:
			n=QL
	[compl,factors]=complcheck(N,factors)
	if compl==1:
		print "Komplette Primfaktorzerlegung nicht gelungen"
	else:
		print "Primfaktorzerlegung komplett"
	end=time.time()
	time=end-start
	print "Zeit: ", time
	return factors