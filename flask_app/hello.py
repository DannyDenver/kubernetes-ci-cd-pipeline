from flask import Flask, escape, request

app = Flask(__name__)

@app.route('/')
def hello():
    return f'Hello, World!'

if __name__ == "__main__": 
    app.debug = True
    app.run(host='0.0.0.0', port=80)