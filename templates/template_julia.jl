using LOBSTR
stocks_list=training_set(

# this takes ≈ 3.39 hours on hdd
# this takes ≈ 3.23 hours on ssd
@time for (stock, day) in stocks_list
        @time data = import_data(stock, day, data_type="orders", verbose=true)
	error("Stop after one iteration, comment this to continue iterating.")
end
