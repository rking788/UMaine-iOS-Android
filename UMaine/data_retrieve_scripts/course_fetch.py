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

url = 'https://mainestreet.maine.edu/'


filename = "departments.txt"
fread = open(filename, 'r')
fcontents = fread.read()
departments = fcontents.split('\n')


print("department,courseNum,courseTitle,sectionNum,courseType,callNum,meetingTime,meetingLocation,instructor,startEndDate")
#ANT,245,"Sex and Gender in Cross",0001,LEC,7261,TuTh 11:00AM - 12:15PM,Murray Hall 106,Lisa K Neuman,8/29/2011 - 12/9/2011

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


# Follows refresh 0 but not hangs on refresh > 0
br.set_handle_refresh(mechanize._http.HTTPRefreshProcessor(), max_time=1)

# Want debugging messages?
#br.set_debug_http(True)
#br.set_debug_redirects(True)
#br.set_debug_responses(True)

# User-Agent (this is cheating, ok?)
br.addheaders = [('User-agent', 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.1) Gecko/2008071615 Fedora/3.0.1-1.fc9 Firefox/3.0.1')]


# Open the site
r = br.open(url)
html = r.read()

r = br.follow_link(text = 'Class Search', nr=0)
html = r.read();
#print html

soup = Soup(html)
frame =  soup.find('frame', attrs={'name': "TargetContent"})

#print frame['src']
r = br.open(frame['src'])
html = r.read();

#print br.links()

# Select the Institution
br.select_form(name="win1")
br.find_control(id="CLASS_SRCH_WRK2_INSTITUTION$51$").value = ["UMS05"]
br.submit()
html = br.response().read()

br.select_form(name="win1")
# 1120: Spring 2011 
# 1210: Fall 2011 
# 1130: Summer 2011
# 1220: Spring 2012
br.find_control(id="CLASS_SRCH_WRK2_STRM$54$").value = ["1220"]
br.submit()
html = br.response().read()
html = br.response().read()


Careers = ["UGRD", "GRAD"];
for dept in departments:
	for career in Careers:

		br.select_form(name="win1")
		#br.find_control("CLASS_SRCH_WRK2_SSR_CLS_SRCH_TYPE$60$").selected = False
		#br.find_control("CLASS_SRCH_WRK2_SSR_CLS_SRCH_TYPE$59$").selected = True
		#br.find_control("CLASS_SRCH_WRK2_SSR_CLS_SRCH_TYPE$59$").value = ["04"]
		#br.find_control("CLASS_SRCH_WRK2_SSR_CLS_SRCH_TYPE$59$$rad").value = ["04"]
		#br.find_control("CLASS_SRCH_WRK2_SSR_CLS_SRCH_TYPE$60$").get("CLASS_SRCH_WRK2_SSR_CLS_SRCH_TYPE$59$").selected = True
		#br.find_control(id="CLASS_SRCH_WRK2_SSR_CLS_SRCH_TYPE$59$").value = ["04"]
		#br.submit()
		#html = br.response().read()

		post_url, post_data, headers =  br.form.click_request_data()

		#print post_url

		post_data = post_data.replace("ICAction=None", "ICAction=CLASS_SRCH_WRK2_SSR_PB_SRCH%2458%24")

		#print post_data

		r = br.open(post_url, post_data)
		html = r.read()
		assert br.viewing_html()
		br.select_form(name="win1")
		br.find_control("CLASS_SRCH_WRK2_SUBJECT$72$").value = dept
		br.find_control("CLASS_SRCH_WRK2_ACAD_CAREER").value = [career]
		# UGRD or GRAD
		#NOTE: MaineStree requires at least two search constraints 

        	#br.find_control("CLASS_SRCH_WRK2_SSR_OPEN_ONLY").value =["N"]
		post_url, post_data, headers =  br.form.click_request_data()
		#print post_url
		#print post_data

		post_data = post_data.replace("ICYPos=0", "ICYPos=342")
		post_data = post_data.replace("ICAction=None", "ICAction=CLASS_SRCH_WRK2_SSR_PB_CLASS_SRCH%24113%24")
		post_data = post_data.replace("CLASS_SRCH_WRK2_SSR_OPEN_ONLY%24chk=Y", "CLASS_SRCH_WRK2_SSR_OPEN_ONLY%24chk=N");

		r = br.open(post_url, post_data, timeout=100000)
		html = r.read()
		assert br.viewing_html()
		#print html

		if html.find('Your search will return over 50 classes') >= 0 :
			br.select_form(name="win1")
			post_url, post_data, headers =  br.form.click_request_data()
			post_data = post_data.replace('ICAction=None', 'ICAction=%23ICSave')
                        #post_data = 'ICType=Panel&ICElementNum=1&ICStateNum=6&ICAction=%23ICSave&ICXPos=0&ICYPos=0&ICFocus=&ICChanged=-1&ICResubmit=0'
                        #print post_data
			r = br.open(post_url, post_data, timeout=100000)
			html = r.read()
			larger_50 = 1
		else:
			larger_50  = 0 

		html = html.replace('&#039;', '\'')

		soup = Soup(html)
		t1 = soup.find('table', attrs={'id':"$ICField59$scroll$0", 'class':"PABACKGROUNDINVISIBLEWBO"})
		#t2 = t1.find('table', attrs={'class': "PABACKGROUNDINVISIBLE", 'style': "border-style: none;"})
		if not t1:
			post_data = 'ICType=Panel&ICElementNum=2&ICStateNum=4&ICAction=CLASS_SRCH_WRK2_SSR_PB_CLOSE&ICXPos=0&ICYPos=0&ICFocus=&ICChanged=-1&ICResubmit=0'
			r = br.open(post_url, post_data, timeout=100000)
			html = r.read()
			continue

		t2 = t1.find('table', attrs={'class': "PABACKGROUNDINVISIBLE"})

		courseTitle = "";

		for row in t2.findAll(lambda tag: tag.name == "tr" and tag.findParent('table') == t2):
			str = '';
			title = row.find('span', attrs={'class': "SSSHYPERLINKBOLD"})
			#print title

			if not title:
				continue
			else:
				titleShort = ''.join(title.contents)            # AED&nbsp; 473 - Advanced Curriculum in Art Education
				titleShort = titleShort.replace("&nbsp;", ",")
				titleShort = titleShort.replace("-", ",")       # ARH, 498 , Directed Study in Art History
				titles = titleShort.split(',', 3)
				courseTitle = titles[0].strip() + "," + titles[1].strip() + ',"' + titles[2].strip() + '",';
				#for s in titles:
				#	courseTitle += '"' + s.strip() + '",'
				# print courseTitle

			t3 = row.find('table', attrs = {'class':"PSLEVEL3GRID"})
			sections = t3.findAll(lambda tag: tag.name == "table" and tag.findParent('table') == t3)
			for s in sections:
				str = '';
				section = s.find('a', id=re.compile("^DERIVED_CLSRCH_SSR_CLASSNAME_LONG"))
				if section:
					sec = section.string.strip() 		# 0001-IND(1143)
					sec = sec.replace("-", ",");
					sec = sec.replace("(", ",")
					sec = sec.replace(")", "")
					str = sec  				# 0002,IND,3992

				t4 = s.find('table', id=re.compile("^SSR_CLSRCH_MTG1"))
				items = t4.findAll('span', attrs = {'class':"PSLONGEDITBOX"})
				for it in items:
					#print it
					try:
						#it = it.replace('<br>', "")
						str = str + "," + it.string.strip()
					except:
						str = str + ","

				print(courseTitle + str)

		# Return and select a different department
		#print html
		br.select_form(name="win1")
		post_url, post_data, headers = br.form.click_request_data()
		post_data = post_data.replace('ICAction=None', 'ICAction=CLASS_SRCH_WRK2_SSR_PB_NEW_SEARCH%2455%24')
		#print post_data	

		#if larger_50 == 0:
		#	post_data = 'ICType=Panel&ICElementNum=2&ICStateNum=4&ICAction=CLASS_SRCH_WRK2_SSR_PB_CLOSE&ICXPos=0&ICYPos=0&ICFocus=&ICChanged=-1&ICResubmit=0'
			#post_data = 'ICType=Panel&ICElementNum=2&ICStateNum=13&ICAction=CLASS_SRCH_WRK2_SSR_PB_NEW_SEARCH&ICXPos=11&ICYPos=174&ICFocus=&ICChanged=-1&ICResubmit=0'
			#post_data = 'ICType=Panel&ICElementNum=2&ICStateNum=15&ICAction=CLASS_SRCH_WRK2_SSR_PB_NEW_SEARCH%2455%24&ICXPos=0&ICYPos=6451&ICFocus=&ICChanged=-1&ICResubmit=0'
		#else:
		#	post_data = 'ICType=Panel&ICElementNum=2&ICStateNum=7&ICAction=CLASS_SRCH_WRK2_SSR_PB_NEW_SEARCH%2455%24&ICXPos=13&ICYPos=9145&ICFocus=&ICChanged=-1&ICResubmit=0'
		#print post_data
		r = br.open(post_url, post_data, timeout=100000)
		html = r.read()
		#print html



