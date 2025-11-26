from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    return "<h2>CUSTOMER SERVICE IS RUNNING → Port 5004</h2>"   

if __name__ == '__main__':
    app.run(port=5004, debug=True)                          