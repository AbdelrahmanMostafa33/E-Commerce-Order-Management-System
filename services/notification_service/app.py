from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    return "<h2>NOTIFICATION SERVICE IS RUNNING → Port 5005</h2>"   

if __name__ == '__main__':
    app.run(port=5005, debug=True)                          