from operation import *
import enum 
from NDPOps import *

class MapType(enum.Enum):
    define = 1 # like define in C/C++
    noSymbol = 2
    withSymbol = 3

class Map:
    def __init__ (self, type):
        self.type = type
    
    def setDimensions(self, dimStr):
        self.dims = dimStr.split(", ")
    
    def setSymbol (self, symbol):
        self.symbol = symbol
    
    def setMapFunc (self, func):
        self.mapFunc = func
    def replaceWithAppOp(self, inFunc):
        outFunc = inFunc.replace("mod" , "%")
        outFunc = outFunc.replace("floordiv" , "/")
        # print("in " + inFunc + " out " + outFunc)
        return outFunc 

    def apply(self, variableDic, dimStr=None, symStr=None):
        if(self.type == MapType.define):
            return str(eval(self.mapFunc))
        elif(self.type == MapType.noSymbol):
            dims = dimStr.split(", ")
            i = 0
            tempMapFunc = self.mapFunc
            for dim in dims:
                if(dim in variableDic):
                    dim = variableDic[dim]
                tempMapFunc = tempMapFunc.replace(self.dims[i], dim)
                i += 1
            return str(eval(tempMapFunc[1:][:-1]))
        else:
            dims = dimStr.split(", ")
            i = 0
            tempMapFunc = self.mapFunc
            print(tempMapFunc)
            for dim in dims:
                if(dim in variableDic):
                    dim = variableDic[dim]
                tempMapFunc = tempMapFunc.replace(str(self.dims[i]), str(dim))
                i += 1

            if(symStr in variableDic):
                symStr = variableDic[symStr]
            tempMapFunc = tempMapFunc.replace(self.symbol, symStr)
            tempMapFunc = self.replaceWithAppOp(tempMapFunc)
            # print(tempMapFunc)
            # print(variableDic)
            return str(eval(tempMapFunc))

def Priority(tok):
    if tok is "^" or tok is "mod" or tok is "floordiv":
        return 3
    elif tok is "/" or tok is "*":
        return 2
    elif tok is "+" or tok is "-":
        return 1
    # When char is '(' loop should not be executed.
    return float("inf")

def InfixToReg(expression, outputVal):
    output = [] 
    result = []
    stack = []
    tempVarCounter = 1
    operations = ["^", "*", "/", "+", "-", "(", "mod", "floordiv"]
    for token in expression.split(" "):

        if token in operations:
            # Pop and append operators greater than scanned operator.
            while (
                len(stack) > 0
                and stack[-1] != "("
                and Priority(stack[-1]) >= Priority(token)
            ):
                popped = stack.pop()
                if(popped in operations):
                    in1 = output[-1]
                    in2 = output[-2]
                    result += [getOperationStr(popped) + " temp" + str(tempVarCounter) + ", " + in1 + ", " + in2]
                    output = output[:-2]
                    output += ["temp"+ str(tempVarCounter)]
                    tempVarCounter+=1 
                else:
                    output += [popped] 
          
            stack.append(token)
        elif token is ")":
            while stack[-1] != "(":
                popped = stack.pop()
                if(popped in operations):
                    in1 = output[-1]
                    in2 = output[-2]
                    result += [getOperationStr(popped) + " temp" + str(tempVarCounter) + ", " + in1 + ", " + in2]
                    output = output[:-2]
                    output += ["temp"+ str(tempVarCounter)]
                    tempVarCounter+=1 
                else:
                    output += [popped]

            stack.pop()
        else:
            output += [token]
    # Pop all remaining elements.
    while len(stack) > 0:
        popped = stack.pop()
        if(popped in operations):
            in1 = output[-1]
            in2 = output[-2]
            result += [getOperationStr(popped) + " temp" + str(tempVarCounter) + ", " + in1 + ", " + in2]
            output = output[:-2]
            output += ["temp"+ str(tempVarCounter)]
            tempVarCounter+=1 
        else:
            output += [popped]
    result += ["MOV " + outputVal+ ", temp" + str(tempVarCounter)]
    return result

def strOpToNDPOp(op, isKernel):
    if(isKernel):
        if(op == "+"):
            return NDPOps.ADD
        if(op == "-"):
            return NDPOps.SUB
        if(op == "*"):
            return NDPOps.MUL
        if(op == "/"):
            return NDPOps.DIV
        if(op == "mod"):
            return NDPOps.MOD
        if(op == "^"):
            print("Not supported op")
            exit()
        if(op == "floordiv"):
            return NDPOps.FLOORDIV
    else:
        if(op == "+"):
            return HOSTOps.ADD
        if(op == "-"):
            return HOSTOps.SUB
        if(op == "*"):
            return HOSTOps.MUL
        if(op == "/"):
            return HOSTOps.DIV
        if(op == "mod"):
            return HOSTOps.MOD
        if(op == "^"):
            return HOSTOps.POW
        if(op == "floordiv"):
            return HOSTOps.FLOORDIV
    
        

def InfixToRegNDP(expression, outputVal, isKernel):
    output = [] 
    result = []
    stack = []
    tempVarCounter = 1
    operations = ["^", "*", "/", "+", "-", "(", "mod", "floordiv"]
    for token in expression.split(" "):

        if token in operations:
            # Pop and append operators greater than scanned operator.
            while (
                len(stack) > 0
                and stack[-1] != "("
                and Priority(stack[-1]) >= Priority(token)
            ):
                popped = stack.pop()
                if(popped in operations):
                    in1 = output[-1]
                    in2 = output[-2]
                    if(isKernel):
                        kernelOp = NDPOperation(strOpToNDPOp(popped))
                        kernelOp.setInputVars(in1, 1)
                        kernelOp.setInputVars(in2, 2)
                        outputVar = "temp" + str(tempVarCounter)
                        kernelOp.setOutputVar(outputVar)
                        result += [kernelOp]
                    else:
                        hostOp = HostOperation(strOpToNDPOp(popped))
                        hostOp.setInputVars(in1, 1)
                        hostOp.setInputVars(in2, 2)
                        outputVar = "temp" + str(tempVarCounter)
                        hostOp.setOutputVar(outputVar)
                        result += [hostOp]

                    output = output[:-2]
                    output += ["temp"+ str(tempVarCounter)]
                    tempVarCounter+=1 

                else:
                    output += [popped] 
            stack.append(token)

        elif token is ")":
            while stack[-1] != "(":
                popped = stack.pop()
                if(popped in operations):
                    in1 = output[-1]
                    in2 = output[-2]
                    if(isKernel):
                        kernelOp = NDPOperation(strOpToNDPOp(popped))
                        kernelOp.setInputVars(in1, 1)
                        kernelOp.setInputVars(in2, 2)
                        outputVar = "temp" + str(tempVarCounter)
                        kernelOp.setOutputVar(outputVar)
                        result += [kernelOp]
                    else:
                        hostOp = HostOperation(strOpToNDPOp(popped))
                        hostOp.setInputVars(in1, 1)
                        hostOp.setInputVars(in2, 2)
                        outputVar = "temp" + str(tempVarCounter)
                        hostOp.setOutputVar(outputVar)
                        result += [hostOp]

                    output = output[:-2]
                    output += ["temp"+ str(tempVarCounter)]
                    tempVarCounter+=1 
                else:
                    output += [popped]

            stack.pop()
        else:
            output += [token]
    # Pop all remaining elements.
    while len(stack) > 0:
        popped = stack.pop()
        if(popped in operations):
            in1 = output[-1]
            in2 = output[-2]
            if(isKernel):
                kernelOp = NDPOperation(strOpToNDPOp(popped, isKernel))
                kernelOp.setInputVars(in1, 1)
                kernelOp.setInputVars(in2, 2)
                outputVar = "temp" + str(tempVarCounter)
                kernelOp.setOutputVar(outputVar)
                result += [kernelOp]
            else:
                hostOp = HostOperation(strOpToNDPOp(popped, isKernel))
                hostOp.setInputVars(in1, 1)
                hostOp.setInputVars(in2, 2)
                outputVar = "temp" + str(tempVarCounter)
                hostOp.setOutputVar(outputVar)
                result += [hostOp]
            output = output[:-2]
            output += ["temp"+ str(tempVarCounter)]
            tempVarCounter+=1 
        else:
            output += [popped]
        
    result[-1].setOutputVar(outputVal)
    return result
        
    
class MapsParser:
    def __init__ (self):
        self.maps = {}

    def addMapByStr(self, mapStr):
        mapName = mapStr.split(" = ")[0]
        mapping = mapStr.split(" = ")[1].split("affine_map")[1]
        mapping = mapping[1:][:-1]
        fromMap = mapping.split(" -> ")[0]
        toMap = mapping.split(" -> ")[1]
        
        if(fromMap == "()"):
            mapType = MapType.define
            symbol = ""

        elif(fromMap.find("[") == -1):
            mapType = MapType.noSymbol
            fromMap = fromMap[1:][:-1]
            symbol = ""

        else:
            mapType = MapType.withSymbol
            symbol = fromMap.split("[")[1].split("]")[0]
            fromMap = fromMap.split("[")[0][1:][:-1]


        newMap = Map(mapType)
        newMap.setMapFunc(toMap)
        newMap.setDimensions(fromMap)
        newMap.setSymbol(symbol)
        self.maps[mapName] = newMap
        

    def apply(self, ins):
        mapName = ins.inVars[1].split("(")[0]
        map = self.maps[mapName]
        if(map.type == MapType.define):
            # print(map.apply())
            return ["MOV " + ins.outputVal + ", " + map.apply()]
        elif(map.type == MapType.noSymbol):
            dims = ins.inVars[1].split("(")[1].split(")")[0]
            # print(map.apply(dims))
            return InfixToReg(map.apply(dims), ins.outputVal)
        elif(map.type == MapType.withSymbol):
            dims = ins.inVars[1].split("(")[1].split(")")[0]
            symbols = ins.inVars[1].split("(")[1].split(")")[1][1:][:-1]
            return (InfixToReg(map.apply(dims, symbols), ins.outputVal))
            # return map.apply(dims, symbols)

    def applyNDP(self, ins, isKernel, variableDic):
        mapName = ins.inVars[1].split("(")[0]
        map = self.maps[mapName]
        if(map.type == MapType.define):
            # if(isKernel):
            #     kernelOp = NDPOperation(NDPOps.MOV)
            #     kernelOp.setOutputVar(ins.outputVal)
            #     kernelOp.setInputVars(map.apply(),1)
            #     # return [kernelOp]
            # else:
            #     hostOp = HostOperation(HOSTOps.MOV)
            #     hostOp.setOutputVar(ins.outputVal)
            #     hostOp.setInputVars(map.apply(),1)
            #     return [hostOp]
            variableDic[ins.outputVal] = map.apply(variableDic)
            return [], variableDic

        elif(map.type == MapType.noSymbol):
            dims = ins.inVars[1].split("(")[1].split(")")[0]
            # print(InfixToRegNDP(map.apply(variableDic, dims), ins.outputVal, isKernel), variableDic)
            variableDic[ins.outputVal] = map.apply(variableDic, dims)

            return [], variableDic
        elif(map.type == MapType.withSymbol):
            dims = ins.inVars[1].split("(")[1].split(")")[0]
            symbols = ins.inVars[1].split("(")[1].split(")")[1][1:][:-1]
            # return InfixToRegNDP(map.apply(dims, symbols), ins.outputVal,isKernel), variableDic
            variableDic[ins.outputVal] = map.apply(variableDic, dims, symbols)
            return [], variableDic



        

