import struct
from PIL import Image

def get_bin(img):
    buff = b''
    w, h = img.size
    for y in range(h):
        for x in range(w):
            r, g, b, a = img.getpixel((x, y))
            word = (((r >> 5) & 0b111) << 7) | (((g >> 5) & 0b111) << 4) | \
                   (((b >> 5) & 0b111) << 1) | (a >> 7)
            buff += struct.pack('<H', word)
    assert(len(buff) == 2 * w * h)
    return buff

IMAGES = ['background1.png', 'background2.png']
buff = b''
for filename in IMAGES:
    img = Image.open(filename)
    print('Processing {}: {}, {}x{}, {}'.format(filename, img.format, img.size[0], img.size[1], img.mode))
    buff += get_bin(img)

with open('images.bin', 'wb') as f:
    f.write(buff)

# img = Image.open('background1.png')
# print(img.format, img.size, img.mode)
# assert(img.mode == 'RGBA')
# img.putpixel((x, y), (r & 0b11100000, g & 0b11100000, b & 0b11100000, a & 0x80))
# print(buff)
# buff = img.tobytes()
# print(len(buff), img.size[0] * img.size[1] * 4)
# img.show()