require 'yaml'
require 'debugger'
$index = YAML.load_file('data/index.yml')

def parse_exercise_type
  puts "Выберите тип урока:"
  puts "\t0. обучение"
  puts "\t1. повторение"
  puts "\t2. экзамен"
  answer = gets.to_i rescue 0
  {0 => :learn, 1 => :repeat, 2 => :exam}[answer]
end

def sleep_time(type)
  case type
    when :learn then 6
    when :exam then 2
    when :repeat then 3
    else
      6
  end
end

puts "Выберете категорию:"
$index.keys.each_with_index{|name, i| puts "\t#{i}. #{name}" }

category_index = gets.to_i rescue 0
category_name = $index.keys[category_index]
category_data = YAML.load_file($index[category_name])

puts "Выбранная категория '#{category_name}'. Поехали!"

sleep_time_by_type = sleep_time(parse_exercise_type)

loop do
  category_data.shuffle.each do |word_data|
    print "\r#{word_data["t"]}                                                     "
    print "\r"
    sleep 2
    print "\r#{word_data["t"]} - #{word_data["p"]} #{word_data["w"]}"
    sleep sleep_time_by_type
    $stdout.flush
  end
end