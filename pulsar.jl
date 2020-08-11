using CSV
using DataFrames
using mlpack
using ArgParse
using Random

Random.seed!(1234)

"""
Command line arguments
"""
function parse_commandline()
    s = ArgParseSettings()

    @add_arg_table! s begin
        "--data_path"
            help = "path to the data file"
            arg_type = String
            default = "data/HTRU_2.csv"
        "--test_size"
            help = "split the data into training and testing"
            arg_type = Float64
            default = 0.2
        "--min_leaf_size"
            help = "random forest hyperparameter"
            arg_type = Int64
            default = 20
        "--num_trees"
            help = "random forest hyperparameter"
            arg_type = Int64
            default = 10
    end
    return parse_args(s)
end

"""
Main function to perform random forest classification
"""
function main()
    args = parse_commandline()

    df = DataFrame!(CSV.File(args["data_path"], header = false))

    data = convert(Matrix, df[!, 1:8])

    labels = convert(Matrix, df[!, [:9]])

    test, test_labels, train, train_labels = mlpack.preprocess_split(data,
        input_labels = labels,
        test_ratio = args["test_size"])

    train_scaled, train_scaled_model = mlpack.preprocess_scale(train;
        scaler_method = "standard_scaler")

    test_scaled, _ = mlpack.preprocess_scale(test;
        input_model = train_scaled_model)

    @time rf_model, _, _ = mlpack.random_forest(labels = train_labels,
        minimum_leaf_size = args["min_leaf_size"], num_trees = args["num_trees"],
        print_training_accuracy = true, training = train_scaled, verbose = true)

    _, predictions, _ = mlpack.random_forest(input_model = rf_model,
        test = test_scaled)

    correct = sum(predictions .== test_labels)
    println("$(correct) out of $(length(test_labels)) test points correct " *
        "($(correct / length(test_labels) * 100.0)%).\n")
end

main()
