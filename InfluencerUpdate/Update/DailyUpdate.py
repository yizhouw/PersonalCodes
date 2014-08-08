'''
Created on Aug 7, 2014

@author: yizwu
'''
import csv
import pyodbc
import multithreading as mul


def find_between( s, first, last ):
    try:
        start = s.index( first ) + len( first )
        end = s.index( last, start )
        return s[start:end]
    except ValueError:
        return ""

def update_gmb(cursor):
    with open("InfluencerGMB.sql") as SQL:
        code = SQL.read()
        code = str.split(code,';')
        for i in range(0,len(code)):
            print code[i]
            print 'Waiting...'
            cursor.execute(code[i])
    return None
    
def update_session(cursor):
    with open("InfluencerSession.sql") as SQL:
        code = SQL.read()
        code = str.split(code,';')
        for i in range(0,len(code)):
            print code[i]
            print 'Waiting...'
            cursor.execute(code[i])
    return None

def update_new_guides(cursor):
    with open("InfluencerGuides.sql") as SQL:
        code = SQL.read()
        code = str.split(code,';')
        for i in range(0,len(code)):
            print code[i]
            print 'Waiting...'
            cursor.execute(code[i])
    return None


def update_pin_repin(cursor):
    with open("New_Pin.sql") as SQL:
        code = SQL.read()
    cursor.execute(code)
    rows = cursor.fetchall()
    with open("new_pin.txt","w") as result:
        for element in rows:
            print element
            element = find_between(str(element).strip('()'),'\'','\'')
            if '\\t' in element:
                element = str.replace(element,'\\t','')
            print element
            result.write(element+'\n')
    mul.RunProgram()
    with open("INSERT_NEW_ROW.TXT") as SQL:
        code = SQL.read()
        code = str.split(code,';')
        for i in range(0,len(code)):
            print code[i]
            cursor.execute(code[i])
    return None



conn=pyodbc.connect('DRIVER={Teradata};DBCNAME=vivaldi;UID=yizwu;PWD=Wyztl1314;QUIETMODE=YES;',autocommit=True)
cursor = conn.cursor()


if __name__ == '__main__':
    update_gmb(cursor)
    update_session(cursor)
    update_new_guides(cursor)
    update_pin_repin(cursor)
    
    
    
    
    