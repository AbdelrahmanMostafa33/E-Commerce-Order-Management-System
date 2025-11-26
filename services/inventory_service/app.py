from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    return "<h2>INVENTORY SERVICE IS RUNNING → Port 5002</h2>"   

if __name__ == '__main__':
    app.run(port=5002, debug=True)                          