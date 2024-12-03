from flask import Flask, request, send_from_directory
from pathlib import Path
from .ocr import *


UPLOAD_FOLDER = './upload'

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['MAX_CONTENT_LENGTH'] = 10240000000

SERVER_ADDR = "http://srv1.alyukov.net:5000"


@app.route('/')
def hello_world():
    return 'Hello World!'


@app.route('/upload', methods=['GET', 'POST'])
def upload_file():
    if request.method == 'POST':
        if 'file1' not in request.files:
            return 'there is no file1 in form!'
        file1 = request.files['file1']
        path = Path(app.config['UPLOAD_FOLDER'], file1.filename)
        file1.save(path)

        #init model
        model = initialize_ocr(use_angle_cls=True, lang='en')

        # Run batched inference on a list of images
        result = perform_ocr(ocr=model, img_path=str(path), cls=True)

        txt = get_text_from_image(ocr_result=result)

        ans = SERVER_ADDR + "/upload/" + path.with_stem(path.stem+'result').name

        return ans
    return '''
    <h1>Upload new File</h1>
    <form method="post" enctype="multipart/form-data">
      <input type="file" name="file1">
      <input type="submit">
    </form>
    '''

@app.route('/upload/<filename>')
def uploaded_file(filename):
    return send_from_directory(app.config['UPLOAD_FOLDER'],
                               filename)


if __name__ == '__main__':
    app.run()
