using mlpack
using CSV
using DataFrames
using PrettyPrinting
using Random

Random.seed!(1234)

"""
Utility function to load the data
Args
  path (String): path to data
  
Returns
  X (Array): features
  y (Array): labels
"""
function load_data(path)
    df = DataFrame(CSV.File(path; select = ["Age", "Sex", "DaysDrink", "Overdrawn"]))

    @show size(df)
    first(df, 5) |> pprint

    # Change 1 (did overdraw) to 2 and 0 (did not overdraw) to 1 because
    # mlpack.preprocess_split() does not take 0 as a label
    df[:, [:Overdrawn]] .= ifelse.(df[!, [:Overdrawn]] .== 1, 2, 1)

    # Convert Sex column to categorical type
    categorical!(df, :Sex)

    # Check for imbalance
    by(df, :Overdrawn, nrow) |> pprint

    # Convert into array for mlpack to ingest
    X = Array(df[!, [:Age, :Sex, :DaysDrink]])
    y = Array(df[!, :Overdrawn])
  
    return X, y
end

"""
Split the data into training and testing
Args:
  X (Array): features
  y (Array): labels
  test_ratio (Float): how much to split the data into
                      Default is 0.2
                      
Returns
  X_test  (Array): test features
  y_test  (Array): test labels
  X_train (Array): training features
  y_train (Array): training labels
"""
function split_data(X, y, test_ratio = 0.2)
    X_test, y_test, X_train, y_train = mlpack.preprocess_split(X, input_labels = y, test_ratio = test_ratio)
    return X_test, y_test, X_train, y_train
end

"""
Train the model
Args:
  X_train (Array): training features
  y_train (Array): training labels
  
Returns
  model (AdaBoostModel)
"""
function train(X_train, y_train)
    
    @time _, model, _, _ = mlpack.adaboost(labels = y_train,
                                           training = X_train,
                                           weak_learner = "decision_stump")
    return model
end

"""
Evaluate performance of the model
Args:
  model  (AdaBoostModel)
  X_test (Array): test features
  y_test (Array): test labels
  
Displays test accuracy
"""
function evaluate(model, X_test, y_test)
    _, _, predictions, _ = mlpack.adaboost(input_model = model, test = X_test)

    correct = sum(predictions .== y_test)
    println("$(correct) out of $(length(y_test)) test points correct ($(correct / length(y_test) * 100.0)%).")
end

function main()
    X, y = load_data(path = "data/CreditRisk.csv")
    X_test, y_test, X_train, y_train = split_data(X, y, test_ratio = 0.2)
  
    model = train(X_train, y_train)
    evaluate(model, X_test, y_test)
end

main()
