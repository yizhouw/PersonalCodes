'''
Created on Jul 25, 2014

@author: yizwu
'''
import time
import csv
from selenium import webdriver

def find_between( s, first, last ):
    try:
        start = s.index( first ) + len( first )
        end = s.index( last, start )
        return s[start:end]
    except ValueError:
        return ""

if __name__ == '__main__':
    fp = webdriver.FirefoxProfile('C:/Users/yizwu/AppData/Roaming/Mozilla/Firefox/Profiles/ek2shyt1.default')
    browser = webdriver.Firefox(fp)
    browser.get('http://www.facebook.com/')
    page = browser.page_source
    f = open('source.html','w')
    f.write(page.encode('utf-8'))
    f.close()


with open ("source.html") as FB:
    for line in FB:
#         print line
        if "bigPipe.onPageletArrive" in line and "data" in line:
            line = find_between(line,"(",")</script>")
            print line
# print line
            segments = str.split(line,"name\"")
            for i in range(0,len(segments)):
# print segments[i]
                line = []
                title = find_between(segments[i],"\"","\"")
                data = find_between(segments[i],"\"data\":","}")
                data = (data.replace('[', '')).replace(']','')
                data = str.split(data,",")
                raw = None
                if len(data)>1:
                    raw = [float(x) for x in data]
# print raw
                    for i in range(0,len(raw),2):
                        point = [time.strftime("%Y-%m-%d %H:%M:%S", time.gmtime(raw[i]/1000)),raw[i+1]]
                        line.append(point)
                if len(line) > 0:
                    print title
                    print line
                Row_Name = ['time','value']
                resultFile = open(title+".csv",'wb')
                wr = csv.writer(resultFile, dialect='excel')
                wr.writerow(Row_Name)
                for i in range(0,len(line)):
                    wr.writerow(line[i])