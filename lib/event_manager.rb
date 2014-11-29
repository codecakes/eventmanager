require 'csv'

contents = File.read File.absolute_path("../event_manager/event_attendees.csv")

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


parameters = lambda {|rjust_options, sym1, sym2|
    [rjust_options[sym1] || 5, rjust_options[sym2] || "0"]}

puts
#reject any nil value
puts "Valid Zip codes"
def print_csv_field(csv, field, rjust_options = {})
    #rjust_options = {:pad => 5, :char => "0"}
    pad, char = yield(rjust_options, :pad, :char)
    csv[field].compact.map {|x| x.rjust pad,char}
end

#p csv[:zipcode].compact.map {|x| x.rjust 5,"0"}
p print_csv_field(csv, :zipcode, &parameters)
#p print_csv_field(csv, :zipcode, {:pad => 5, :char => "0"}, &parameters)
puts 

p "Print Name vs Zip Code"
def print_csv_name_field(csv, name, field, rjust_options = {})
    #rjust_options = {:pad => 5, :char => "0"}
    pad, char = yield(rjust_options, :pad, :char)
    (csv[name].zip(csv[field])).map {|name, field| puts "#{name} - #{field.rjust pad,char}" if !name.nil? && !field.nil?}
end

#p (csv[:first_name].zip csv[:zipcode]).each {|name,zip| puts "#{name} - #{zip}"}
print_csv_name_field(csv, :first_name, :zipcode, &parameters)