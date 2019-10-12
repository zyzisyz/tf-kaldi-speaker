#!/bin/bash
# Copyright 2018  Tsinghua University (Author: Zhiyuan Tang)
# Apache 2.0.

. ./cmd.sh
. ./path.sh

n=4 # parallel jobs
dvector_dim=400
exp=exp/dvector_tdnn_dim${dvector_dim}

set -eu

###### Bookmark: basic preparation ######

# corpus and trans directory
thchs=/work4/zhangyang/thchs30

# you can obtain the database by uncommting the following lines
# [ -d $thchs ] || mkdir -p $thchs
# echo "downloading THCHS30 at $thchs ..."
# local/download_and_untar.sh $thchs  http://www.openslr.org/resources/18 data_thchs30
# local/download_and_untar.sh $thchs  http://www.openslr.org/resources/18 resource
# local/download_and_untar.sh $thchs  http://www.openslr.org/resources/18 test-noise

# generate text, wav.scp, utt2pk, spk2utt in data/{train,test}
local/thchs-30_data_prep.sh $thchs/data_thchs30
# randomly select 1000 utts from data/test as enrollment in data/enroll
# using rest utts in data/test for test
utils/subset_data_dir.sh data/test 1000 data/enroll
utils/filter_scp.pl --exclude data/enroll/wav.scp data/test/wav.scp > data/test/wav.scp.rest
mv data/test/wav.scp.rest data/test/wav.scp
utils/fix_data_dir.sh data/test

# prepare trials in data/test
local/prepare_trials.py data/enroll data/test
trials=data/test/trials

###### Bookmark: feature and alignment generation ######

# produce Fbank in data/fbank/{train,enroll,test}
# MFCC with energy is needed for vad
rm -rf data/fbank && mkdir -p data/fbank && cp -r data/{train,enroll,test} data/fbank
rm -rf data/mfcc && mkdir -p data/mfcc && cp -r data/{train,enroll,test} data/mfcc
for x in train enroll test; do
  steps/make_fbank.sh --nj $n --cmd "$train_cmd" data/fbank/$x
  steps/make_mfcc.sh --nj $n --cmd "$train_cmd" data/mfcc/$x

