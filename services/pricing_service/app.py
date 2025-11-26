from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    return "<h2>PRICING SERVICE IS RUNNING → Port 5003</h2>"   

if __name__ == '__main__':
    app.run(port=5003, debug=True)                          