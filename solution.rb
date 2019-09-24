require 'csv'

filepath = 'input.csv'

HEADERS = [
  "website",
  "impressions",
  "revenue"
]

@header_index = {}
HEADERS.each_with_index do |header, index|
  @header_index[header] = index
end

@data = []

CSV.foreach(filepath, { col_sep: ',', headers: :first_row }).each do |row|

  name = row[@header_index['website']]
  impressions = row[@header_index['impressions']]
  revenue = row[@header_index['revenue']]
  website_data = {
      name: name,
      impressions: impressions.to_i,
      revenue: revenue.to_f,
  }
  website_data[:cpm] = website_data[:cpm] = ((website_data[:revenue] / website_data[:impressions]) * 1000).round(2)
  @data << website_data
end

@data = @data.sort_by{ |website_data| website_data[:cpm] }.reverse

#Same function to get the website with highest revenue
#and the website with highest impressions
def get_website_with_maximal_value(max_by)
  @data.max_by{ |website_data| website_data[max_by]}
end

@website_with_highest_revenue = get_website_with_maximal_value(:revenue)
@website_with_highest_impressions = get_website_with_maximal_value(:impressions)
@website_with_highest_cpm = get_website_with_maximal_value(:cpm)

# The output is formatted to be written in the files exactly as in the Readme
def get_output(type)
  output = ''
  if type == 'txt'
    print "##############\n# PLAIN TEXT #\n##############\n"
    output = "*** Winners ***
The website with the highest revenue is: #{@website_with_highest_revenue[:name]}
The website with the highest impressions is: #{@website_with_highest_impressions[:name]}
The website with the highest cpm is: #{@website_with_highest_cpm[:name]}\n
*** cpm ***
"
    @data.each do |website_data| 
    output<< "- #{website_data[:name]}: #{website_data[:cpm]}\n" 
    end
    print output + "\n\n"

  elsif type == 'html'
    puts "########\n# HTML #\n########"
    output = "<h1>Winners</h1>
  <ul>
    <li>The website with the highest revenue is: #{@website_with_highest_revenue[:name]}</li>
    <li>The website with the highest impressions is: #{@website_with_highest_impressions[:name]}</li>
    <li>The website with the highest cpm is: #{@website_with_highest_cpm[:name]}</li>
  </ul>
<h1>cpm</h1>
  <ul>\n"
      @data.each do |website_data| 
        output<< "    <li>#{website_data[:name]}: #{website_data[:cpm]}</li>\n" 
    end
    output << " </ul>\n"
    print output
  end

  file = File.open("output.#{type}", "w")
  file.puts(output)
  file.close
end

get_output('txt')
get_output('html')