class QuestionGenerator
  def initialize
    init_rules
  end

  def run(word_data, category_name)
    @word_data = word_data
    @category_name = category_name
    gen_res
  end

  private

  def gen_res
    @rules[@category_name].call
  end

  def init_rules
    @rules = {}
    @rules.default = base_rule
    @rules["Глаголы с приставками"] = verbs_with_prefix
  end

  def base_rule
    -> { @word_data["t"] }
  end

  def verbs_with_prefix
    -> { "#{@word_data["w"]} (#{@word_data["t"]})" }
  end
end