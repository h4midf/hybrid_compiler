import enum
import enum
from map import *
from operation import *

# selected_file = "./stencils/seidel-2d/seidel-2d.mlir"
# selected_file = "./stencils/jacobi-2d/jacobi-2d.mlir"
selected_file = "./test/conv2d.mlir"


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


class Application:
    def __init__ (self):
        self.modules = []
        self.mapsParser = MapsParser()
    
    def addMap(self, mapStr):
        self.mapsParser.addMapByStr(mapStr)
    
    def addModule(self, module):
        self.modules += [module]

    def getModules(self):
        return self.modules

        


def handleType(typeStr):
    if (typeStr == "index"):
        return SupportedTypes.index
    elif (typeStr == "i32"):
        return SupportedTypes.i32
    elif (typeStr == "i64"):
        return SupportedTypes.i64
    elif (typeStr == "f32"):
        return SupportedTypes.f32
    elif (typeStr == "f64"):
        return SupportedTypes.f64
    elif (typeStr.find("memref")!= -1):
        return SupportedTypes.memref

    print("Not handled type " + typeStr)
    exit()

    
def parse_arith_index_cast(line):
    # print(line)
    output = line.split(" = ")[0]
    input = line.split(" ")[3]
    type = line.split(" ")[7]
    op = Operation()
    op.setInVar(input, 1)
    op.setOutputVar(output)
    op.setOperation(SupportedOperation.arith_index_cast)
    op.setOutputType(handleType(type))
    return op

def parse_arith_constant(line):
    # print(line)
    output = line.split(" = ")[0]
    input = line.split(" ")[3]
    type = line.split(" ")[5]
    op = Operation()
    op.setInVar(input, 1)
    op.setOutputVar(output)
    op.setOperation(SupportedOperation.arith_constant)
    op.setOutputType(handleType(type))
    return op

def parse_arith_addf(line):
    # print(line)
    output = line.split(" = ")[0]
    input1 = line.split(" ")[3].split(",")[0]
    input2 = line.split(" ")[4]
    type = line.split(" : ")[1]
    op = Operation()
    op.setInVar(input1, 1)
    op.setInVar(input2, 1)
    op.setOutputVar(output)
    op.setOperation(SupportedOperation.arith_addf)
    op.setOutputType(handleType(type))
    return op

def parse_arith_mulf(line):
    # print(line)
    output = line.split(" = ")[0]
    input1 = line.split(" ")[3].split(",")[0]
    input2 = line.split(" ")[4]
    type = line.split(" : ")[1]
    op = Operation()
    op.setInVar(input1, 1)
    op.setInVar(input2, 1)
    op.setOutputVar(output)
    op.setOperation(SupportedOperation.arith_mulf)
    op.setOutputType(handleType(type))
    return op

def parse_affine_load (line):
    # print(line)
    output = line.split(" = ")[0]
    input = line.split(" = ")[1].split("affine.load")[1].split(" : ")[0].strip()
    type = line.split(" : ")[1]
    op = Operation()
    op.setInVar(input, 1)
    op.setOutputVar(output)
    op.setOperation(SupportedOperation.affine_load)
    op.setOutputType(handleType(type))
    op.setAdditionalInfo(type)
    return op

def parse_affine_store (line):
    # print(line)
    type = line.split(" : ")[-1]
    line = "".join(line.split(" : ")[:-1])
    input1 = line.split("affine.store")[1].split(", ")[0]
    input2 = ", ".join(line.split("affine.store")[1].split(", ")[1:])
    op = Operation()
    op.setInVar(input1, 1)
    op.setInVar(input2, 2)
    op.setOperation(SupportedOperation.affine_store)
    op.setOutputType(handleType(type))
    op.setAdditionalInfo(type)
    return op

def parse_affine_apply (line):
    # print(line)
    output = line.split(" = ")[0]
    input = line.split(" = ")[1].split("affine.apply")[1].strip()
    op = Operation()
    op.setInVar(input, 1)
    op.setOutputVar(output)
    op.setOperation(SupportedOperation.affine_apply)
    return op

def parse_memref_alloc (line):
    # print(line)
    output = line.split(" = ")[0]
    input = line.split(" = ")[1].split("memref.alloc()")[1].split(" : ")[0].strip()
    type = line.split(" : ")[-1]
    op = Operation()
    op.setInVar(input, 1)
    op.setOutputVar(output)
    op.setOperation(SupportedOperation.memref_alloc)
    op.setOutputType(handleType(type))
    op.setAdditionalInfo(type)
    return op

def parse_memref_copy (line):
    # print(line)
    line = line[12:]
    fromVar = line.split(" : ")[0].split(", ")[0]
    toVar = line.split(" : ")[0].split(", ")[1]
    outputType1 = line.split(" : ")[1].split(" to ")[0]
    outputType2 = line.split(" : ")[1].split(" to ")[1]
    # print(fromVar, toVar, outputType1, outputType2)
    op = Operation()
    op.setInVar(fromVar, 1)
    op.setOutputVar(toVar)
    op.setOperation(SupportedOperation.memref_copy)
    op.setOutputType(handleType(outputType1))
    op.setAdditionalInfo(outputType1 + " " + outputType2)
    return op

def parseOperation(line):
    # print(line)
    operation = line.split(" = ")[1].split(" ")[0]
    if(operation == "arith.index_cast"):
        return parse_arith_index_cast(line)
    elif(operation == "arith.constant"):
        return parse_arith_constant(line)
    elif(operation == "arith.addf"):
        return parse_arith_addf(line)
    elif(operation == "arith.mulf"):
        return parse_arith_mulf(line)
    elif(operation == "affine.load"):
        return parse_affine_load(line)
    elif(operation == "affine.apply"):
        return parse_affine_apply(line)
    elif(operation == "memref.alloc()"):
        return parse_memref_alloc(line)

    else:
        print("not handled " + operation)
        print(line)
        exit()

def parseNoOutOperation(line):
    if(line.startswith("affine.store")):
        return parse_affine_store(line)
    elif(line.startswith("memref.copy")):
        return parse_memref_copy(line)
    else:
        print("not handled " + line)
        exit()

def parseIns(inputFile, block):
    line = ""
    while(True):
        line = inputFile.readline().strip()
        # print(line)
        if(line == "return"):
            inputFile.readline()
            return

        if(line == "}"):
            return

        if(line.startswith("affine.for") or line.startswith("affine.parallel")):
            if(line.startswith("affine.for")):
                line = line[11:]
                type = LoopType.forLoop
            else:
                line = line[15:]
                type = LoopType.parallel 

            startVarStr = line.split("to")[0].replace(" ", "")
            startVar = Variable(startVarStr.split("=")[0])
            startVar.setInitVal(startVarStr.split("=")[1])

            endVarStr = line.split("to")[1].replace(" ", "")[:-1]
            endVar = Variable(endVarStr.split("=")[0])
            
            newLoop = Loop(startVar, endVar)
            parseIns(inputFile, newLoop)

            newLoop.setLoopType(type)

            # block.addLoop(newLoop) 
            block.addIns(newLoop) 
            continue

        if(line.startswith("%")):
            # block.addOperation(parseOperation(line))
            block.addIns(parseOperation(line))
        elif (line.startswith("affine.store")):
            # block.addOperation(parseNoOutOperation(line))
            block.addIns(parseNoOutOperation(line))
        elif (line.startswith("memref.copy")):
            # block.addOperation(parseNoOutOperation(line))
            block.addIns(parseNoOutOperation(line))
        else:
            print("not handled " + line)


def parseModule(inputFile, module):
    while(True):
        line = inputFile.readline().strip()
        
        if(line == "}"):
            return
        
        if(line.startswith("func")):

            func_name = line.split(" ")[1].split("(")[0][1:]
            newFunc = Function(func_name)
                
            argSets = line.split("(")[1].split(")")[0].replace(" ", "").split(",")
            newFunc.setArgsByArray(argSets)    

            parseIns(inputFile, newFunc)
            module.addFunc(newFunc)

            continue

       
def parseIR(fileName, workload):
    file = open(fileName, "r")
    while(True):
        line = file.readline()
        if(len(line)==0):
            return
            
        line = line[:-1].strip()

        if (line.startswith("module")):
            newModule = Module()
            parseModule(file, newModule)
            workload.addModule(newModule)
            continue
        elif (line.find("affine_map") != -1):
            workload.addMap(line)
            continue
        else:
            print("not handled " + line)
            exit()

def getOperationStr(op):
    if(op == SupportedOperation.arith_index_cast):
        return "CAST"
    if(op == SupportedOperation.arith_constant):
        return "CONST"
    if(op == SupportedOperation.arith_addf):
        return "ADDF"
    if(op == SupportedOperation.arith_mulf):
        return "MULF"
    if(op == SupportedOperation.affine_load):
        return "LOAD"
    if(op == SupportedOperation.affine_store):
        return "STORE"
    if(op == SupportedOperation.affine_apply):
        return "APPLY"
    if(op == SupportedOperation.memref_alloc):
        return "ALLOC"
    if(op == SupportedOperation.memref_copy):
        return "COPY"


        

def printInstructionOfABlock(block, nest_level):
    instruction_sequence = ""
    for ins in block.getIns():
        if(isinstance(ins,Loop)):
            if(ins.type == LoopType.parallel):
                instruction_sequence += (nest_level*"\t"+"PARALLEL:\n"+printInstructionOfABlock(ins, nest_level+1))
            else:
                instruction_sequence += (nest_level*"\t"+"SERIAL:\n"+printInstructionOfABlock(ins, nest_level+1))

        elif (isinstance(ins, Operation)):
            instruction_sequence += (nest_level*"\t" + getOperationStr(ins.operation) + "\n")
        else:
            instruction_sequence += "Unknown\n"
    return instruction_sequence

def printInstructions(workload):
    instruction_sequence = ""
    for module in workload.getModules():
        for func in module.getFuncs():
            instruction_sequence+= (printInstructionOfABlock(func, 0))
    print(instruction_sequence)

def compileHelper(block, nest_level, mapsParser):
    instruction_sequence = ""
    for ins in block.getIns():
        if(isinstance(ins,Loop)):
            if(ins.type == LoopType.parallel):
                instruction_sequence += (nest_level*"\t"+"PARALLEL:\n"+compileHelper(ins, nest_level+1, mapsParser))
            else:
                instruction_sequence += (nest_level*"\t"+"SERIAL:\n"+compileHelper(ins, nest_level+1, mapsParser))

        elif (isinstance(ins, Operation)):
            if(ins.operation == SupportedOperation.affine_apply):
                instruction_sequence += (nest_level*"\t" + mapsParser.apply(ins) + "\n")
            else:
                instruction_sequence += (nest_level*"\t" + getOperationStr(ins.operation) + "\n")
        else:
            instruction_sequence += "Unknown\n"
    return instruction_sequence

def compile(workload):
    instruction_sequence = ""
    for module in workload.getModules():
        for func in module.getFuncs():
            instruction_sequence+= (compileHelper(func, 0, workload.mapsParser))
    print(instruction_sequence)


workload = Application()
parseIR(selected_file, workload)
# printInstructions(workload)

compile(workload)






