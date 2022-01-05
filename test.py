import serial

#time.sleep(3)

ser = serial.Serial('/dev/ttyUSB9', baudrate=115200)#, timeout=1)
for i in range(100):
    ser.write(chr(i))
    d = ser.read()
    print ord(d)
