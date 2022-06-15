import enum
from os import environ
from NDP import NDPSystem
from map import *
from operation import *
from code_structure import *

benchmark_workloads = ["2mm", "3mm", "atax", "correlation" , "gemm", "gemver", "correlation", "jacobi-2d"]



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

def parseInputVar(input):
    if(input.find("symbol")!=-1):
        return input.replace("symbol", "")
    return input
def parse_arith_index_cast(line):
    # print(line)
    output = line.split(" = ")[0]
    input = parseInputVar(line.split(" ")[3])
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
    input = parseInputVar(line.split(" ")[3])
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
    input1 = parseInputVar(line.split(" ")[3].split(",")[0])
    input2 = parseInputVar(line.split(" ")[4])
    type = line.split(" : ")[1]
    op = Operation()
    op.setInVar(input1, 1)
    op.setInVar(input2, 2)
    op.setOutputVar(output)
    op.setOperation(SupportedOperation.arith_addf)
    op.setOutputType(handleType(type))
    return op

def parse_arith_subf(line):
    # print(line)
    output = line.split(" = ")[0]
    input1 = parseInputVar(line.split(" ")[3].split(",")[0])
    input2 = parseInputVar(line.split(" ")[4])
    type = line.split(" : ")[1]
    op = Operation()
    op.setInVar(input1, 1)
    op.setInVar(input2, 2)
    op.setOutputVar(output)
    op.setOperation(SupportedOperation.arith_subf)
    op.setOutputType(handleType(type))
    return op

def parse_arith_addi(line):
    # print(line)
    output = line.split(" = ")[0]
    input1 = parseInputVar(line.split(" ")[3].split(",")[0])
    input2 = parseInputVar(line.split(" ")[4])
    type = line.split(" : ")[1]
    op = Operation()
    op.setInVar(input1, 1)
    op.setInVar(input2, 2)
    op.setOutputVar(output)
    op.setOperation(SupportedOperation.arith_addi)
    op.setOutputType(handleType(type))
    return op

def parse_arith_subi(line):
    # print(line)
    output = line.split(" = ")[0]
    input1 = parseInputVar(line.split(" ")[3].split(",")[0])
    input2 = parseInputVar(line.split(" ")[4])
    type = line.split(" : ")[1]
    op = Operation()
    op.setInVar(input1, 1)
    op.setInVar(input2, 2)
    op.setOutputVar(output)
    op.setOperation(SupportedOperation.arith_subi)
    op.setOutputType(handleType(type))
    return op

def parse_arith_mulf(line):
    # print(line)
    output = line.split(" = ")[0]
    input1 = parseInputVar(line.split(" ")[3].split(",")[0])
    input2 = parseInputVar(line.split(" ")[4])
    type = line.split(" : ")[1]
    op = Operation()
    op.setInVar(input1, 1)
    op.setInVar(input2, 2)
    op.setOutputVar(output)
    op.setOperation(SupportedOperation.arith_mulf)
    op.setOutputType(handleType(type))
    return op

def parse_arith_divf(line):
    # print(line)
    output = line.split(" = ")[0]
    input1 = parseInputVar(line.split(" ")[3].split(",")[0])
    input2 = parseInputVar(line.split(" ")[4])
    type = line.split(" : ")[1]
    op = Operation()
    op.setInVar(input1, 1)
    op.setInVar(input2, 2)
    op.setOutputVar(output)
    op.setOperation(SupportedOperation.arith_divf)
    op.setOutputType(handleType(type))
    return op

def parse_math_sqrt(line):
    # print(line)
    output = line.split(" = ")[0]
    input = parseInputVar(line.split("math.sqrt")[1].split(" : ")[0])
    type = line.split(" : ")[1]
    op = Operation()
    op.setInVar(input, 1)
    op.setOutputVar(output)
    op.setOperation(SupportedOperation.math_sqrt)
    op.setOutputType(handleType(type))
    return op

def parse_arith_cmpf(line):
    # print(line)
    output = line.split(" = ")[0]
    input1 = parseInputVar(line.split(", ")[1])
    input2 = parseInputVar(line.split(", ")[2].split(" : ")[0])
    type = line.split(" : ")[1]
    op = Operation()
    op.setInVar(input1, 1)
    op.setInVar(input2, 2)
    op.setOutputVar(output)
    op.setOperation(SupportedOperation.arith_cmpf)
    op.setOutputType(handleType(type))
    return op

def parse_arith_select(line):
    # print(line)
    output = line.split(" = ")[0]
    line = line.split("arith.select")[1]
    input1 = parseInputVar(line.split(", ")[0])
    input2 = parseInputVar(line.split(", ")[1])
    input3 = parseInputVar(line.split(", ")[2].split(" : ")[0])
    type = line.split(" : ")[1]
    op = Operation()
    op.setInVar(input1, 1)
    op.setInVar(input2, 2)
    op.setInVar(input3, 3)
    op.setOutputVar(output)
    op.setOperation(SupportedOperation.arith_select)
    op.setOutputType(handleType(type))
    return op


def parse_affine_load (line):
    # print(line)
    output = line.split(" = ")[0]
    input = parseInputVar(line.split(" = ")[1].split("affine.load")[1].split(" : ")[0].strip())
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
    line = "".join(line.split(" : ")[:-1]).strip()
    input1 = parseInputVar(line.split("affine.store")[1].split(", ")[0].strip())
    input2 = parseInputVar(", ".join(line.split("affine.store")[1].split(", ")[1:]).strip())
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
    input = parseInputVar(line.split(" = ")[1].split("affine.apply")[1].strip())
    op = Operation()
    op.setInVar(input, 1)
    op.setOutputVar(output)
    op.setOperation(SupportedOperation.affine_apply)
    return op

def parse_memref_alloc (line):
    # print(line)
    output = line.split(" = ")[0]
    input = parseInputVar(line.split(" = ")[1].split("memref.alloc()")[1].split(" : ")[0].strip())
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
    fromVar = parseInputVar(line.split(" : ")[0].split(", ")[0])
    toVar = parseInputVar(line.split(" : ")[0].split(", ")[1])
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
    elif(operation == "arith.subf"):
        return parse_arith_subf(line)
    elif(operation == "arith.addi"):
        return parse_arith_addi(line)
    elif(operation == "arith.subi"):
        return parse_arith_subi(line)
    elif(operation == "arith.mulf"):
        return parse_arith_mulf(line)
    elif(operation == "arith.divf"):
        return parse_arith_divf(line)
    elif(operation == "affine.load"):
        return parse_affine_load(line)
    elif(operation == "affine.apply"):
        return parse_affine_apply(line)
    elif(operation == "memref.alloc()"):
        return parse_memref_alloc(line)
    elif(operation == "math.sqrt"):
        return parse_math_sqrt(line)
    elif(operation == "arith.cmpf"):
        return parse_arith_cmpf(line)
    elif(operation == "arith.select"):
        return parse_arith_select(line)
        

    else:
        print("not handled !! " + operation)
        print(line)
        exit()

def parseNoOutOperation(line):
    if(line.startswith("affine.store")):
        return parse_affine_store(line)
    elif(line.startswith("memref.copy")):
        return parse_memref_copy(line)
    else:
        print("not handled !!!" + line)
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
            startVarName = startVarStr.split("=")[0]
            if(startVarName[0] == "("):
                startVarName = startVarName[1:][:-1]
            startVar = Variable(parseInputVar(startVarName))
            startVarStr = startVarStr.split("=")[1]
            if(startVarStr[0]=="("):
                startVarStr = startVarStr[1:][:-1]
            startVar.setInitVal(parseInputVar(startVarStr))

            endVarStr = line.split("to")[1].replace(" ", "")[:-1]
            endVar = Variable(parseInputVar(endVarStr.split("=")[0]))
            if(endVarStr[0]=="("):
                endVarStr = endVarStr[1:][:-1]
            endVar.setInitVal(parseInputVar(endVarStr))
            # print("Start " + startVar.name + " end " + endVar.name)
            newLoop = Loop(startVar, endVar)
            parseIns(inputFile, newLoop)

                # print(line)
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
            print("not handled! " + line)


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
            if(len(line.strip())>0):
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

serial_loop_counter = 0


for work in benchmark_workloads:
    full_address = "./selected/"+work+"/"+work+"-opt.mlir"
    workload = Application()
    parseIR(full_address, workload)

    ndpSystem = NDPSystem()
    ndpSystem.splitToHostNDP(workload, work)






