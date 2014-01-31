class AnswerGenerator
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
    @rules["Глаголы"] = verbs_rule
    @rules["Предлоги"] = prepositions_rule
    @rules["Глаголы с приставками"] = verbs_with_prefix
    @rules["Существительные -> Еда"] = nouns_rule
    @rules["Существительные -> Общее"] = nouns_rule
    @rules["Существительные -> Отдых"] = nouns_rule
    @rules["Существительные -> Профессии"] = nouns_rule
  end

  def base_rule
    -> do
      res = if @word_data.key?("p")
        "#{@word_data["p"]} #{@word_data["w"]}"
      else
        @word_data["w"]
      end
      "#{@word_data["t"]} - #{res}"
    end
  end

  def verbs_rule
    -> do
      res = if @word_data["p"] == 's'
        "#{@word_data["w"]} [Сильный - 3л: #{@word_data["p3"]}]"
      else
        "#{@word_data["w"]} [Слабый]"
      end
      "#{@word_data["t"]} - #{res}"
    end
  end

  def nouns_rule
    -> do
      res = "#{@word_data["p"]} #{@word_data["w"]}"
      res += "(#{@word_data["pl"]})" if @word_data.key?("pl")
      "#{@word_data["t"]} - #{res}"
    end
  end

  def prepositions_rule
    -> do
      res = "#{@word_data["w"]} (Падеж: #{@word_data["p"]})"
      "#{@word_data["t"]} - #{res}"
    end
  end

  def verbs_with_prefix
    -> do
      prefix_type = @word_data["d"] == 'yes' ? 'Отделяемая' : 'Не отделяемая'
      "#{@word_data["w"]} - #{prefix_type} (Примеры: #{@word_data["e"]})"
    end
  end
end