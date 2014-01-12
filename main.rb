require 'yaml'
require 'timeout'
#require 'debugger'

trap("INT") do
  puts `clear`
  puts "Спасибо за урок!"
  exit
end

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

def wait_for_user_answer
  Timeout.timeout(2) do
    return gets
  end
rescue Timeout::Error
  nil
end

puts "Выберете категорию:"
$index.keys.each_with_index{|name, i| puts "\t#{i}. #{name}" }

category_index = gets.to_i rescue 0
category_name = $index.keys[category_index]
category_data = YAML.load_file($index[category_name])

puts `clear`
puts "Выбранная категория '#{category_name}'. Поехали!"

exercise_type = parse_exercise_type
sleep_time_by_type = sleep_time(exercise_type)

loop do
  if category_data.empty?
    puts "Нету слов для изучения"
    exit 1
  end
  category_data.dup.shuffle.each do |word_data|
    puts `clear`
    print "\r"
    print " " * 100
    print "\r#{word_data["t"]}"
    if exercise_type == :exam
      sleep 2
    else
      answer = wait_for_user_answer
      if answer == "\n"
        category_data.delete(word_data)
        next
      end
    end
    print "\r#{word_data["t"]} - #{word_data["p"]} #{word_data["w"]}"
    sleep sleep_time_by_type
    $stdout.flush
  end
end