function create_logs(relative_path::String)
    log_directory = "$DATA_OUTPUT/$relative_path/logs"
    run(`mkdir -p $log_directory`)
    f = function open_log(stock, day)
        log_file = "$log_directory/$stock$(day)"
        io_log = open(log_file, "w+")
        replayed_logger = SimpleLogger(io_log)
        global_logger(replayed_logger)
        @info "Current file :  $stock$day"
        return io_log
    end
end

function export_statistics(relative_file_name::String, df::DataFrame)
    filename = "$DATA_OUTPUT/$relative_file_name"
    println(filename)
    run(`mkdir -p $(dirname $filename)`)
    export_pqt(filename, df)
end
