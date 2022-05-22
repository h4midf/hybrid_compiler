import enum
class SupportedOperation(enum.Enum):
   arith_index_cast = 1 # arith.index_cast
   arith_constant = 2 # arith.constant 
   arith_addf = 3 # arith.addf
   arith_mulf = 4 # arith.mulf

   affine_load = 11 # affine.load
   affine_store = 12 # affine.store
   affine_apply = 13 # affine.apply

   memref_alloc = 21 # memref.alloc()
   memref_copy = 22 # memref.copy

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