import os
import time
import cv2
import numpy as np
from flask import Flask, render_template, request, send_from_directory

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
STATIC_DIR = os.path.join(BASE_DIR, 'static')
UPLOAD_FOLDER = os.path.join(STATIC_DIR, 'uploads')

os.makedirs(UPLOAD_FOLDER, exist_ok=True)

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

@app.after_request
def add_header(response):
    response.headers['Cache-Control'] = 'no-store, no-cache, must-revalidate, max-age=0'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '0'
    return response

@app.route('/uploads/<filename>')
def display_image(filename):
    return send_from_directory(app.config['UPLOAD_FOLDER'], filename)

@app.route('/', methods=['GET', 'POST'])
def index():
    images = None
    if request.method == 'POST':
        file = request.files.get('image')
        if file and file.filename != '':
            prefix = str(int(time.time()))
            
            orig_name = f"{prefix}_original.png"
            grey_name = f"{prefix}_grey.png"
            red_name = f"{prefix}_red.png"
            green_name = f"{prefix}_green.png"
            blue_name = f"{prefix}_blue.png"

            file_path = os.path.join(app.config['UPLOAD_FOLDER'], orig_name)
            file.save(file_path)

            file_bytes = np.fromfile(file_path, dtype=np.uint8)
            img = cv2.imdecode(file_bytes, cv2.IMREAD_COLOR)

            if img is not None:
                # Grayscale
                grey = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
                cv2.imencode('.png', grey)[1].tofile(os.path.join(app.config['UPLOAD_FOLDER'], grey_name))

                # Channels
                b, g, r = cv2.split(img)
                zeros = np.zeros_like(b)

                cv2.imencode('.png', cv2.merge([zeros, zeros, r]))[1].tofile(os.path.join(app.config['UPLOAD_FOLDER'], red_name))
                cv2.imencode('.png', cv2.merge([zeros, g, zeros]))[1].tofile(os.path.join(app.config['UPLOAD_FOLDER'], green_name))
                cv2.imencode('.png', cv2.merge([b, zeros, zeros]))[1].tofile(os.path.join(app.config['UPLOAD_FOLDER'], blue_name))

                images = {
                    'original': f'/uploads/{orig_name}',
                    'grey': f'/uploads/{grey_name}',
                    'red': f'/uploads/{red_name}',
                    'green': f'/uploads/{green_name}',
                    'blue': f'/uploads/{blue_name}'
                }

    return render_template('index.html', images=images)

if __name__ == '__main__':
    app.run(debug=True, port=5000, use_reloader=False)