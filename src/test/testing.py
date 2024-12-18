import unittest
import requests

class TestModel(unittest.TestCase):
    BASE_URL = 'http://178.64.3.118:5000/upload'

    def send_image(self, image_path):
        with open(image_path, 'rb') as image_file:
            files = {'file': image_file}
            response = requests.post(self.BASE_URL, files=files)
            return response.json()

    def test_process_image_valid(self):
        image_path = 'data/photo1.jpg'
        expected_text = 'Text example for OCR App'
        result = self.send_image(image_path)
        self.assertEqual(result['text'], expected_text)

    def test_process_image_large_file(self):
        image_path = 'src/test/data/photo2.jpg'
        expected_text = "Hello! My name is Danya. Today I'm going to show you how OCR App works, with these example photos with handwriting text!"
        result = self.send_image(image_path)
        self.assertEqual(result['text'], expected_text)

    def test_process_image_small_file(self):
        image_path = 'src/test/data/photo3.jpg'
        expected_text = 'Pirate'
        result = self.send_image(image_path)
        self.assertEqual(result['text'], expected_text)

    def test_process_image_no_text(self):
        image_path = 'src/test/data/photo4.jpg'
        expected_text = ''
        result = self.send_image(image_path)
        self.assertEqual(result['text'], expected_text)

    def test_process_image_multiple_texts(self):
        image_path = 'src/test/data/photo5.jpg'
        expected_text = 'Handwriting text№1\nHandwriting text№2\nHandwriting text№3'
        result = self.send_image(image_path)
        self.assertEqual(result['text'], expected_text)

    def test_process_image_special_characters(self):
        image_path = 'src/test/data/photo6.jpg'
        expected_text = 'Example: # % № ? ! ; * & $'
        result = self.send_image(image_path)
        self.assertEqual(result['text'], expected_text)

    def test_process_image_inverted_text(self):
        image_path = 'src/test/data/photo7.jpg'
        expected_text = 'I love programming!'
        result = self.send_image(image_path)
        self.assertEqual(result['text'], expected_text)

    def test_process_image_russian_characters(self):
        image_path = 'src/test/data/photo8.jpg'
        expected_text = 'Я люблю Россию! Кто против?'
        result = self.send_image(image_path)
        self.assertEqual(result['text'], expected_text)

    def test_process_image_russian_characters_large(self):
        image_path = 'src/test/data/photo9.jpg'
        expected_text = 'Долгкий текст с ошибкгами, как будто у менйа какая-то проблема писать по нормальному, жееесть'
        result = self.send_image(image_path)
        self.assertEqual(result['text'], expected_text)

    def test_process_image_inverted_russian_characters(self):
        image_path = 'src/test/data/photo10.jpg'
        expected_text = 'Ну типа я перевернутый!!'
        result = self.send_image(image_path)
        self.assertEqual(result['text'], expected_text)


if __name__ == '__main__':
    unittest.main()
