from code_structure import *
from operation import * 

class NDPSystem:
    def splitHelper(self, block, nest_level, mapsParser):
        global serial_loop_counter
        instruction_sequence = ""
        for ins in block.getIns():
            if(isinstance(ins,Loop)):
                if(ins.type == LoopType.parallel):
                    instruction_sequence += (nest_level*"\t"+"PARALLEL:\n"+compileHelper(ins, nest_level+1, mapsParser))
                else:
                    seq = (nest_level*"\t" + "MOV " + ins.start.name + ", " + ins.start.val + "\n")
                    seq += (nest_level*"\t" +  "LOOP" + str(serial_loop_counter) + ":\n")
                    seq += ((nest_level+1)*"\t" + "CMP " + ins.start.name + ", " + ins.end.name + "\n")
                    seq += ((nest_level+1)*"\t" + "JT " + "END_LOOP" + str(serial_loop_counter) +"\n")
                    serial_loop_counter += 1


                    instruction_sequence += (seq + (nest_level-2)*"\t" +compileHelper(ins, nest_level+1, mapsParser))

                    seq2 = (nest_level+1)* "\t" + "ADD " + ins.start.name + ", 1\n" 
                    seq2 += (nest_level+1)* "\t" + "J LOOP" + str(serial_loop_counter -1) + "\n"
                    seq2 += (nest_level) * "\t" + "END_LOOP" + str(serial_loop_counter -1) +":\n"
                    instruction_sequence += seq2


            elif (isinstance(ins, Operation)):
                if(ins.operation == SupportedOperation.affine_apply):
                    seq = ""
                    for newIns in mapsParser.apply(ins):

                        seq += (nest_level*"\t" + newIns + "\n")
                    instruction_sequence += (seq)

                elif(ins.operation == SupportedOperation.arith_constant):
                    seq = "MOV " + ins.outputVal + ", " + ins.inVars[1]  + "\n"
                    instruction_sequence += (nest_level*"\t" + seq)

                elif(ins.operation == SupportedOperation.arith_addf):
                    seq = "ADDF " + ins.outputVal + ", " + ins.inVars[1]  + ", " + ins.inVars[2] + "\n"
                    instruction_sequence += (nest_level*"\t" + seq)

                elif(ins.operation == SupportedOperation.arith_mulf):
                    seq = "MULF " + ins.outputVal + ", " + ins.inVars[1]  + ", " + ins.inVars[2] + "\n"
                    instruction_sequence += (nest_level*"\t" + seq)

                else:
                    instruction_sequence += (nest_level*"\t" + getOperationStr(ins.operation) + "\n")
            else:
                instruction_sequence += "Unknown\n"
        return instruction_sequence

    def splitToHostNDP(self, workload):
        instruction_sequence = ""
        for module in workload.getModules():
            for func in module.getFuncs():
                instruction_sequence+= (self.splitHelper(self, func, 0, workload.mapsParser))
        print(instruction_sequence)
    
