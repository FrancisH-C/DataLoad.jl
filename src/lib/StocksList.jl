struct StocksList <: AbstractArray{Int64, 2}
    list::DataFrame
end

Base.size(S::StocksList) = size(S.list)

Base.IndexStyle(S::StocksList)=IndexCartesian()
Base.getindex(S::StocksList, I::Vararg{Int, 2}) = (names(S.list)[last(I)], getindex(S.list, first(I), last(I)))
Base.setindex(S::StocksList, i::Int) = setindex(S.list)

Base.length(S::StocksList) = size(S.list, 1) * size(S.list, 2)

get_stock(s::Tuple{String,Int64}) = first(s)
get_day(s::Tuple{String,Int64}) = last(s)


function StocksList(file::String)
	return StocksList(DataFrame!(CSV.File(file)))
end

function StocksList()
	return StocksList(DataFrame!(CSV.File("$DATA_ROOT/lists/sp60_set.csv")))
end
