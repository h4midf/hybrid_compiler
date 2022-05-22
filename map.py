from operation import *
import enum 

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

    def apply(self, dimStr=None, symStr=None):
        if(self.type == MapType.define):
            return str(eval(self.mapFunc))
        elif(self.type == MapType.noSymbol):
            dims = dimStr.split(", ")
            i = 0
            tempMapFunc = self.mapFunc
            for dim in dims:
                tempMapFunc = tempMapFunc.replace(self.dims[i], dim)
                i += 1
            return tempMapFunc[1:][:-1]
        else:
            dims = dimStr.split(", ")
            i = 0
            tempMapFunc = self.mapFunc
            for dim in dims:
                tempMapFunc = tempMapFunc.replace(self.dims[i], dim)
                i += 1

            tempMapFunc = tempMapFunc.replace(self.symbol, symStr)
            return tempMapFunc[1:][:-1]

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


        

