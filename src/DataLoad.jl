module DataLoad

using ParquetIO, DataFrames, CSV, ProgressMeter

export list_data, 
       import_data, 
       # import csv
       import_csv,
       export_csv,
       # DataIO
       data_exporter,
       # import csv
       # Stock_list structure
       Stock_list, 
       get_stock,
       get_day,
       iterate,
       # Sets
       training_set,
       validation_set,
       sp60_set,
       custom_set


# variable to be defined
const DATA_ROOT=ENV["DATA_ROOT"]
const DATA_OUTPUT=ENV["DATA_OUTPUT"]

include("lib/csvIO.jl")
include("lib/import_data.jl")
include("lib/export_data.jl")

end # module
