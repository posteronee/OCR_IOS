from flask import Flask, request, send_from_directory
from pathlib import Path
from ocr import *  # Make sure the OCR module is available and correct
import os
import json

# Load configuration
CONFIG_PATH = 'config.json'

with open(CONFIG_PATH, 'r') as config_file:
    config = json.load(config_file)

UPLOAD_FOLDER = config.get('UPLOAD_FOLDER', './upload')
MAX_CONTENT_LENGTH = config.get('MAX_CONTENT_LENGTH', 1024 * 1024 * 50)  # Default to 50MB
SERVER_ADDR = config.get('SERVER_ADDR', 'http://127.0.0.1:5000')
PORT = config.get('PORT', 5000)
HOST = config.get('HOST', '0.0.0.0')

os.makedirs(UPLOAD_FOLDER, exist_ok=True)

# Initialize Flask app
app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['MAX_CONTENT_LENGTH'] = MAX_CONTENT_LENGTH

@app.route('/')
def hello_world():
    return 'Hello! Server is running.'

@app.route('/upload', methods=['GET', 'POST'])
def upload_file():
    if request.method == 'POST':
        if 'file1' not in request.files:
            return 'No file1 in the form!', 400  # Return 400 (client error)
        file1 = request.files['file1']
        path = Path(app.config['UPLOAD_FOLDER'], file1.filename)
        file1.save(path)

        # Initialize OCR model
        model = initialize_ocr(use_angle_cls=True, lang='en')

        # Run OCR
        result = perform_ocr(ocr=model, img_path=str(path), cls=True)

        # Extract text
        txt = get_text_from_image(ocr_result=result)

        # Save result to a text file
        result_filename = path.with_stem(path.stem + '_result').with_suffix('.txt')
        with open(result_filename, 'w') as f:
            f.write(txt)

        ans = txt
        return ans, 200

    return '''
    <h1>Upload new File</h1>
    <form method="post" enctype="multipart/form-data">
      <input type="file" name="file1">
      <input type="submit">
    </form>
    '''

@app.route('/upload/<filename>')
def uploaded_file(filename):
    return send_from_directory(app.config['UPLOAD_FOLDER'], filename)

if __name__ == '__main__':
    app.run(host=HOST, port=PORT)
