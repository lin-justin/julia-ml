using CSV
using DataFrames
using Gadfly
import Cairo, Fontconfig

df = DataFrame!(CSV.File("data/HTRU_2.csv";
                header = ["Integrated_Mean", "Integrated_Std",
                          "Integrated_Kurtosis", "Integrated_Skewness",
                          "DMSNR_Mean", "DMSNR_Std", "DMSNR_Kurtosis",
                          "DMSNR_Skewness", "Label"]))

# Plot histograms
h1 = plot(df, x =:Integrated_Mean, Geom.histogram)
h2 = plot(df, x =:Integrated_Std, Geom.histogram)
h3 = plot(df, x =:Integrated_Kurtosis, Geom.histogram)
h4 = plot(df, x =:Integrated_Skewness, Geom.histogram)
h5 = plot(df, x =:DMSNR_Mean, Geom.histogram)
h6 = plot(df, x =:DMSNR_Std, Geom.histogram)
h7 = plot(df, x =:DMSNR_Kurtosis, Geom.histogram)
h8 = plot(df, x =:DMSNR_Skewness, Geom.histogram)
h9 = plot(df, x =:Label, Geom.histogram)

# Save as PNG
h1 |> PNG("plots/histograms/integrated_mean_histogram.png")
h2 |> PNG("plots/histograms/integrated_std_histogram.png")
h3 |> PNG("plots/histograms/integrated_kurtosis_histogram.png")
h4 |> PNG("plots/histograms/ntegrated_skewness_histogram.png")
h5 |> PNG("plots/histograms/dmsnr_mean_histogram.png")
h6 |> PNG("plots/histograms/dmsnr_std_histogram.png")
h7 |> PNG("plots/histograms/dmsnr_kurtosis_histogram.png")
h8 |> PNG("plots/histograms/dmsnr_skewness_histogram.png")
h9 |> PNG("plots/histograms/label_histogram.png")

# Plot density plots
d1 = plot(df, x =:Integrated_Mean, Geom.density, Guide.xrug)
d2 = plot(df, x =:Integrated_Std, Geom.density, Guide.xrug)
d3 = plot(df, x =:Integrated_Kurtosis, Geom.density, Guide.xrug)
d4 = plot(df, x =:Integrated_Skewness, Geom.density, Guide.xrug)
d5 = plot(df, x =:DMSNR_Mean, Geom.density, Guide.xrug)
d6 = plot(df, x =:DMSNR_Std, Geom.density, Guide.xrug)
d7 = plot(df, x =:DMSNR_Kurtosis, Geom.density, Guide.xrug)
d8 = plot(df, x =:DMSNR_Skewness, Geom.density, Guide.xrug)
d9 = plot(df, x =:Label, Geom.density, Guide.xrug)

# Save as PNG
d1 |> PNG("plots/density/integrated_mean_density.png")
d2 |> PNG("plots/density/integrated_std_density.png")
d3 |> PNG("plots/density/integrated_kurtosis_density.png")
d4 |> PNG("plots/density/ntegrated_skewness_density.png")
d5 |> PNG("plots/density/dmsnr_mean_density.png")
d6 |> PNG("plots/density/dmsnr_std_density.png")
d7 |> PNG("plots/density/dmsnr_kurtosis_density.png")
d8 |> PNG("plots/density/dmsnr_skewness_density.png")
d9 |> PNG("plots/density/label_density.png")
