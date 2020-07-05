using DataLoad
stocks_list=<function_to_load>

# this takes ≈ 3.39 hours on hdd
# this takes ≈ 3.23 hours on ssd
@time for (stock, day) in stocks_list
    data = import_data(stock, day, data_type="orders", verbose=true)
    display(last(data, 6))
    println("Stop after one iteration, comment this line to continue iterating."); break
end
