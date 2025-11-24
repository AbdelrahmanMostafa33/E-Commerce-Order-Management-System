# Import the Flask class from the flask module
# Flask is a micro web framework in Python that allows you to create web applications easily
from flask import Flask

# Create an instance of the Flask class
# __name__ is a special Python variable that is set to the name of the module.
# Flask uses it to know where to look for templates, static files, etc.
app = Flask(__name__)

# Define a route for the root URL "/"
# @app.route("/") is a decorator that tells Flask to execute the following function
# when someone accesses the root URL of this web application
@app.route("/")
def home():
    # This function returns a simple string that will be displayed in the browser
    return "Notification Service Running"

# This block ensures that the app runs only if this script is executed directly,
# and not if it is imported as a module in another script
if __name__ == "__main__":
    # Run the Flask web server
    # port=5001 means the server will listen on port 5005 (default is 5000)
    # You can access this app in your browser at http://127.0.0.1:5005/
    app.run(port=5005)
