#!/usr/bin/python

import re 
import time
import mechanize
import cookielib
import BeautifulSoup
Soup = BeautifulSoup.BeautifulSoup

url = 'http://www.umaine.edu'

br = mechanize.Browser()

# Cookie Jar
cj = cookielib.LWPCookieJar()
br.set_cookiejar(cj)

# Browser options
br.set_handle_equiv(True)
br.set_handle_gzip(False)
br.set_handle_redirect(True)
br.set_handle_referer(True)
br.set_handle_robots(False)
br.set_handle_refresh(True)

# User-Agent (this is cheating, ok?)
br.addheaders = [('User-agent', 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.1) Gecko/2008071615 Fedora/3.0.1-1.fc9 Firefox/3.0.1')]

filename = "units.txt"
fread = open(filename, 'r')
fcontents = fread.read()
names = fcontents.split('\n')

#print "unit,URL"

#names = ['Electrical and Computer Engineering']

for myName in names:
    	myName = myName.replace('UM ', '')
	myName = myName.replace('- ', '')
	myName = myName.replace('& ', '')
	myName = myName.replace('&', '')
	myName = myName.replace('"', '')
		
	r = br.open(url)
	html = r.read()
	soup = Soup(html)
	#t1 = soup.find('div', attrs={'class':"treven"})
	br.select_form(nr=0)  #action="http://www.google.com/cse")
	br.find_control("q").value = myName
	response2 = br.submit()
	html = response2.read()
	soup = Soup(html)
	#<span class="a">www.ece.umaine.edu/</span>
	sa = soup.findAll('span', attrs={'class': "a"})
	
	if sa:
		for s in sa:
			myURL = s.text
			if myURL.find(".pdf")==-1 and myURL.find("ps.gz")==-1 and myURL.find(".xlsx")==-1 and myURL.find(".txt")==-1 and myURL.find(".ps")==-1:
				break
				
		if myURL.find("http"):
			myURL = "http://" + myURL
	else:
		myURL = "http://www.umaine.edu"
	
	str = '"' + myName + '",' + myURL 
	
	print str
	#print html

