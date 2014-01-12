require 'yaml'
require 'timeout'
#require 'debugger'

def finish_lesson(text=nil)
  print `clear`
  puts text if text
  puts "Спасибо за урок!"
  exit
end

trap("INT") do
  finish_lesson
end

$index = YAML.load_file('data/index.yml')

def parse_exercise_type
  print `clear`
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

def print_message(msg)
  print `clear`
  print msg
end

def wait_for_user_answer(timeout)
  Timeout.timeout(timeout) do
    return gets
  end
rescue Timeout::Error
  nil
end

# --- MAIN ---

print_message "Выберете категорию:\n"
$index.keys.each_with_index{|name, i| puts "\t#{i}. #{name}" }

category_index = gets.to_i rescue 0
category_name = $index.keys[category_index]
category_data = YAML.load_file($index[category_name])

print_message "Выбранная категория '#{category_name}'. Поехали!\n"

exercise_type = parse_exercise_type
sleep_time_by_type = sleep_time(exercise_type)

loop do
  finish_lesson "Нету слов для изучения" if category_data.empty?
  category_data.dup.shuffle.each do |word_data|
    sleep 0.5
    print_message "#{word_data["t"]}"
    sleep 2
    print_message "#{word_data["t"]} - #{word_data["p"]} #{word_data["w"]}"
    if exercise_type == :exam
      sleep sleep_time_by_type
    else
      answer = wait_for_user_answer(sleep_time_by_type)
      if answer == "\n"
        category_data.delete(word_data)
        sleep 0.5
      end
    end
    $stdout.flush
  end
end