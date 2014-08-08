import csv
import pyodbc



# 
 
 
conn=pyodbc.connect('DRIVER={Teradata};DBCNAME=vivaldi;UID=yizwu;PWD=Wyztl1314;QUIETMODE=YES;',autocommit=True)
cursor = conn.cursor()
with open("InfluencerList.sql") as SQL:
    code = str.split(SQL.read(),'INSERT')[0]
    code = str.split(code,';')
    for i in range(0,len(code)):
        print code[i]
        cursor.execute(code[i])
    
    
InfluencerList = []
with open ("influencers.csv") as influencers:
    next(influencers)
    for line in influencers:
        InfluencerList.append(str.split(line.replace('\n',''),","))
    print InfluencerList
    print 'Waiting...'
    
        
for i in range(0,len(InfluencerList)):
    query = 'INSERT INTO P_SOCIAL_INFLUENCER_T.INFLUENCER_LIST VALUES(\''+InfluencerList[i][1]+'\',\''+InfluencerList[i][2]+'\',\''+InfluencerList[i][0]+'\',\''+InfluencerList[i][3]+'\')'
    print query
    cursor.execute(query)
    
# insert = 'INSERT INTO P_SOCIAL_INFLUENCER_T.INFLUENCER_LIST VALUES(\'U2FzaGVlIENoYW5kcmFu\',\'Sashee Chandran\',\'Sashee Chandran\',\'\');'
sql = 'select * from p_social_influencer_t.influencer_list'
# cursor.execute(insert)
cursor.execute(sql)
rows = cursor.fetchall()
conn.close()
print rows
     

