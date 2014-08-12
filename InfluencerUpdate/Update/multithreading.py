import Queue
import threading
import urllib2
from threading import Thread
import csv




bucket_size = 10 ## the smaller the bucket size is, the faster the program will run. But make sure no more than 700 threads.


def find_between( s, first, last ):
    try:
        start = s.index( first ) + len( first )
        end = s.index( last, start )
        return s[start:end]
    except ValueError:
        return ""



#get result

# Modify the following function is the source code changes on Pinterest 
def get_pin(q,pin_ids):
    Data_Set =[]
    for i in range(0,len(pin_ids)):
        row=[]
        pin_id = pin_ids[i]
        pinner = None
        influencer = None
        try:

            url="http://www.pinterest.com/pin/" + pin_ids[i] + "/"
            q.put(urllib2.urlopen(url))
            page = q.get()
            for line in page:
                if "pinterestapp:pinner" in line:
                    # print line
                    pinner = find_between(line,".com\/","\\")
                    if pinner == '':
                        pinner = find_between(line,".com/","/")
                    # print pinner 
                if "pinterestapp:source" in line:
                    influencer = find_between(line,"ta.p",".b")
                    if influencer =='':
                        influencer = find_between(line,"ti.p","\"")
                        if '%' in influencer:
                            influencer = find_between(influencer,"","%")
                        elif '&' in influencer:
                            influencer = find_between(influencer,"","&")
                        break
        except:
            pass
        row = [pin_id,pinner,influencer]
        print str(i) + ' '+ str(row)
        Data_Set.append(row)
    return Data_Set




# Multithreading 
class ThreadWithReturnValue(Thread):
    def __init__(self, group=None, target=None, name=None,
                 args=(), kwargs={}, Verbose=None):
        Thread.__init__(self, group, target, name, args, kwargs, Verbose)
        self._return = None
    def run(self):
        if self._Thread__target is not None:
            self._return = self._Thread__target(*self._Thread__args,
                                                **self._Thread__kwargs)
    def join(self):
        Thread.join(self)
        return self._return

def RunProgram():
        
    pin_ids = []
    with open ("new_pin.txt") as source:
        for line in source:
            line = line.replace('\n','')
            pin_ids.append(line)
    # print bucket
    
    bucket = len(pin_ids)/bucket_size + 1
    # print bucket
    
    # print pin_ids[0:2]

    q = Queue.Queue()


    threads=[]
    for i in range(0,bucket):
        print 'Thread ' + str(i) + ' Initialized!'
        if i < bucket:
            t = ThreadWithReturnValue(target=get_pin, args = (q,pin_ids[i*bucket_size:(i+1)*bucket_size]))
            t.start()
            threads.append(t)
        else:
            t = ThreadWithReturnValue(target=get_pin, args = (q,pin_ids[(bucket-1)*bucket_size:len(pin_ids)]))

    print 'Waiting...'

    Total_Result = []

    for thread in threads:
        Total_Result = Total_Result + thread.join()

    print len(Total_Result)
    # If you want to modify the output of the file, modify the code below


    # Row_Name = ['Pin_ID','Pinner','Roken2_Tag']
    resultFile = open("INSERT_NEW_ROW.TXT",'w')
    # wr = csv.writer(resultFile, dialect='excel')
    # wr.writerow(Row_Name)
    for i in range(0,len(Total_Result)):
        resultFile.write("INSERT INTO P_SOCIAL_INFLUENCER_T.PINTEREST_PIN VALUES(\'"+str(Total_Result[i][0])+"\',\'"+str(Total_Result[i][1])+"\',\'"+str(Total_Result[i][2])+"\',\'"+str(Total_Result[i][0])+"\');"'\n')

