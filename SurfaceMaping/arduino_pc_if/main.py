import serial as ser
import time
import csv


class LaserScanner:
    def __init__(self, ch, BaudRate):
        self.Ch = ch
        self.BaudRate = BaudRate
        self.UserInput = 0
        self.Arduino = ser.Serial(port=self.Ch, baudrate=self.BaudRate, timeout=.1)
        self.MsgNum = 0
        self.dicbuf = {"X": [], "Y": [], "Z": []}
        self.resbuf = [["X", "Y", "Z"]]
        self.res = 0.05 * 5

    def showUI(self):
        _input = 0
        while _input != '1' and _input != '2' and _input != '3':
            _input = input("1 - Start scan \n"
                           "2 - Pong\n"
                           "3 - Exit\n")

        userinput = _input
        if userinput == 1:
            W = int(input("Enter width [mm]:"))
            L = int(input("Enter length [mm]:"))
            self.StartScan(W, L)

    def SendStartCommand(self):
        time.sleep(2)
        self.Arduino.write('1'.encode())
        time.sleep(1)
        rv = self.Arduino.read(4)
        print(rv.decode('utf-8'))

    def SendPing(self):
        self.Arduino.write('100'.encode())
        time.sleep(1)
        rv = self.Arduino.readline()
        print(rv.decode('utf-8'))

    def ReadDataMessage(self):
        self.Arduino.write('300'.encode())
        time.sleep(1)
        rv = self.Arduino.readline()
        print(rv.decode('utf-8'))


    def StartScan(self, W, L):
        X = 0

        while (X * self.res) < W:
            direc = X % 2
            Y = 0
            while (Y * self.res) < L:
                Z = self.StepAndRead(0, direc)
                self.dicbuf['X'].append(X)
                self.dicbuf['Y'].append(Y)
                self.dicbuf['Z'].append(Z)
                self.resbuf.append([X, Y, Z])
                Y += 1
            self.StepAndRead(1, 0)
            X += 1

    def DoStep(self, motor, direc):
        msg = 200 + 10 * direc + motor
        msg = str(msg)
        self.Arduino.write(msg.encode())

    def StepAndRead(self, motor, direc):
        msg = 400 + 10 * direc + motor
        msg = str(msg)
        self.Arduino.write(msg.encode())
        while not self.Arduino.in_waiting:
            continue
        rv = self.Arduino.readline()
        print(rv.decode('utf-8'))
        return int(rv.decode('utf-8'))


if __name__ == '__main__':
    ls = LaserScanner('COM5', 9600)
    time.sleep(2)
    # ls.StepAndRead(1, 1)
    # ls.StepAndRead(1, 0)
    # ls.StepAndRead(1, 1)
    # ls.StepAndRead(1, 0)
    # ls.StepAndRead(1, 1)
    # ls.StepAndRead(1, 0)
    # ls.StepAndRead(1, 1)
    # ls.StepAndRead(1, 0)
    # ls.StepAndRead(1, 1)
    # ls.StepAndRead(1, 0)
    # ls.DoStep(1, 1)
    # time.sleep(2)
    # ls.DoStep(1, 0)
    # time.sleep(2)
    # ls.DoStep(0, 0)
    # time.sleep(2)
    # ls.DoStep(0, 1)
    # ls.ReadDataMessage()
    # time.sleep(2)
    ls.StartScan(4, 4)
    with open('innovators.csv', 'w', newline='') as file:
        writer = csv.writer(file, delimiter=',')
        writer.writerows(ls.resbuf)