from re import I
from code_structure import *
from operation import * 
from NDPOps import *

class NDPSystem:
    serial_loop_counter = 0
    ndp_temp_reg_counter = 0
    host_temp_reg_counter = 0

    def __init__ (self):
        self.hostKernels = []
        self.ndpKernels = []
    
    def addHostKernel(self, kernel):
        self.hostKernels += [kernel]

    def addNDPKernel(self, kernel):
        self.ndpKernels += [kernel]
    
    def parseIns(self, ins, mapsParser, isKernel):
        if(isinstance(ins,Loop)):
            if(ins.type == LoopType.forLoop):
                res = []
                if(isKernel):
                    op = NDPOperation(NDPOps.MOV)
                    labelOp = NDPOperation(NDPOps.LABEL)
                    cmpOp = NDPOperation(NDPOps.CMP)
                    print(self.ndp_temp_reg_counter)
                    cmpOp.setOutputVar("temp" +str(self.ndp_temp_reg_counter))
                    jtOp = NDPOperation(NDPOps.JT)
                    jtOp.setInputVars("temp"+str(self.ndp_temp_reg_counter), 1)
                    self.ndp_temp_reg_counter += 1

                    endLabelOp = NDPOperation(NDPOps.LABEL)
                    
                else:
                    op = HostOperation(HOSTOps.MOV)
                    labelOp = HostOperation(HOSTOps.LABEL)
                    cmpOp = HostOperation(HOSTOps.CMP)
                    cmpOp.setOutputVar(self.host_temp_reg_counter)
                    jtOp = HostOperation(HOSTOps.JT)
                    jtOp.setInputVars("temp"+str(self.host_temp_reg_counter), 1)
                    self.host_temp_reg_counter += 1
                    

                    endLabelOp = HostOperation(HOSTOps.LABEL)

                op.setOutputVar(ins.start.name)
                op.setInputVars(ins.start.val, 1)
                labelOp.setInputVars(self.serial_loop_counter, 1)
                self.serial_loop_counter += 1
                endLabelOp.setInputVars(self.serial_loop_counter, 1)
                cmpOp.setInputVars(ins.start.name, 1)
                cmpOp.setInputVars(ins.end.name, 2)
                jtOp.setOutputVar(self.serial_loop_counter)
                self.serial_loop_counter += 1
                res += [op, labelOp, cmpOp, jtOp]

                
                for l_ins in ins.getIns():

                    res+= self.parseIns(l_ins, mapsParser, isKernel)

                if(isKernel):
                    addOp = NDPOperation(NDPOps.ADD)
                    jOp = NDPOperation(NDPOps.J)
                else:
                    addOp = HostOperation(HOSTOps.ADD)
                    jOp = HostOperation(HOSTOps.J)

                addOp.setInputVars(ins.start.name, 1) 
                addOp.setInputVars(1, 2) 
                addOp.setOutputVar(ins.start.name)
                jOp.setInputVars(self.serial_loop_counter-2, 1)
                res += [addOp, jOp, endLabelOp]
                return res
            else:
                print("parallel Loop! shouldn't come here")

        elif(ins.operation == SupportedOperation.affine_apply):
            return mapsParser.applyNDP(ins, isKernel)
        elif(ins.operation == SupportedOperation.arith_index_cast):
            # print("not handled")
            return [] # TODO: We must add the support of casting at some point!
        elif(ins.operation == SupportedOperation.arith_constant):
            if(isKernel):
                movOp = NDPOperation(NDPOps.MOV)
            else:
                movOp = HostOperation(HOSTOps.MOV)
            movOp.setOutputVar(ins.outputVal)
            movOp.setInputVars(ins.insVars[1], 1)
            return [movOp]
        elif(ins.operation == SupportedOperation.arith_addf):
            if(isKernel):
                addfOp = NDPOperation(NDPOps.ADDF)
            else:
                addfOp = HostOperation(HOSTOps.ADDF)
            addfOp.setOutputVar(ins.outputVal)
            addfOp.setInputVars(ins.inVars[1], 1)
            addfOp.setInputVars(ins.inVars[2], 2)
            return [addfOp]

        elif(ins.operation == SupportedOperation.arith_mulf):
            if(isKernel):
                mulfOp = NDPOperation(NDPOps.MULF)
            else:
                mulfOp = HostOperation(HOSTOps.MULF)
            mulfOp.setOutputVar(ins.outputVal)
            mulfOp.setInputVars(ins.inVars[1], 1)
            mulfOp.setInputVars(ins.inVars[2], 2)
            return [mulfOp]

        elif(ins.operation == SupportedOperation.affine_load):
            if(isKernel):
                loadOp = NDPOperation(NDPOps.LOAD)
            else:
                loadOp = HostOperation(HOSTOps.LOAD)
            
            baseAddress = ins.inVars[1].split("[")[0]
            indexes = ins.inVars[1].split("[")[1][:-1].split(", ")
            # print(baseAddress,indexes)
            loadOp.setInputVars(baseAddress, 1)
            loadOp.setInputVars(indexes, 2)
            loadOp.setOutputVar(ins.outputVal)
            return [loadOp]

        elif(ins.operation == SupportedOperation.affine_store):
            if(isKernel):
                storeOp = NDPOperation(NDPOps.STORE)
            else:
                storeOp = HostOperation(HOSTOps.STORE)
            
            baseAddress = ins.inVars[2].split("[")[0]
            indexes = ins.inVars[2].split("[")[1][:-1].split(", ")
            # print(baseAddress,indexes)
            storeOp.setInputVars(baseAddress, 1)
            storeOp.setInputVars(indexes, 2)
            storeOp.setOutputVar(ins.inVars[1])
            return [storeOp]
        elif(ins.operation == SupportedOperation.memref_alloc):
            print("not implemented !")
        elif(ins.operation == SupportedOperation.memref_copy):
            print("not implemented !")
        else:
            print("not implemetned " + ins.operation)

        return []

        

    def parallelLoopKernel(self, block, mapsParser):
        parsedInstructions = []
        for ins in block.ins:
            parsedInstructions += self.parseIns(ins, mapsParser, True)
        self.printNDPIns(parsedInstructions)

        # print(len(block.ins))
        # for ins in block.ins:
            

    def splitHelperHost(self, block, mapsParser):
        result_func = []
        instruction_sequence = ""
        for ins in block.getIns():
            if(isinstance(ins,Loop)):
                if(ins.type == LoopType.parallel):
                    # instruction_sequence += (nest_level*"\t"+"PARALLEL:\n"+compileHelper(ins, nest_level+1, mapsParser))
                    self.parallelLoopKernel(ins, mapsParser)

                else:
                    seq = ("\t" + "MOV " + ins.start.name + ", " + ins.start.val + "\n")
                    seq += ("\t" +  "LOOP" + ":\n")
                    seq += ("\t" + "CMP " + ins.start.name + ", " + ins.end.name + "\n")
                    seq += ("\t" + "JT " + "END_LOOP" + "\n")


                    # instruction_sequence += (seq + (nest_level-2)*"\t" +(ins, nest_level+1, mapsParser))
                    # parallelLoopKernel(ins, mapsParser)

                    seq2 = "\t" + "ADD " + ins.start.name + ", 1\n" 
                    seq2 += "\t" + "J LOOP" + "\n"
                    seq2 += "\t" + "END_LOOP" + ":\n"
                    instruction_sequence += seq2


            elif (isinstance(ins, Operation)):
                if(ins.operation == SupportedOperation.affine_apply):
                    seq = ""
                    for newIns in mapsParser.apply(ins):

                        seq += ("\t" + newIns + "\n")
                    instruction_sequence += (seq)

                elif(ins.operation == SupportedOperation.arith_constant):
                    seq = "MOV " + ins.outputVal + ", " + ins.inVars[1]  + "\n"
                    instruction_sequence += ("\t" + seq)

                elif(ins.operation == SupportedOperation.arith_addf):
                    seq = "ADDF " + ins.outputVal + ", " + ins.inVars[1]  + ", " + ins.inVars[2] + "\n"
                    instruction_sequence += ("\t" + seq)

                elif(ins.operation == SupportedOperation.arith_mulf):
                    seq = "MULF " + ins.outputVal + ", " + ins.inVars[1]  + ", " + ins.inVars[2] + "\n"
                    instruction_sequence += ("\t" + seq)

                else:
                    instruction_sequence += ("\t" + getOperationStr(ins.operation) + "\n")
            else:
                instruction_sequence += "Unknown\n"
        return instruction_sequence

    def splitToHostNDP(self, workload):
        instruction_sequence = ""
        for module in workload.getModules():
            for func in module.getFuncs():
                instruction_sequence+= (self.splitHelperHost(func, workload.mapsParser))
        # print(instruction_sequence)
    
    def printNDPIns(self, insArray):
        print("___Kernel___")
        for ins in insArray:
            if(isinstance(ins, NDPOperation)):
                if(ins.getOperationType() == NDPOps.LABEL):
                    print("LABEL" + str(ins.inVars[1]) + ":")
                elif(ins.getOperationType() == NDPOps.LOAD):
                    print("LOAD " + ins.getOutVar() + ", " + str(ins.inVars[1]) + str(ins.inVars[2]))
                elif(ins.getOperationType() == NDPOps.STORE):
                    print("STORE " + str(ins.getOutVar()) + ", " + str(ins.inVars[1]) + str(ins.inVars[2]))
                elif(ins.getOperationType() == NDPOps.MOV):
                    print("MOV " + ins.getOutVar() + ", " + ins.inVars[1])
                elif(ins.getOperationType() == NDPOps.ADD):
                    print("ADD " + str(ins.getOutVar()) + ", " + str(ins.inVars[1]) + ", " + str(ins.inVars[2]))
                elif(ins.getOperationType() == NDPOps.SUB):
                    print("SUB " + ins.getOutVar() + ", " + ins.inVars[1] + ", " + ins.inVars[2])
                elif(ins.getOperationType() == NDPOps.MUL):
                    print("MUL " + ins.getOutVar() + ", " + ins.inVars[1] + ", " + ins.inVars[2])
                elif(ins.getOperationType() == NDPOps.DIV):
                    print("DIV " + ins.getOutVar() + ", " + ins.inVars[1] + ", " + ins.inVars[2])
                elif(ins.getOperationType() == NDPOps.MOD):
                    print("MOD " + ins.getOutVar() + ", " + ins.inVars[1] + ", " + ins.inVars[2])
                elif(ins.getOperationType() == NDPOps.FLOORDIV):
                    print("FLOORDIV " + ins.getOutVar() + ", " + ins.inVars[1] + ", " + ins.inVars[2])
                elif(ins.getOperationType() == NDPOps.ADDF):
                    print("ADDF " + ins.getOutVar() + ", " + ins.inVars[1] + ", " + ins.inVars[2])
                elif(ins.getOperationType() == NDPOps.SUBF):
                    print("SUBF " + ins.getOutVar() + ", " + ins.inVars[1] + ", " + ins.inVars[2])
                elif(ins.getOperationType() == NDPOps.MULF):
                    print("MULF " + ins.getOutVar() + ", " + ins.inVars[1] + ", " + ins.inVars[2])
                elif(ins.getOperationType() == NDPOps.DIVF):
                    print("DIVF " + ins.getOutVar() + ", " + ins.inVars[1] + ", " + ins.inVars[2])
                elif(ins.getOperationType() == NDPOps.CMP):
                    print("CMP " + str(ins.getOutVar()) + ", " + str(ins.inVars[1]) + ", " + str(ins.inVars[2]))
                elif(ins.getOperationType() == NDPOps.JT):
                    print("JT " + str(ins.getInvar(1)) + ", LABEL" + str(ins.getOutVar()))
                elif(ins.getOperationType() == NDPOps.J):
                    print("J LABEL" + str(ins.getInvar(1)))
                else:
                    print("!!" + str(ins.getOperationType()))
            else:
                print("Not printing HOST yet")
        # print(insArray)
        print("___END___")
    
