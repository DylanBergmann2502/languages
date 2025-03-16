# ERB (Embedded Ruby) is a templating system that allows Ruby code to be embedded within text files.
# It's commonly used for generating HTML, XML, and other text-based formats.

require 'erb'

########################################################################
# Basic ERB syntax
# ERB recognizes several tags:
# <%= ruby_expression %> - Evaluates and outputs the result
# <% ruby_code %> - Evaluates but doesn't output
# <%# comment %> - Comment (not evaluated or output)
# <%% or %%> - Literal <% or %> in the output

# Creating a simple template
template = "Hello, <%= name %>!"
renderer = ERB.new(template)

# Binding provides the context for variables in the template
name = "Ruby Explorer"
result = renderer.result(binding)
puts result  # Hello, Ruby Explorer!

########################################################################
# Control flow in ERB templates
complex_template = <<-TEMPLATE
<% if time_of_day == "morning" %>
Good morning, <%= name %>!
<% elsif time_of_day == "evening" %>
Good evening, <%= name %>!
<% else %>
Hello, <%= name %>!
<% end %>
TEMPLATE

renderer = ERB.new(complex_template)

# Try different contexts
name = "Ruby Explorer"

time_of_day = "morning"
puts renderer.result(binding)

time_of_day = "evening"
puts renderer.result(binding)

time_of_day = "afternoon"
puts renderer.result(binding)

########################################################################
# Loops in ERB
loop_template = <<-TEMPLATE
<ul>
<% items.each do |item| %>
 <li><%= item %></li>
<% end %>
</ul>
TEMPLATE

renderer = ERB.new(loop_template)
items = ["Apple", "Banana", "Cherry"]
puts renderer.result(binding)

########################################################################
# Trim modes
# ERB supports different trim modes that affect how whitespace is handled

# Default mode (no special handling)
default_template = <<-TEMPLATE
<% 3.times do |i| %>
 Line <%= i %>
<% end %>
TEMPLATE

puts "Default trim mode:"
puts ERB.new(default_template).result(binding)

# Trim mode '-' removes newlines after tags
trim_template = <<-TEMPLATE
<%- 3.times do |i| -%>
 Line <%= i %>
<%- end -%>
TEMPLATE

puts "\nTrim mode '-':"
puts ERB.new(trim_template, trim_mode: '-').result(binding)

# Trim mode '>' omits blank lines
omit_template = <<-TEMPLATE
<% 3.times do |i| %>
 Line <%= i %>
<% end %>

<% if false %>
 This won't show
<% end %>
TEMPLATE

puts "\nTrim mode '>':"
puts ERB.new(omit_template, trim_mode: '>').result(binding)

########################################################################
# Safe level
# Note: Safe level is deprecated in newer Ruby versions (3.0+)
# but understanding it is still useful for legacy code

safe_template = "<%= File.read('/etc/passwd') rescue 'Access denied' %>"

# In older Ruby versions, you could use:
# ERB.new(safe_template, safe_level: 4)
# where safe_level restricts potentially dangerous operations

# Modern approach is to use custom helpers and carefully control
# what's available in the binding

########################################################################
# ERB with files
# Writing to a file
template_file_content = <<-TEMPLATE
# Report generated at <%= Time.now %>

User: <%= username %>
Status: <%= status %>
Points: <%= points %>
TEMPLATE

File.write('template.erb', template_file_content)

# Reading from a template file
template_from_file = File.read('template.erb')
renderer = ERB.new(template_from_file)

username = "johndoe"
status = "active"
points = 1250

result = renderer.result(binding)
puts "\nTemplate from file:"
puts result

########################################################################
# Practical example: HTML generation
html_template = <<-TEMPLATE
<!DOCTYPE html>
<html>
<head>
 <title><%= page_title %></title>
</head>
<body>
 <h1><%= heading %></h1>
 <ul>
 <% items.each do |item| %>
   <li><%= item.capitalize %></li>
 <% end %>
 </ul>
 <p>Generated at: <%= Time.now %></p>
</body>
</html>
TEMPLATE

renderer = ERB.new(html_template)
page_title = "My Ruby Page"
heading = "Items List"
items = ["ruby", "erb", "templates", "code generation"]

html_output = renderer.result(binding)
puts "\nHTML output (excerpt):"
puts html_output.split("\n")[0..5].join("\n") + "\n..."

########################################################################
# Advanced: Custom ERB helpers and encapsulation

class TemplateRenderer
 def initialize(template)
   @template = ERB.new(template)
   @data = {}
 end
 
 def set(key, value)
   @data[key] = value
 end
 
 def render
   # Create a binding in this instance's context
   b = binding
   
   # Define local variables from @data
   @data.each do |key, value|
     b.local_variable_set(key, value)
   end
   
   @template.result(b)
 end
 
 # Helper methods available in templates
 def format_date(date)
   date.strftime("%B %d, %Y")
 end
 
 def escape_html(text)
   text.to_s.gsub(/[&<>"']/) do |char|
     case char
     when '&' then '&amp;'
     when '<' then '&lt;'
     when '>' then '&gt;'
     when '"' then '&quot;'
     when "'" then '&#39;'
     end
   end
 end
end

template = <<-TEMPLATE
<h1><%= title %></h1>
<p>Published: <%= format_date(published_date) %></p>
<div class="content">
 <%= escape_html(content) %>
</div>
TEMPLATE

renderer = TemplateRenderer.new(template)
renderer.set(:title, "Learning ERB")
renderer.set(:published_date, Time.new(2023, 3, 15))
renderer.set(:content, "ERB is <strong>powerful</strong> & easy to use!")

puts "\nCustom renderer output:"
puts renderer.render

# Cleaning up the template file
File.delete('template.erb') if File.exist?('template.erb')
