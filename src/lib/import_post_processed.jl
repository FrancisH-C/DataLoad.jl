function log_files(relative_path::String)
    directory =  "$DATA_OUTPUT/$relative_path"
    itr = walkdir(directory) 
    (root, dirs, files) = first(itr)
    (root, dirs, files) = first(itr)
    return joinpath.(root, files) # path to files
end

function output_data_files(relative_path::String)
    directory =  "$DATA_OUTPUT/$relative_path"
    (root, dirs, files) = first(walkdir(directory))
    return joinpath.(root, files) # path to files
end

function statistics_files(relative_path::String)
    directory =  "$DATA_OUTPUT/$relative_path"
    (root, dirs, files) = first(walkdir(directory))
    return joinpath.(root, files) # path to files
end
