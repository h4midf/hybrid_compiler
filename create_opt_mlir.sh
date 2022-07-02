

export MLIR_OPT=~/Programming/current_ws/build/llvm-project/llvm/bin/mlir-opt
# export AFFINE_CMD="--affine-parallelize=max-nested=1 --affine-simplify-structures --affine-loop-coalescing"
export AFFINE_CMD="--affine-parallelize --affine-simplify-structures --affine-loop-coalescing"

export CGEIST=/Users/h4mid/Programming/Polygeist/polygeist2/Polygeist/build/bin/cgeist


# benchs=( 2mm 3mm atax correlation floyd-warshall gemm gemver jacobi-2d lu conv2d)
benchs=( bs gemm gemver histogram mlp needleman_wunsch reduce scan_rss scan_ssa select spmv)
for bench in "${benchs[@]}"
do
	rm ./selected/$bench/"$bench".mlir
	$CGEIST -function=$bench -S ./selected/$bench/"$bench".c >> ./selected/$bench/"$bench".mlir

	rm ./selected/$bench/"$bench"-opt.mlir
	$MLIR_OPT $AFFINE_CMD ./selected/$bench/"$bench".mlir >> ./selected/$bench/"$bench"-opt.mlir
done





