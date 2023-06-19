# r+ = read and write
File.open("employee.txt", "r") do |file|
  puts file
  puts file.read()
  puts file.read().include? "Andy"
end

File.open("employee.txt", "a") do |file|
  file.write("Oscar , Accounting")
end

File.open("employee.txt", "w") do |file|
  file.write("Oscar, Accounting")
end

File.open("index.html", "w") do |file|
  file.write("<h1>Hello</h1>")
end


