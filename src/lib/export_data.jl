function data_exporter(relative_path::String, to_df::Function=identity)
    directory = "$DATA_OUTPUT/$relative_path/"
    run(`mkdir -p $directory`)
    f = function export_data(stock::String, day::Int64, anything::Any)
        df = to_df(anything)
        if size(df, 1) != 0
            export_pqt("$directory$day$(stock).pqt", df)
        end
    end
    return f
end

