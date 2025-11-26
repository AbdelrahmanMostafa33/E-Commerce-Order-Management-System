from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    return "<h2>ORDER SERVICE IS RUNNING → Port 5001</h2>"         

if __name__ == '__main__':
    app.run(port=5001, debug=True)                          