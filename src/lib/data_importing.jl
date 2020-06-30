
DATA_ROOT=ENV["DATA_ROOT"]

function list_data(stocks::Array{String, 1}, days::Union{Array{Int64, 1}, Int64}; data_type="orders"::String)
	listed_data=Array{String}(undef, length(days), length(stocks))
	stocks = convert(Array{String}, stocks)
	# array of days converted to regex
	days = replace(cat(string(days), dims = 2)[1], r"\[|\]" => "")
	days = replace(cat(days, dims = 2)[1], ", " => "|")

	# data processed directory
	data_directory = "$DATA_ROOT/processed/processed_$data_type"

	for i in 1:length(stocks)
		stock_directory="$data_directory/$(stocks[i])"
		try 
			files=readlines(pipeline(`ls "$stock_directory"`, `grep "$days"`))
			listed_data[:, i] = ["$stock_directory/$(files[j])" for j=1:length(files)]
		catch
			throw("Wrong data_type, days or stock")
		end
	end
	return listed_data
end


# Deal with non-array of one stock
function list_data(stock::String, days::Union{Array{Int64, 1}, Int64}; data_type="orders"::String)
	list_data([stock], days; data_type=data_type)
end

function list_data(stocks, days; data_type="orders"::String)
	listed_data=Array{String}(undef, length(days), length(stocks))
	stocks = convert(Array{String}, stocks)
	# array of days converted to regex
	days = replace(cat(string(days), dims = 2)[1], r"\[|\]" => "")
	days = replace(cat(days, dims = 2)[1], ", " => "|")

	# data processed directory
	data_directory = "$DATA_ROOT/processed/processed_$data_type"

	for i in 1:length(stocks)
		stock_directory="$data_directory/$(stocks[i])"
		try 
			files=readlines(pipeline(`ls "$stock_directory"`, `grep -wE "$days"`))
			listed_data[:, i] = ["$stock_directory/$(files[j])" for j=1:length(files)]
		catch
			throw("Wrong data_type, days or stock")
		end
	end
	return listed_data
end


function import_data(stocks::Array{String, 1}, days::Array{Int64, 1}; data_type="orders"::String, verbose=false::Bool)
	data_files = list_data(stocks, days, data_type=data_type)
	if verbose
		println()
		@info("Importing $data_files")
 	end
	imported_data = [import_pqt(data_files[i, j]) for i in 1:size(data_files, 1),
  						          j in 1:size(data_files, 2)]
	return imported_data
end


function import_data(stock::Union{Symbol, String}, day::Int64; data_type="orders"::String, verbose=false)
	file="$DATA_ROOT/processed/processed_$data_type/$stock/$(day).pqt"
	if verbose
		println()
		@info("Importing $file")
		return import_pqt(file)
 	end
	return import_pqt(file)
end


#data = list_data("BMO", 20160105, data_type="orders")
#data = list_data(["BMO", "ABX"], 20160105, data_type="orders")
#data = list_data("BMO", [20160104, 20160105], data_type="orders")
#data = list_data(["BMO", "ABX"], [20160104, 20160105], data_type="orders")
#
#data = import_data("BMO", 20160105, data_type="orders")
#data = import_data(["BMO", "ABX"], 20160105, data_type="orders")
#data = import_data("BMO", [20160104, 20160105], data_type="orders")
#data = import_data(["BMO", "ABX"], [20160104, 20160105], data_type="orders")



struct Stocks_list <: AbstractArray{Int, 2}
 	list::DataFrame
	#nb_stock
	#nb_days
end

Base.size(S::Stocks_list) = size(S.list)

Base.IndexStyle(S::Stocks_list)=IndexCartesian()
Base.getindex(S::Stocks_list, I::Vararg{Int, 2}) = (names(S.list)[last(I)], getindex(S.list, first(I), last(I)))
Base.setindex(S::Stocks_list, i::Int) = setindex(S.list)

Base.length(S::Stocks_list) = size(S.list, 1) * size(S.list, 2)

get_stock(s::Tuple{String,Int64}) = first(s)
get_day(s::Tuple{String,Int64}) = last(s)


function Stocks_list(file::String)
	return Stocks_list(CSV.read(file))
end

function Stocks_list()
	return Stocks_list(CSV.read("$DATA_ROOT/lists/sp60_set.csv"))
end

function training_set()
	return Stocks_list(CSV.read("$DATA_ROOT/lists/training_set.csv"))
end

function validation_set()
	return Stocks_list(CSV.read("$DATA_ROOT/lists/validation_set.csv"))
end

function test_set()
	return Stocks_list(CSV.read("$DATA_ROOT/lists/test_set.csv"))
end

function sp60_set()
	return Stocks_list(CSV.read("$DATA_ROOT/lists/sp60_set.csv"))
end

function custom_set(stocks::Array{String, 1})
    return Stocks_list(CSV.read("$DATA_ROOT/lists/sp60_set.csv")[:, stocks])
end

function custom_set(days::Array{Int64, 1})
    stocks_df = CSV.read("$DATA_ROOT/lists/sp60_set.csv")
    filtered_stocks_df = filter!(row -> false, copy(stocks_df))
    for day in days
        append!(filtered_stocks_df, stocks_df[day .== stocks_df[: ,1], :])
    end
    return Stocks_list(filtered_stocks_df)
end

function custom_set(stocks::Array{String, 1}, days::Array{Int64, 1})
    stocks_df = CSV.read("$DATA_ROOT/lists/sp60_set.csv")[:, stocks]
    filtered_stocks_df = filter!(row -> false, copy(stocks_df))
    for day in days
        append!(filtered_stocks_df, stocks_df[day .== stocks_df[: ,1], :])
    end
    return Stocks_list(filtered_stocks_df)
end


function Base.iterate(stocks_list::Stocks_list, state=(1,1); data_type="orders")
	to_import = stocks_list.list
	day_count=first(state)
	stock_count=last(state)
	

	if day_count ≤ size(to_import, 1)
		return ((names(to_import)[stock_count], to_import[day_count, stock_count]), (day_count + 1, stock_count))
	elseif stock_count < size(to_import, 2)
		day_count = 1
		stock_count += 1
		return ((names(to_import)[stock_count], to_import[day_count, stock_count]), (day_count + 1, stock_count))
 	else#if day_count > size(to_import, 1) && stock_count > size(to_import, 2)
		return nothing
	end
end

#stocks_list=Stocks_list("tmp.csv")
#
#display(length(stocks_list))
#
## nice for loop
#stocks_list=sp60_set()
##Threads.@threads for (stock, day) in stocks_list
#for stock in stocks_list
#    print(stock)
#    error()
#end


#display(stocks_list.list)
#display(stocks_list)
#display(a)
#@showprogress for (stock, day) in stocks_list
#        import_data(stock, day, data_type="orders", verbose=true)
#end




#list_data("sp60.txt")

#data = import_data(["ABX", "BMO"], [20160104, 20160105], data_type="orders")
#println(data)
#display(first.(data, 5))




#list_data("sp60.txt")

#data = import_data(["ABX", "BMO"], [20160104, 20160105], data_type="orders")
#println(data)
#display(first.(data, 5))
