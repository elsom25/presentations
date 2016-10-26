require 'pry'

class Test
  def add1(base) base + 3 end
end

t = Test.new
x = 10

binding.pry # starts a REPL sessions

x += x

binding.pry

[0..x].each{ |i| x += i }

binding.pry

# program resumes here (after pry session)
puts "program resumes. x=#{x}."
