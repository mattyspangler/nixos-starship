# simple python script to convert a VCF contact export into a contacts.csv file
# this script needs phonenumbers lib ( pip install phonenumbers ).
# place your export in the same directory as the script, then run python vcf2csv.py and copy the resulting contacts.tsv to the correct place.
# See https://github.com/gled-rs/vcf2csv.git for more infos.
import os
import csv
import phonenumbers

input_file_name='contacts.vcf'
output_file_name='contacts.tsv'
verbose_no_match=False
insert_raw_tel=False
try_to_fix_tel=False
sort='name' # name or number sorting, anything else contacts will be sorted in the order they are found in the vcf


results=[]
with open(input_file_name,'r',encoding='utf8') as r:
    for line in r:
        if line.find('BEGIN:VCARD') >= 0:
            name=""
            tel=[]
            data=[]
        elif line.find('END:VCARD')>=0:
            if name != "" and len(tel) > 0:
                for t in tel:
                    results.append([t,name])
            elif verbose_no_match:
                print("Cannot find a phone number in vcard: %s\n\n" % "".join(data))
        elif line.find('FN:') >=0:
            name=line.replace('FN:',"").strip()
        elif line.find('TEL;') >= 0 or line.find('TEL:') >= 0:
            matched=False
            t=line.split(':')[1].replace("(","").replace(")","").replace("-","").replace(" ","").strip()
            if try_to_fix_tel:
                if not t.startswith("+"):
                    # this would work only for US numbers
                    if t.startswith("1"):
                        t="+"+t
                    elif len(t) == 10:
                        t="+1"+t
            for match in phonenumbers.PhoneNumberMatcher(t, None):
                number = phonenumbers.format_number(match.number, phonenumbers.PhoneNumberFormat.E164)
                tel.append(number)
                matched=True
            if not matched:
                print("%s Phone number not matching proper format: %r" % (name,t))
                if insert_raw_tel:
                    tel.append(t)
        data.append(line)

d={}
t={}
with open(output_file_name,'w',newline='') as w:
    writer = csv.writer(w,delimiter='\t',lineterminator='\n')
    if sort == 'name':
        results.sort(key = lambda i: i[1])
    elif sort == 'number':
        results.sort(key = lambda i: i[0])
    for r in results:
        if ":".join(r) not in d:
            if r[0] in t:
                print("Duplicate number with two names ?! %r" %r[0])
            t[r[0]]=1
            d[":".join(r)]=1
            writer.writerow(r)
