#!/usr/bin/python

##########################################
# Original Author: Dr. Yifeng Zhu
# University of Maine
# Contact: zhu@eece.maine.edu
# Initial Release: Feb. 23, 2011
#########################################

##########################################
# Maintainer: Rob King
# Contact: rking@mainelyapps.com
#########################################

import re 
import time
import mechanize
import cookielib
import BeautifulSoup

debug = 0

# UMO : UMS05
# UMPI : UMS07
# UMF : UMS02
# UMFK : UMS03
# UMA : UMS01
# UMM : UMS04
# USM : UMS06
INSTITUTION = "UMS06"

# 1120: Spring 2011 
# 1210: Fall 2011 
# 1130: Summer 2011
# 1220: Spring 2012
# 1410: Fall 2013
TERM = "1410"

CAREERS = ['UGRD', 'GRAD']

## HTML Constant
WIN_NAME = 'win0'
SRCH_INST = 'CLASS_SRCH_WRK2_INSTITUTION$41$'
SRCH_TERM = 'CLASS_SRCH_WRK2_STRM$45$'
SRCH_SUBJECT = 'SSR_CLSRCH_WRK_SUBJECT$75$$0'
SRCH_CAREER = 'SSR_CLSRCH_WRK_ACAD_CAREER$2'
T1_ID = '$ICField229$scroll$0'
T1_CLASS = 'PABACKGROUNDINVISIBLEWBO'

Soup = BeautifulSoup.BeautifulSoup

url = 'https://mainestreet.maine.edu/'

## Read all department names from the text file
filename = "departments.txt"
fread = open(filename, 'r')
fcontents = fread.read()
departments = fcontents.split('\n')

print("department;courseNum;courseTitle;sectionNum;courseType;callNum;meetingTime;meetingLocation;instructor;startEndDate")
#ANT,245,"Sex and Gender in Cross",0001,LEC,7261,TuTh 11:00AM - 12:15PM,Murray Hall 106,Lisa K Neuman,8/29/2011 - 12/9/2011

def get_browser_obj():
    brow = mechanize.Browser()

    # Cookie Jar
    cj = cookielib.LWPCookieJar()
    brow.set_cookiejar(cj)

    # Browser options
    brow.set_handle_equiv(True)
    brow.set_handle_gzip(False)
    brow.set_handle_redirect(True)
    brow.set_handle_referer(True)
    brow.set_handle_robots(False)
    brow.set_handle_refresh(True)

    # Follows refresh 0 but not hangs on refresh > 0
    brow.set_handle_refresh(mechanize._http.HTTPRefreshProcessor(), max_time=1)

    # Want debugging messages?
    #br.set_debug_http(True)
    #br.set_debug_redirects(True)
    #br.set_debug_responses(True)

    # User-Agent (this is cheating, ok?)
    brow.addheaders = [('User-agent', 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.1) Gecko/2008071615 Fedora/3.0.1-1.fc9 Firefox/3.0.1')]

    return brow

br = get_browser_obj()

recreate = False

for dept in departments:
    for career in CAREERS:
        if (dept == ""):
            continue;
        if (career == ""):
            continue;

        if debug:
            print "Department: " + dept;
            print "Career: " + career;

        if recreate:

            br = get_browser_obj()
            recreate = False

        # Open the site
        r = br.open(url)
        html = r.read()

        if debug: 
            print("Got the initial response\n")

        r = br.follow_link(text = 'Class Search', nr=0)
        html = r.read();

        if debug: 
            print("Followed the Class Search link\n")

        soup = Soup(html)
        frame =  soup.find('iframe', attrs={'name': "TargetContent"})

        r = br.open(frame['src'])
        html = r.read();

        # Select the Institution
        try:
		    br.select_form(name=WIN_NAME)
        except Exception as e:
            r.close()
            br.close()
            del br
            del r
            recreate = True
            continue
            
        br.find_control(id=SRCH_INST).value = [INSTITUTION]
        br.submit()
        html = br.response().read()

        if debug: 
            print("After filling in the institute\n")

        ## Select the term
        br.select_form(name=WIN_NAME)
        br.find_control(id=SRCH_TERM).value = [TERM]
        br.submit()
        html = br.response().read()

        if debug: 
            print("After filling in the term\n")

        br.select_form(name=WIN_NAME)

        post_url, post_data, headers =  br.form.click_request_data()

        post_data = post_data.replace("ICAction=None", "ICAction=CLASS_SRCH_WRK2_SSR_PB_SRCH%2458%24")

        r = br.open(post_url, post_data)
        html = r.read()

        assert br.viewing_html()
        br.select_form(name=WIN_NAME)
        br.find_control(SRCH_SUBJECT).value = dept
        
        controls = br.find_control(SRCH_CAREER)
        
        #Started running into a lot of problems when campuses didn't have GRAD courses
        # this fixes it
        try:
            br.find_control(SRCH_CAREER).value = [career]
        except mechanize._form.ItemNotFoundError:
            if debug:
                print "Couldn't find control for srch_career"
            continue
        
        # UGRD or GRAD
        #NOTE: MaineStreet requires at least two search constraints 

        if debug: 
            print("After fill in the depart and career \n")

        post_url, post_data, headers =  br.form.click_request_data()

        post_data = post_data.replace("ICYPos=0", "ICYPos=342")
        post_data = post_data.replace("ICAction=None", "ICAction=CLASS_SRCH_WRK2_SSR_PB_CLASS_SRCH")
        post_data = post_data.replace("CLASS_SRCH_WRK2_SSR_OPEN_ONLY%24chk=Y", "CLASS_SRCH_WRK2_SSR_OPEN_ONLY%24chk=N")
        post_data = post_data.replace("CLASS_SRCH_WRK2_SSR_OPEN_ONLY=Y", "CLASS_SRCH_WRK2_SSR_OPEN_ONLY=N")

        r = br.open(post_url, post_data, timeout=100000)
        html = r.read()
        assert br.viewing_html()

        if html.find('The search returns no results that match the criteria specified.') >= 0:
            if debug: 
                print("Found no results\n")
            continue

        if html.find('Your search will return over 50 classes') >= 0 :
            if debug: 
                print("Got a warning of over 50 classes\n")

            br.select_form(name=WIN_NAME)
            post_url, post_data, headers =  br.form.click_request_data()
            post_data = post_data.replace('ICAction=None', 'ICAction=%23ICSave')
            r = br.open(post_url, post_data, timeout=100000)
            html = r.read()
            larger_50 = 1
        else:
            if debug: 
                print("Got NO warning of over 50 classes\n")
            larger_50  = 0 

        html = html.replace('&#039;', '\'')

        soup = Soup(html)
        t1 = soup.find('table', attrs={'id' : T1_ID, 'class' : T1_CLASS})
        #t2 = t1.find('table', attrs={'class': "PABACKGROUNDINVISIBLE", 'style': "border-style: none;"})
        if not t1:
            if debug: 
                print("t1 is empty.\n")
            post_data = 'ICType=Panel&ICElementNum=2&ICStateNum=4&ICAction=CLASS_SRCH_WRK2_SSR_PB_CLOSE&ICXPos=0&ICYPos=0&ICFocus=&ICChanged=-1&ICResubmit=0'
            r = br.open(post_url, post_data, timeout=100000)
            html = r.read()
            if debug: 
                print("No data found! Continue.\n")
            continue

        t2 = t1.find('table', attrs={'class': "PABACKGROUNDINVISIBLE"})
        if not t2:
            if debug: 
                print("t2 is empty!\n")

        courseTitle = "";

        for row in t2.findAll(lambda tag: tag.name == "tr" and tag.findParent('table') == t2):
            str = '';
            title = row.find('span', attrs={'class': "SSSHYPERLINKBOLD"})

            if not title:
                if debug:
                    print "No Title found"
                continue
            else:
                titleShort = ''.join(title.contents)            # AED&nbsp; 473 - Advanced Curriculum in Art Education
                titleShort = titleShort.replace("&nbsp;", ",")
                titleShort = titleShort.replace("-", ",")       # ARH, 498 , Directed Study in Art History
                titles = titleShort.split(',', 3)
                courseTitle = titles[0].strip() + ";" + titles[1].strip() + ';"' + titles[2].strip() + '";';

            t3 = row.find('table', attrs = {'class':"PSLEVEL1SCROLLAREABODY"})

            sections = t3.findAll(lambda tag: tag.name == "table" and tag.findParent('table') == t3)
            for s in sections:
                str = '';
                section = s.find('a', id=re.compile("^DERIVED_CLSRCH_SSR_CLASSNAME_LONG"))
                if section:
                    sec = section.string.strip()        # 0001-IND(1143)   ### New section string '0001-LEC(1222)-View Details'
                    sec = sec.replace("-View Details", "")
                    sec = sec.replace("-", ";");
                    sec = sec.replace("(", ";")
                    sec = sec.replace(")", "")
                    str = sec               # 0002,IND,3992

                t4 = s.find('table', id=re.compile("^SSR_CLSRCH_MTG1"))
                items = t4.findAll('span', attrs = {'class':"PSLONGEDITBOX"})
                
                for it in items:
                    #print it
                    try:
                        #it = it.replace('<br>', "")
                        str = str + ";" + it.string.strip()
                    except:
                        str = str + ";"
       
            print(courseTitle + str)
 
        br.select_form(name=WIN_NAME)
        post_url, post_data, headers = br.form.click_request_data()

        post_data = post_data.replace('ICAction=None', 'ICAction=CLASS_SRCH_WRK2_SSR_PB_NEW_SEARCH%2482%24')

        r = br.open(post_url, post_data, timeout=100000)
        html = r.read()
