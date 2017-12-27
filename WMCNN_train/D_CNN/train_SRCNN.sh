#!/usr/bin/env sh
LOGDIR=./log
TOOLS=/opt/software/caffe/build/tools
#$TOOLS/caffe train --solver=./SRCNN_solver.prototxt -snapshot ./models/D_0.05_iter_22365.solverstate 2>&1 | tee $LOGDIR/D_0.05.txt
$TOOLS/caffe train --solver=./SRCNN_solver.prototxt 2>&1 | tee $LOGDIR/D.txt

