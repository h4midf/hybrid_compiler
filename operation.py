import enum
class SupportedOperation(enum.Enum):
    arith_index_cast = 1 # arith.index_cast
    arith_constant = 2 # arith.constant 
    arith_addf = 3 # arith.addf
    arith_mulf = 4 # arith.mulf
    arith_divf = 5 # arith.divf
    arith_subf = 6 # arith.subf
    arith_cmpf = 7 # arith.cmpf
    arith_select = 8 # arith.select
    arith_addi = 9
    arith_subi = 10


    affine_load = 11 # affine.load
    affine_store = 12 # affine.store
    affine_apply = 13 # affine.apply

    memref_alloc = 21 # memref.alloc()
    memref_copy = 22 # memref.copy

    math_sqrt  = 30 # math.sqrt

class Operation:
    def __init__(self):
        self.inVars = {}

    def setOutputVar(self, val):
        self.outputVal = val

    def setOutputType(self, type):
        self.outputType = type 

    def setInVar(self, val, index):
        self.inVars[index] = val

    def setOperation(self, operation):
        self.operation= operation 

    def setAdditionalInfo(self, info):
        self.info = info
    
    def getOperationType(self):
        return self.operation
    

def getOperationStr(op):
    if (op == "^"):
        return "POW"
    elif (op == "*"):
        return "MUL"
    elif (op == "/"):
        return "DIV"
    elif (op == "mod"):
        return "MOD"
    elif (op == "+"):
        return "ADD"
    elif (op == "-"):
        return "SUB"
    elif (op == "floordiv"):
        return "FDIV"
    else:
        return "NON SUPPORTED OP"