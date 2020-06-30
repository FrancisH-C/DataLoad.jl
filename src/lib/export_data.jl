DATA_OUTPUT=ENV["DATA_OUTPUT"]

function data_exporter(relative_path::String, to_df::Function=identity)
    directory = "$DATA_OUTPUT/$relative_path/"
    run(`mkdir -p $directory`)
    f = function export_data(stock::String, day::Int64, anything::Any)
        export_pqt("$directory$day$(stock).pqt", to_df(anything))
    end
    return f
end

