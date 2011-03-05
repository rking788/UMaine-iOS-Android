#!/usr/bin/python

##########################################
# Author: Dr. Yifeng Zhu
# University of Maine
# Contact: zhu@eece.maine.edu
# Initial Release: Feb. 23, 2011
#########################################

import re 
import time
import mechanize
import cookielib
import BeautifulSoup
Soup = BeautifulSoup.BeautifulSoup

print "Department,CourseNum,Section,ISBN,Title"

url_1 = "http://www.bookstore.umaine.edu/ePOS?this_category=1&store=411&form=shared3%2ftextbooks%2fno_jscript%2fmain.html&design=411&__session_info__=Pl1TBl5VJOJzlSdOignf0IdKpJ24g7Cecaktyhn5AWMhqhHsC64UMFx2umoRkGq0Z6HAM%2fBZ85ClcOzYX1Df9U%2b7aWDyEk0WY%2fBW0y8U3jKhq1t3C6pmNg%3d%3d"
url_3 = 'http://www.bookstore.umaine.edu/ePOS?wpd=1&width=100%25&this_category=1&term=S11&store=411&step=4&qty=1000&listtype=begin&host=72.95.108.194&go=Go&form=shared3%2Ftextbooks%2Fno_jscript%2Fmain.html&design=411&department=ECE&colspan=3&cellspacing=1&cellpadding=0&campus=Main&border=0&bgcolor=%23dddddd&agent=Mozilla%2F5.0+%28Macintosh%3B+U%3B+Intel+Mac+OS+X+10.6%3B+en-US%3B+rv%3A1.9.2.13%29+Gecko%2F20101203+Firefox%2F3.6.13&action=list_courses&__session_info__=9%2F56XBePQRoy84thr7bjbDt4%2Blve2WvYWmWZzF%2BjeWS2NT7VJHGqfKsjkTHGl2oT5DYbQnwJK5uAwsJP2K1iHw9AYlivW0ow&course=343&Go=Go'

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

# Follows refresh 0 but not hangs on refresh > 0
br.set_handle_refresh(mechanize._http.HTTPRefreshProcessor(), max_time=1)

# Want debugging messages?
#br.set_debug_http(True)
#br.set_debug_redirects(True)
#br.set_debug_responses(True)

# User-Agent (this is cheating, ok?)
br.addheaders = [('User-agent', 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.1) Gecko/2008071615 Fedora/3.0.1-1.fc9 Firefox/3.0.1')]

# Open the site
r = br.open(url_1)
html = r.read()

# Select the Semester
br.select_form(name="noname")
br.find_control(id="term").value = ["S11"]
br.submit()
html = br.response().read()

# Select the Department
soup = Soup(html)
departments  =  soup.findAll('option', value=re.compile("[A-Z]+"))
for d in departments:
    #print d['value']
    br.select_form(name="textdepartments")
    br.find_control(name="department").value = [d['value']]
    br.submit()
    html = br.response().read()

    # Select the Course
    soup = Soup(html)
    courses  =  soup.findAll('option', value=re.compile("[0-9]+"))
    for c in courses:
        #print c['value']
        br.select_form(name="textcourse")
        br.find_control(name="course").value = [c['value']]
        br.submit()
        html = br.response().read()

        # Select the Section
        soup = Soup(html)
        sections  =  soup.findAll('option', value=re.compile("[0-9]+"))
        for s in sections:
            #print s['value']
            br.select_form(name="textsection")
            br.find_control(name="section").value = [s['value']]
            br.submit()
            html = br.response().read()
            soup = Soup(html)
            
            bookdiv =  soup.find('div', id="book")
            if not bookdiv:
                br.follow_link(text = "Section:", nr=0)
                continue;

            isbn  = bookdiv.find('a')['id']
	    if isbn:
		isbn = isbn.replace(' ', '')

            title = bookdiv.find('span').b.string
	    if title:
		title = title.strip()

	    department = d['value']
	    if department:
		department = department.strip() #(' ', '')

	    courseNum  = c['value']
	    if courseNum:
		courseNum = courseNum.replace(' ', '')

	    sectionNum = s['value']
	    if sectionNum:
		sectionNum = sectionNum.replace(' ', '')

	    # Department,CourseNum,Section,ISBN,Title
	    # print department,  "," , courseNum,  ",", sectionNum, ",",  isbn, ',"', title, '"'

	    if title:
		str = department + ',' + courseNum + ',' + sectionNum + ',' + isbn + ',"' + title + '"'
	    else:
	    	str = department + ',' + courseNum + ',' + sectionNum + ',' + isbn + ',"' + '"'
	    print str
            
            br.follow_link(text = "Section:", nr=0)

                
        br.follow_link(text = "Course:", nr=0)
        
    br.follow_link(text = "Department:", nr=0)



