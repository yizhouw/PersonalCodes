import urllib2
from selenium import webdriver
import Queue
import threading
import urllib2
from threading import Thread
import os


url='http://www.ebay.com/gds/Top-5-Features-of-a-Hammond-Organ-/10000000178723243/g.html'


def increase():
	chromedriver = "C:/Users/yizwu/Downloads/chromedriver.exe"
	for i in range(0,10):
		browser = webdriver.Firefox()
		browser.get(url)
		browser.quit()
		browser = webdriver.Chrome(chromedriver)
		browser.get(url)
		browser.quit()

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

if __name__ == '__main__':
	for i in range(0,10):
		print 'Thread ' + str(i) + ' Initialized!'
		t = ThreadWithReturnValue(target=increase, args =())
		t.start()

    # fp = webdriver.FirefoxProfile('C:/Users/yizwu/AppData/Roaming/Mozilla/Firefox/Profiles/ek2shyt1.default')
    
    # browser2.get(url)
    # f = open('source.html','w')
    # f.write(page.encode('utf-8'))
    # f.close()