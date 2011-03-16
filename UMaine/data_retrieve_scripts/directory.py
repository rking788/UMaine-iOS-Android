#!/usr/bin/python

import re 
import time
import mechanize
import cookielib
import BeautifulSoup
Soup = BeautifulSoup.BeautifulSoup

url = 'https://www.maine.edu/peoplesearch/'

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

filename = "names.txt"
fread = open(filename, 'r')
fcontents = fread.read()
names = fcontents.split('\n')

print "firstName,middleName,lastName,department,title,phone,email,office"

for myName in names:
    r = br.open(url)
    html = r.read()
    br.select_form(nr=0)
    br.find_control("campus").value = ["UM"]
    br.find_control("q").value = myName

    post_url, post_data, headers =  br.form.click_request_data()

    r = br.open(post_url, post_data)
    html = r.read()

    soup = Soup(html)
    t1 = soup.find('div', attrs={'class':"treven"})
    if not t1:
        continue;
        
    dd = soup.findAll('dd')
    
    if not dd:
        continue;

    name = dd[0].string
    try:
        nn = name.split(' ');
        firstName = nn[0];
        lastName  = nn[-1];
    except:
        firstName = ""
        lastName  = ""
    
    try:
        middleName = ''.join(nn[1:-2])
    except:
        middleName = ""

    dept = dd[1].string
    try:
        dept = dept.replace('&amp;', '&')
    except:
        dept = ""

    title = dd[2].string
    if not title:
        title = ""

    phone = dd[3].string
    try:
        phone = phone.replace(' ', '')
    except:
        phone = ""

    e = dd[4];
    try:
        email = e.find('a').string
        email = email.replace('&#64;', '@')
    except:
        email = ""
        
    s = dd[5]
    try:
        office = s.text
    except:
        office = ""

    str = '"' + firstName +'","' + middleName +'","' + lastName +'","' + dept + '","' + title + '","' + phone + '","' + email + '","' + office + '"'
    print str
