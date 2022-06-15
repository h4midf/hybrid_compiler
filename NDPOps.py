from ast import FloorDiv
import enum 
# class HostRegs:
#     def __init__ (self, count):
#         self.regCount = count
#     def acquireReg(self, inputs):

class NDPSysOps (enum.Enum):
    LABEL = 0

    LOAD = 1 # LOAD DST (REG), [base]+off
    STORE = 2 
    MOV = 3

    ADD = 10
    SUB = 11
    MUL = 12
    DIV = 13
    MOD = 14
    FLOORDIV = 15
    POW = 16

    ADDF = 20
    SUBF = 21
    MULF = 22
    DIVF = 23 # DIVF DST, SRC1, SRC2

    CMP = 30  # CMP DST, ARG1, ARG2
    JT = 31   # JT REG, LABEL
    J = 32    # J LABEL

    
    ALLOC = 102 # ALLOC (3,3,27,28), f32 !
    COPY = 103  # COPY SRC, DST
    CALL_NDP = 104 # CALL_NDP 10, KENREL
    WAIT_NDP = 105 # WAIT_NDP 10

    TICK = 200
    CALL_RA = 201
    MOV_SIG = 202
    END_NDP = 210


 

class SerialLoop:
    def __init__ (self, index):
        self.index = index



class NDPSysOperation:
    def __init__(self, type):
        self.type = type
        self.inVars= {}

    def getOperationType(self):
        return self.type

    def setOutputVar(self, outVar):
        self.outVar = outVar
    
    def setOutputType(self, type):
        self.outVarType = type

    def setInputVars(self, inVar, index):
        self.inVars[index] = inVar

    def getOutVar(self):
        return self.outVar
        
    def getInvar(self, index):
        return self.inVars[index]
    
    def setAdditionalInfo(self, info):
        self.info = info

    def getAdditionalInfo(self):
        return self.info


class HostKernel:
    def __init__ (self, name, args):
        self.name = name 
        self.args = args
        self.ins = []
    
    def addIns (self, ins):
        self.ins += [ins]

class NDPKernel:
    def __init__ (self, name, args):
        self.name = name 
        self.args = args
        self.ins = []
    
    def addIns (self, ins):
        self.ins += [ins]
    
class HybridApplication:
    def __init__ (self):
        self.hostKernels = []
        self.ndpKernels = []
    
    def addHostKernel(self, kernel):
        self.hostKernels += [kernel]

    def addNDPKernel(self, kernel):
        self.ndpKernels += [kernel]
     