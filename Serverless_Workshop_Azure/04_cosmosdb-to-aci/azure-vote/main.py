from flask import Flask, request, render_template
import os
import random
import socket
import sys
import pymongo

app = Flask(__name__)

# Load configurations
app.config.from_pyfile('config_file.cfg')
button1 =       app.config['VOTE1VALUE']  
button2 =       app.config['VOTE2VALUE']
title =         app.config['TITLE']

# CosmosDB configurations
#Define the connection
url = "mongodb://iotdbaccount838:cOl25CnJVEonhsGShaSJZqCNYWPIR9j8mfcQLaloJwvy4oG5oZVF9aenWdUchYXHuRrLf2JZqwKOkcEeh9tzWg==@iotdbaccount838.documents.azure.com:10255/?ssl=true&replicaSet=globaldb"
client = pymongo.MongoClient(url)

#CosmosDB Connection
db = client.<YourDBName>.<YourCollectionName>
#Sample db = client.iotdb.iotdbcollection

# Change title to host name to demo NLB
if app.config['SHOWHOST'] == "true":
    title = socket.gethostname()

#CosmosDB Functions
def start():
    db.delete_many({"id":"button1"})
    db.delete_many({"id":"button2"})
    db.delete_many({"id":"totalvotes"})
    db.insert_one({"id": "button1", "value": 0})
    db.insert_one({"id": "button2", "value": 0})
    db.insert_one({"id": "totalvotes", "value": 0})

@app.route('/', methods=['GET', 'POST'])
def index():

    if request.method == 'GET':

        # Get current values
        vote1 = db.find_one({"id":"button1"})["value"]
        vote2 = db.find_one({"id":"button2"})["value"]            

        # Return index with values
        return render_template("index.html", value1=int(vote1), value2=int(vote2), button1=button1, button2=button2, title=title)

    elif request.method == 'POST':

        if request.form['vote'] == 'reset':
            
            # Empty table and return results
            db.update_one({"id":"button1"},{"$set": {"value":0}})
            db.update_one({"id":"button2"},{"$set": {"value":0}})
            vote1 = db.find_one({"id":"button1"})["value"]
            vote2 = db.find_one({"id":"button2"})["value"]
            totalplayed = db.find_one({"id":"totalvotes"})["value"]
            totalplayed = int(totalplayed) + 1
            db.update_one({"id":"totalvotes"},{"$set": {"value":totalplayed}})

            return render_template("index.html", value1=int(vote1), value2=int(vote2), button1=button1, button2=button2, title=title)
        
        elif request.form['vote'] == button1:
            vote1total = int(db.find_one({"id":"button1"})["value"]) + 1
            db.update_one({"id":"button1"},{"$set": {"value":vote1total}})
            vote1 = db.find_one({"id":"button1"})["value"]
            vote2 = db.find_one({"id":"button2"})["value"]
            return render_template("index.html", value1=int(vote1), value2=int(vote2), button1=button1, button2=button2, title=title)
        
        elif request.form['vote'] == button2:
            vote2total = int(db.find_one({"id":"button2"})["value"]) + 1
            db.update_one({"id":"button2"},{"$set": {"value":vote2total}})
            vote1 = db.find_one({"id":"button1"})["value"]
            vote2 = db.find_one({"id":"button2"})["value"]
            return render_template("index.html", value1=int(vote1), value2=int(vote2), button1=button1, button2=button2, title=title)

if __name__ == "__main__":
    start()
    app.run(host='0.0.0.0',debug=True, port=80)
