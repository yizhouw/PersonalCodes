import urllib2
import csv

def find_between( s, first, last ):
    try:
        start = s.index( first ) + len( first )
        end = s.index( last, start )
        return s[start:end]
    except ValueError:
        return ""


#############Define the Roken2 to Name Function #################
def find_name(roken2):
	try:
		Influencer_name = None
		if "3hwzkq71" in roken2: return "carhoots"
		elif "Q2hyaXN0aW5lIE1pa2VzZWxs" in roken2: return "15minbeauty"
		elif "VGluYSBDcmFpZw==" in roken2: return "bagsnob"
		elif "YmVhdXR5YmV0cw==" in roken2: return "beautybets"
		elif "TGVlIE1hbGNoZXI=" in roken2: return "carhoots"
		elif "R2FiaSBHcmVnZw==" in roken2: return "compai"
		elif "P3t1c2VybmFtZX0=" in roken2: return "ebay"
		elif "TWVnYW4gQ29sbGlucw==" in roken2: return "egirlfriend"
		elif "TWVsaXNzYSBXaWxs" in roken2: return "empressofdirt"
		elif "ZW1wcmVzc29mZGlydA==" in roken2: return "empressofdirt"
		elif "SnVzdGluYSBCbGFrZW5leQ==" in roken2: return "gabifresh"
		elif "SGVhdGhlciBDbGF3c29u" in roken2: return "habituallychic"
		elif "aGFiaXR1YWxseWNoaWM=" in roken2: return "habituallychic"
		elif "QXJ0ZW1pc2EgU2F1Y2Vkbw==" in roken2: return "hammeraclassic"
		elif "TWFyaWFuIFBhcnNvbnM=" in roken2: return "highsnobiety"
		elif "S2VsbHkgRnJhbWVs" in roken2: return "kellyframel"
		elif "QW5kcmVhcyBBbmRyZWFz" in roken2: return "missmustardseed"
		elif "TmF0YWxpZSBMaWFv" in roken2: return "nalieli"
		elif "VHlsZXIgV2lzZXI=" in roken2: return "nydesignguy"
		elif "Q2Fzc2l0eSBLTWV0enNjaA==" in roken2: return "Remodelaholic"
		elif "c2hvZWx1c3Q=" in roken2: return "shoelust"
		elif "SmFtZXMgTWNCcmlkZQ==" in roken2: return "Silodrome"
		elif "SnVzdGluIExpdmluZ3N0b24=" in roken2: return "Silodrome"
		elif "2VsbHkgRnJhbWVs" in roken2: return "theglamourai"
		elif "S2FyaUFubmUgV29vZA==" in roken2: return "thistlewoodfarm"
		elif "VHJhY2kgRnJlbmNo" in roken2: return "tracif"


	except:
		return "None"



pin_id = None
pinner = None
influencer = None

Data_Set =[]


with open ("C:\Users\yizwu\Desktop\pin.txt") as PinList:
	i=1
	for line in PinList:
		print i
	# for i in range(1,20):
		# print i
		# line = PinList.readline()
		if "?" not in line:
			pin_id = str.split(line,"\n")[0]
			# print pin_id
			try:
				url = "http://www.pinterest.com/pin/" + pin_id + "/"
				page = urllib2.urlopen(url)
				# print page
				for line in page:
					if "pinterestapp:pinner" in line:
						pinner = find_between(line,".com/","/")
						# print line
						# print "Pinner: "+pinner
					if "pinterestapp:source" in line:
						# print line
						influencer = find_between(line,"ta.p",".b")
						influencer = find_name(influencer)
						# print "Roken2: "+influencer
						break
			except:
				pass
			row = [pin_id,pinner,influencer]
			original = False
			if pinner is not None and influencer is not None:
				if pinner.lower()==influencer.lower():
					original = True
				else:
					original = False
			row.append(original)
			Data_Set.append(row)
			print row
		i=i+1
		print "**************************************"

print Data_Set

Row_Name = ['Pin_ID','Pinner','Roken2_Tag','Original_Pin']
resultFile = open("output.csv",'wb')
wr = csv.writer(resultFile, dialect='excel')
wr.writerow(Row_Name)
for i in range(0,len(Data_Set)):
	wr.writerow(Data_Set[i])