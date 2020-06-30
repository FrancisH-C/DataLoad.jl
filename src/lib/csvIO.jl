"""
int128 ↦ string
"""
function int128_to_string(df::DataFrame)
	columns_name=names(df)
	for i in 1:length(columns_name)
		if (typeof(df[1, columns_name[i]]) <: Int128)
			try # try int128 ↦ string
				df[!, columns_name[i]] = string.(df[!, columns_name[i]]) 
			catch
			end
		end
        end
    return df
end


"""
string ↦ int128
"""
function string_to_int128(df::DataFrame)
    columns_name=names(df)
    for i in 1:length(columns_name)
        if (typeof(df[1, columns_name[i]]) <: String)
            try # try int128 ↦ string
		df[!, columns_name[i]] = parse.(Int128, df[!, columns_name[i]]) 
	    catch
	    end
	end
    end
    return df
end


function import_csv(path::String)
    return string_to_int128(DataFrame!(CSV.file(path, types=Dict(5 => String))))
end

function export_csv(path::String, df)
    return CSV.write(path, int128_to_string(df))
end
