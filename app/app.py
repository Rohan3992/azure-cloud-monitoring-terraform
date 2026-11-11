from flask import Flask, jsonify
import logging

from azure.monitor.opentelemetry import configure_azure_monitor

configure_azure_monitor()

app = Flask(__name__)
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@app.route("/")
def home():
    logger.info("Home page accessed")
    return jsonify({
        "message": "Azure Cloud Monitoring Demo",
        "status": "healthy"
    })

@app.route("/health")
def health():
    logger.info("Health check accessed")
    return jsonify({"status": "healthy"}), 200

if __name__ == "__main__":
    app.run()
