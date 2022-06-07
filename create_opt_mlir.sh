export MLIR_OPT=~/Programming/current_ws/build/llvm-project/llvm/bin/mlir-opt
export AFFINE_CMD="--affine-parallelize=max-nested=1 --affine-simplify-structures --affine-loop-coalescing"

#  ~/Programming/outputs/polybench_affine/linear-algebra/kernels/3mm/3mm.mlir >> ~/Programming/outputs/hybrid_compiler/git/hybrid_compiler/selected/3


benchs=( 2mm 3mm atax correlation floyd-warshall gemm gemver jacobi-2d lu conv2d)
for bench in "${benchs[@]}"
do
	rm ./selected/$bench/"$bench"-opt.mlir
	#"$MLIR_OPT" "$AFFINE_CMD" ./selected/$bench/"$bench".mlir
	$MLIR_OPT $AFFINE_CMD ./selected/$bench/"$bench".mlir >> ./selected/$bench/"$bench"-opt.mlir
done





