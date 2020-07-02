module DataLoad

using ParquetIO, DataFrames, CSV, ProgressMeter, Logging

export list_data, 
       import_data, 
       # import csv
       import_csv,
       export_csv,
       # DataIO
       data_exporter,
       create_logs,
       log_files,
       output_data_files,
       export_statistics,
       statistics_files,
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
include("lib/log_data.jl")
include("lib/import_post_processed.jl")

end # module
