using PyCall, LOBSTR, Pandas
pushfirst!(PyVector(pyimport("sys")."path"), "") # include currect directory in path

py"""
# You can insert python's packages here
# You'll need
import pandas as pd
"""

stocks_list=<function_to_load>
for (stock, day) in stocks_list
	data = Pandas.DataFrame(import_data(stock, day, data_type="orders", verbose=true))

	py"""	
	data=$data #data for given stock and day

	# Your python code here or import your script
	import my_script
	my_script.process(data)
	"""

	error("Stop after one iteration, comment this to continue iterating.")
end
