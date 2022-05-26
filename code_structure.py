import enum

class SupportedTypes(enum.Enum):
   i32 = 1 
   i64 = 2 
   index = 3 
   f32 = 4
   f64 = 5
   memref = 6

class LoopType(enum.Enum):
    parallel = 1
    forLoop = 2

class Variable:
    def __init__(self, name):
        self.name = name

    def setInitVal(self, val):
        self.val= val 

    def setValType(self, type):
        self.type = type


class CodeBlock:
    def __init__ (self):
        self.ins = []

    def addIns(self, ins):
        self.ins += [ins]
    
    def getIns(self):
        return self.ins
    
class Loop (CodeBlock):
    def __init__(self, start, end):
        CodeBlock.__init__(self)
        self.args = {}
        self.start = start
        self.end = end 

    def setLoopType(self, type):
        self.type = type

    def setLoopLocalVariales(self, var ):
        self.localVariables[var.name] = var


class Function(CodeBlock):

    def __init__(self, name):
        CodeBlock.__init__(self)
        self.name = name
        self.args = {}
        self.ins = []

    def setArgsByArray(self, args):
        for arg in args:
            argName = arg.split(":")[0]
            argType = arg.split(":")[1]
            newVar = Variable(argName)
            newVar.setValType(argType)
            self.args[argName] = newVar

    def setFuncLocalVariales(self, var ):
        self.localVariables[var.name] = var
    

class Module:
    def __init__ (self):
        self.funcs = []

    def addFunc(self, func):
        self.funcs+= [func]
    
    def getFuncs(self):
        return self.funcs
