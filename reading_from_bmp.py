filename = 'from_gimp.bmp'
file = open(filename, 'rb')
header = {'id', 'size', 'nothing', 'offset'}


for i in range(4):
    if i == 1 or i==3:
        byte = file.read(4)
    else: byte = file.read(2)
    print(byte.format(ord(byte)))
