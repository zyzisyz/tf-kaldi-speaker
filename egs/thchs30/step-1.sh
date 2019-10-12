

. ./cmd.sh
. ./path.sh
set -e

root=/home/heliang05/liuyi/voxceleb
data=$root/data
exp=$root/exp
mfccdir=$root/mfcc
vaddir=$root/mfcc

stage=$1


# The kaldi voxceleb egs directory
kaldi_voxceleb=/home/heliang05/liuyi/software/kaldi_gpu/egs/voxceleb
voxceleb1_trials=$data/voxceleb_test/trials
voxceleb1_root=/home/heliang05/liuyi/data/voxceleb/voxceleb1
voxceleb2_root=/home/heliang05/liuyi/data/voxceleb/voxceleb2
musan_root=/home/heliang05/liuyi/data/musan
rirs_root=/home/heliang05/liuyi/data/RIRS_NOISES

