import enum 

class BaseOps (enum.Enum):
    LOAD = 1
    STORE = 2
    MOV = 3

    ADD = 10
    SUB = 11
    MUL = 12
    DIV = 13
    MOD = 14

    ADDF = 20
    SUBF = 21
    MULF = 22
    DIVF = 23

    CMP = 30
    JT = 31
    J = 32

class HOSTOps (enum.Enum):
    CAST = 100
    ALLOC = 102
    COPY = 103
    CALL_NDP = 104
    WAIT_NDP = 105



class NDPOps(BaseOps):
    TICK = 200
    CALL_RA = 201
    MOV_SIG = 202
    END_NDP = 210


class NDPOperation:
    def __init__(self, type, outval, inval1, inval2):
        self.type = type
        self.outval = outval
        self.inval1 = inval1 
        self.inval2 = inval2

    def getOperationType(self):
        return self.type

class HostOperation:
    def __init__(self, type):
        self.type = type
        self.invars = {}

    def getOperationType(self):
        return self.type

    def setInvar(self, value, index):
        self.invars[index] = value
