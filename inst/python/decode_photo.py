from pyzbar.pyzbar import decode
from PIL import Image


def decode_my_photo(file_name):
    result = decode(Image.open(file_name))
    decoded_items = []
    for x in result:
        decoded_items.append(str(x.data).replace("'", "").replace("b", ""))
    return decoded_items
