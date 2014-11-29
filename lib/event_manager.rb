require 'csv'

require 'sunlight/congress'

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

contents = File.read File.absolute_path("../event_manager/event_attendees.csv")

csv = CSV.parse contents.to_str, headers: true, header_converters: :symbol

parameters = lambda {|rjust_options, sym1, sym2|
    [rjust_options[sym1] || 5, rjust_options[sym2] || "0"]}

def print_csv_field(csv, field, rjust_options = {})
    #rjust_options = {:pad => 5, :char => "0"}
    pad, char = yield(rjust_options, :pad, :char)
    csv[field].compact.map {|x| x.rjust pad,char}
end

def print_csv_name_field(csv, name, field, rjust_options = {})
    #rjust_options = {:pad => 5, :char => "0"}
    pad, char = yield(rjust_options, :pad, :char)
    (csv[name].zip(csv[field])).map {|name, field| puts "#{name} - #{field.rjust pad,char}" if !name.nil? && !field.nil?}
end

def print_csv_name_zip_legislature(csv, name, zipcode, rjust_options = {})
    #rjust_options = {:pad => 5, :char => "0"}
    pad, char = yield(rjust_options, :pad, :char)
    puts "name - zipcode - candidate"
    (csv[name].zip(csv[zipcode])).each {|name, zipcode|
        if !name.nil? && !zipcode.nil?
            zipcode = zipcode.rjust pad,char
            candidate = Sunlight::Congress::Legislator.by_zipcode(zipcode)
            candidates = candidate.collect {|x| [x.first_name, x.last_name]} 
            puts "#{name}, #{zipcode}, #{candidates}"
        end
        }
end

if __FILE__ == $0
    #=begin
    #print first names per line - skip header row
    #p "Print First Name per line"
    #contents.each_line.each_with_index {|line,num| print line.chomp.split(',')[2].capitalize if num > 0;puts} 
    #
    #puts 
    #puts "first_Name"
    #print csv[:first_name]
    #
    #puts 
    #puts "zip_code"
    #print csv[:zipcode]
    #=end
        
    #reject any nil value
    #puts "Valid Zip codes"
    #p csv[:zipcode].compact.map {|x| x.rjust 5,"0"}
    #puts print_csv_field(csv, :zipcode, &parameters)
    #p print_csv_field(csv, :zipcode, {:pad => 5, :char => "0"}, &parameters)
    
    
    puts "Print Name vs Zip Code"
    #p (csv[:first_name].zip csv[:zipcode]).each {|name,zip| puts "#{name} - #{zip}"}
    #print_csv_name_field(csv, :first_name, :zipcode, &parameters)
    
    print_csv_name_zip_legislature(csv, :first_name, :zipcode, &parameters)
end