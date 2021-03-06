
#for part in ensemble_train ensemble_validate test; do 
for part in train_samples; do 
    CUDA_VISIBLE_DEVICES=0 python inference-pre-ensemble.py \
        --output_dir="/Youtube-8M/model_predictions/${part}/lstmmemory_cell2048_layer2_moe4" \
        --model_checkpoint_path="../model/lstmmemory2048_moe4_batch128/model.ckpt-109434" \
        --input_data_pattern="/Youtube-8M/data/frame/${part}/*.tfrecord" \
        --frame_features=True \
        --feature_names="rgb,audio" \
        --feature_sizes="1024,128" \
        --batch_size=32 \
        --file_size=4096
done
