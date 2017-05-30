model=$1
conf=$2
part=$3
checkpoint=$4

DEFAULT_GPU_ID=0
if [ -z ${CUDA_VISIBLE_DEVICES+x} ]; then
  GPU_ID=$DEFAULT_GPU_ID
  echo "set CUDA_VISIBLE_DEVICES to default('$GPU_ID')"
else
  GPU_ID=$CUDA_VISIBLE_DEVICES
  echo "set CUDA_VISIBLE_DEVICES to external('$GPU_ID')"
fi

test_path=/Youtube-8M/model_predictions/${part}
test_data_patterns=""
for d in $(cat $conf); do
  test_data_patterns="${test_path}/${d}/*.tfrecord${test_data_patterns:+,$test_data_patterns}"
done
echo "$test_data_patterns"
input_data_pattern="${test_path}/model_input/*.tfrecord"

CUDA_VISIBLE_DEVICES="$GPU_ID" python inference-pre-ensemble.py \
	    --output_dir="/Youtube-8M/model_predictions/${part}/${model}" \
      --model_checkpoint_path="../model/${model}/model.ckpt-${checkpoint}" \
      --input_data_patterns="$test_data_patterns" \
      --input_data_pattern="$input_data_pattern" \
      --model="AttentionMatrixModel" \
      --moe_num_mixtures=4 \
      --attention_matrix_rank=6 \
      --batch_size=1024 \
      --file_size=4096
