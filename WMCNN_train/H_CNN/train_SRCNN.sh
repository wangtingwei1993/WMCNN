#!/usr/bin/env sh
LOGDIR=./log
TOOLS=/opt/software/caffe/build/tools
#$TOOLS/caffe train --solver=./SRCNN_solver.prototxt -snapshot ./models/H_0.05_iter_24360.solverstate 2>&1 | tee $LOGDIR/H_0.05.txt
$TOOLS/caffe train --solver=./SRCNN_solver.prototxt 2>&1 | tee $LOGDIR/H.txt
