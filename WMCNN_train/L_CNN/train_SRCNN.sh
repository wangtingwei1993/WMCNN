#!/usr/bin/env sh
LOGDIR=./log
TOOLS=/opt/software/caffe/build/tools
#$TOOLS/caffe train --solver=./SRCNN_solver.prototxt -snapshot ./models/L_0.05_iter_44310.solverstate 2>&1 | tee $LOGDIR/L_0.05.txt
$TOOLS/caffe train --solver=./SRCNN_solver.prototxt 2>&1 |tee $LOGDIR/L.txt
