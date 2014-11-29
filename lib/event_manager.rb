require 'csv'

contents = File.read File.absolute_path("./event_attendees.csv")

#print first names per line - skip header row
p "Print First Name per line"
contents.each_line.each_with_index {|line,num| print line.chomp.split(',')[2].capitalize if num > 0;puts} 

#with csv
csv = CSV.parse contents.to_str, headers: true, header_converters: :symbol
#puts csv.headers
puts 
puts "first_Name"
print csv[:first_name]

puts 

puts "zip_code"
print csv[:zipcode]

puts
#reject any nil value
puts "Valid Zip codes"
p csv[:zipcode].compact.map {|x| x.rjust 5,"0"}