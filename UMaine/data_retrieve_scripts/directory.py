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

#names = ['Alfred Bushway']

for myName in names:
    #print myName
    myName = myName.replace('\t', ' ')
    
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
    try:
        title = title.replace('&amp;', '&')
    except:
        title = ""


    office = ""
    for d in dd:
        if d.find('span'):
            office = d.text
            office = office.replace('&nbsp;', ' ')


    phonePattern = re.search(r'(\d{3}) (\d{3}) (\d{4})', html);
    try:
        phone = phonePattern.group(0)
        phone = phone.replace(' ', '')
    except:
        phone = ""
        
    e = soup.find('a', attrs={'onblur': "this.href='#'"})
    try:
        email = e.string
        email = email.replace('&#64;', '@')
    except:
        email = ""
        
    str = '"' + firstName +'","' + middleName +'","' + lastName +'","' + dept + '","' + title + '","' + phone + '","' + email + '","' + office + '"'
    print str
