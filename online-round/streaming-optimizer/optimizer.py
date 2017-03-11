import sys
	
def main(fname):
	input_path = "input/"+fname+".in"
	output_path = "output/"+fname+".out"

	with open(input_path) as f:
	    content = f.readlines()
	# you may also want to remove whitespace characters like `\n` at the end of each line
	data = [x.strip() for x in content]

	# print data

	# Optimizer
	videos = data[0].split(" ")[0]
	endpoints = data[0].split(" ")[1]
	request_descriptions = data[0].split(" ")[2]
	cache_servers = data[0].split(" ")[3]
	server_capacity = data[0].split(" ")[4]

	data_dict = {"0":cache_servers}
		

		# servers_connected = data[count].split(" ")[1]
		# print servers_connected

	with open(output_path,"w") as o:
		for item in data:
			o.write(item)
			o.write("\n")

if __name__ == "__main__":
	sys.exit(main(sys.argv[1]))
