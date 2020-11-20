$dataset = $args[0]
$ratio = $args[1]
$batch_size = $args[2]
$dim = $args[3]
$seed = $args[4]

# data path

$train_path = "data/" + $dataset + "_ratio/" + $ratio + "/train.tsv"
$valid_path = "data/" + $dataset + "/dev.tsv"
$test_path = "data/" + $dataset + "/test.tsv"
$word2count_mr = "data/" + $dataset + "/word2count_mr.json"
$word2count_nl = "data/" + $dataset + "/word2count_nl.json"

# some dataset-dependent hyper-parameters as default

if($dataset -eq "e2e"){
    $vocab = 1200
    $auto_weight = 0
    $dropout_attn_prob = 0.9
    $compute_z = "mean"
    $peep = "True"
}
elseif($dataset -eq "weather"){
    $vocab = 500
    $auto_weight = 1
    $dropout_attn_prob = 0
    $compute_z = "last"
    $peep = "False"
}

####### pretrain the model using supervised learning first #######
$mode = "pretrain"
$model_name = $dataset + "_ratio" + $ratio + "_seed" + $seed
$model_dir = "checkpoint/" + $mode + "/" + $model_name
$result = "res/result/" + $mode + "/" + $model_name + ".json"
$log = "res/log/" + $mode + "/" + $model_name + ".log"

echo python main.py --dataset=$dataset --mode=$mode --batch_size=$batch_size --seed=$seed `
				--train_path=$train_path --valid_path=$valid_path --test_path=$test_path `
				--word2count_query=$word2count_nl --word2count_parse=$word2count_mr --vocab_size=$vocab `
				--embed_size=$dim --hidden_size=$dim --latent_size=$dim `
				--epoch=100 --no_improve_epoch=10 --model_dir=$model_dir --result_path=$result `
				--auto_weight=$auto_weight --compute_z=$compute_z --peep=$peep --dropout_attn_prob=$dropout_attn_prob > $log