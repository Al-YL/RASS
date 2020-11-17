#Download RASS Data
import requests
import os
import re

def download_file(filename, file_url):
    response = requests.get(file_url)
    content = response.content
    save_file(filename, content)

def save_file(filename, content):
    with open(file=filename, mode="wb") as f:
        f.write(content)

def get_url(url, res):
    rp = requests.get(url)
    html = rp.text
    fid = re.findall(res, html)
    return fid

#RASS Archive
main_url = 'https://heasarc.gsfc.nasa.gov/FTP/rosat/data/pspc/processed_data/900000/'
resmain = r'<a .*?>(rs.*?)</a>'

xmain = get_url(main_url, resmain)
xmain.sort()
#Rosat field structures: 1378 sky fields
print('All Rass Fields: '+str(len(xmain)))

for subdir in xmain:
    print(subdir)
    url_f = main_url + subdir
    fnames = get_url(url_f, resmain)
    rassdir = './rass/'+subdir[:-1]
    if not os.path.exists(rassdir):
        os.makedirs(rassdir)
    for subfile in fnames:
        download_file(rassdir+'/'+subfile, url_f+subfile)


