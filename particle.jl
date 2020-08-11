using CSV
using DataFrames
using Random
using MLDataUtils: shuffleobs, stratifiedobs
using ScikitLearn
using PyCall
@sk_import neural_network: MLPClassifier
@sk_import metrics: (accuracy_score, precision_score, recall_score, f1_score, matthews_corrcoef, log_loss)

Random.seed!(1234)

function split_data(df, target; at = 0.8)
    shuffled = shuffleobs(df)
    trainset, testset = stratifiedobs(row -> row[target], shuffled, p = at)
    return trainset, testset
end

function load_data(path::String)
    df = DataFrame!(CSV.File(path))
    
    target = :id
    trainset, testset = split_data(df, target, at = 0.80)

    features = [:p, :theta, :beta, :nphe, :ein, :eout]

    X_train = Array(trainset[:, features])
    X_test = Array(testset[:, features])
    y_train = trainset[:, target]
    y_test = testset[:, target]
    
    return X_train, X_test, y_train, y_test
end

function train(X_train, y_train)
    println("Training...")
    println("===========")
    
    model = fit!(MLPClassifier(hidden_layer_sizes = (512, 512, 512),
                               activation = "relu",
                               solver = "adam",
                               batch_size = 1024,
                               learning_rate = "adaptive",
                               learning_rate_init = 0.001,
                               random_state = 420,
                               early_stopping = true),
                 X_train, y_train)
    
    return model
end

function evaluate(model, X_test, y_test)
    ŷ = predict(model, X_test)
    
    println("Accuracy: ", round(accuracy_score(ŷ, y_test), digits = 4))
    println("Precision: ", round(precision_score(ŷ, y_test), digits = 4))
    println("Recall: ", round(recall_score(ŷ, y_test), digits = 4))
    println("Log loss: ", round(log_loss(ŷ, y_test), digits = 4))
    println("Matthews Correlation Coefficient: ", round(matthews_corrcoef(ŷ, y_test), digits = 4))
end

X_train, X_test, y_train, y_test = load_data("data/pid-5m.csv")

@time model = train(X_train, y_train)

evaluate(model, X_test, y_test)
