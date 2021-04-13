import serial as ser
import time


class LaserScanner:
    def __init__(self, ch, BaudRate):
        self.Ch = ch
        self.BaudRate = BaudRate
        self.UserInput = 0
        self.Arduino = ser.Serial(port=self.Ch, baudrate=self.BaudRate, timeout=.1)
        self.MsgNum = 0
        self.MsgBuffer = [[0, 0, 0]]
        self.MsgLogger = []

    def showUI(self):
        _input = 0
        while _input != '1' and _input != '2':
            _input = input("1 - Start scan \n"
                           "2 - Exit\n")
        self.UserInput = _input

    def SendStartCommand(self):
        self.Arduino.write('1'.encode())

    def SendPing(self):
        self.Arduino.write('2'.encode())
        time.sleep(1)
        rv = self.Arduino.read(4)
        print(rv.decode('utf-8'))
        self.Arduino.write('2'.encode())
        time.sleep(1)
        self.Arduino.flush()
        rv = self.Arduino.read(4)
        print(rv.decode('utf-8'))

    def ReadDataMessage(self):
        msg = [int(self.Arduino.read(1).decode('utf-8')),
               int(self.Arduino.read(1).decode('utf-8')),
               int(self.Arduino.read(1).decode('utf-8')),
               int(self.Arduino.read(1).decode('utf-8'))]
        print(msg)
        self.MsgBuffer = msg

    def SaveDataMsg(self):
        self.MsgLogger.append(self.MsgBuffer)


if __name__ == '__main__':
    ls = LaserScanner('COM5', 9600)
    ls.showUI()
    ls.SendStartCommand()
    time.sleep(2)
    ls.ReadDataMessage()
    ls.SaveDataMsg()
    ls.SendStartCommand()
    time.sleep(2)
    ls.ReadDataMessage()
    ls.SaveDataMsg()
    print(ls.MsgLogger)
    ls.SendPing()
