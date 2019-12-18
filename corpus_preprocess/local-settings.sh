#!/bin/sh

# set visible GPU
export CUDA_VISIBLE_DEVICES=`free-gpu`

# path to moses decoder: https://github.com/moses-smt/mosesdecoder
export mosesdecoder=/home/pkoehn/moses


