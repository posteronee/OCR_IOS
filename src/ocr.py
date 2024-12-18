from paddleocr import PaddleOCR, draw_ocr
from PIL import Image


def initialize_ocr(use_angle_cls=True, lang='en'):
    """Initializes PaddleOCR with the given parameters."""
    return PaddleOCR(use_angle_cls=use_angle_cls, lang=lang)


def perform_ocr(ocr, img_path, cls=True):
    """Performs OCR analysis on the given image."""
    return ocr.ocr(img_path, cls=cls)


def save_ocr_result(image_path, result, font_path, output_path):
    """
    Draws OCR results on the image and saves it.

    :param image_path: Path to the input image
    :param result: OCR results
    :param font_path: Path to the font file
    :param output_path: Path to save the image with OCR results
    """
    image = Image.open(image_path).convert('RGB')
    boxes = [line[0] for line in result]
    texts = [line[1][0] for line in result]
    scores = [line[1][1] for line in result]
    annotated_image = draw_ocr(image, boxes, texts, scores, font_path=font_path)
    annotated_image = Image.fromarray(annotated_image)
    annotated_image.save(output_path)

def get_text_from_image(ocr_result):
    """
    Get text from OCR results.
    :param ocr_result:
    :return: res - ocr concated words
    """
    result = str()
    for idx in range(len(ocr_result)):
        res = ocr_result[idx]
        for line in res:
            result += line[-1][0] + ' '

    return result


# Example usage
if __name__ == "__main__":
    ocr_instance = initialize_ocr()
    img_path = './data/src/test.jpg'
    font_path = './tools/font_simfang.ttf'
    output_path = './data/dst/result.jpg'

    # Perform OCR
    ocr_result = perform_ocr(ocr_instance, img_path)

    # Print results
    for idx in range(len(ocr_result)):
        res = ocr_result[idx]
        for line in res:
            print(line)

    save_ocr_result(img_path, ocr_result[0], font_path, output_path)

    txt = get_text_from_image(ocr_result)
    print(txt)
