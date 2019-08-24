#!/usr/bin/python
import time
import smtplib, ssl
import email
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
import json
import sys
from passwords import EMAILPASS

BODY = """Email ricevuta da {}, indirizzo {} con la seguente richiesta:
\"
{}
\"
Email automatica inviata dal sito www.hswsnc.com
"""
  
form = json.load(sys.stdin)
name = "Non specificato"
mail = "Non specificato"
content = ""
if isinstance(form, dict):
    if "name" in form.keys(): 
        name = form["name"]
    if "email" in form.keys(): 
        mail = form["email"]
    if "content" in form.keys(): 
        content = form["content"]

port = 25  # For SSL
password = EMAILPASS

# Create a secure SSL context
#context = ssl.create_default_context()
fromaddr = "no-reply@hswsnc.com"
toaddr = "info@hswsnc.com"
msg = MIMEMultipart()
msg['From'] = fromaddr
msg['To'] = toaddr
msg['Subject'] = "Richiesta da {}".format(name)
body = BODY.format(name, mail, content)
msg.attach(MIMEText(body, 'plain'))

#with smtplib.SMTP_SSL("smtp.hswsnc.com", port, context=context) as server:
server = smtplib.SMTP("smtp.hswsnc.com", port)
server.starttls()
server.login(fromaddr, password)
text = msg.as_string()
server.sendmail(fromaddr, toaddr, text)
server.quit()

time.sleep(1)

print("Content-Type: text/json\r\n\r\n")
print(json.dumps({'result':'success', 'received':str(form), 'request':{'name':name, 'mail':mail, 'body': content}}))