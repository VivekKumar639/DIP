# RGB Grayscale Splitter

A small Flask web application that breaks a colour image into its Red, Green, and Blue channels and creates a grayscale version of the same image.

## Features

- Upload an image through a simple browser interface.
- View the original image alongside grayscale, red, green, and blue outputs.
- Save each generated image as a PNG file.
- Uses timestamped filenames, so each upload is kept separate.

## Tech Stack

- Python
- Flask
- OpenCV
- NumPy
- HTML, CSS, and JavaScript

## Project Structure

```text
rgb-grayscale-splitter/
|-- app.py                  # Flask server and image-processing logic
|-- templates/
|   `-- index.html          # Web interface
|-- static/
|   `-- uploads/            # Uploaded and generated image files
`-- README.md
```

## Installation

1. Clone the repository and open this project directory.

   ```bash
   cd DIP/rgb-grayscale-splitter
   ```

2. Create and activate a virtual environment (optional but recommended).

   ```bash
   python -m venv .venv
   .venv\\Scripts\\activate
   ```

3. Install the required packages.

   ```bash
   pip install flask opencv-python numpy
   ```

## Run the Application

```bash
python app.py
```

Then open [http://127.0.0.1:5000](http://127.0.0.1:5000) in your browser. Upload an image to generate and view all five outputs.

## How It Works

1. The uploaded image is saved in `static/uploads`.
2. OpenCV reads the image and creates a grayscale copy.
3. The RGB channels are separated, with the other two channels set to zero for each colour output.
4. All generated images are displayed on the result page.

## Notes

Files inside `static/uploads` are created at runtime. They are ignored for future commits through the repository's `.gitignore` file.

## Author

Vivek Kumar
