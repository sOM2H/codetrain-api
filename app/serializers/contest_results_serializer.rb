class ContestResultsSerializer < ActiveModel::Serializer
  attributes :id, :title, :results

  def results
    problem_ids = object.problems.order(:id).pluck(:id)
    user_ids = object.users.pluck(:id)

    best_attempts = Attempt
      .joins(problem: :contests)
      .joins(:user)
      .where(contests: { id: object.id })
      .select('DISTINCT ON (attempts.user_id, attempts.problem_id) attempts.*, users.full_name')
      .order('attempts.user_id, attempts.problem_id, attempts.score DESC')

    user_scores = best_attempts.group_by(&:user_id)

    all_user_scores = user_ids.map do |user_id|
      attempts = user_scores[user_id] || []
      full_name = attempts.first&.full_name || object.users.find(user_id).full_name

      scores = attempts.map { |attempt| { problem_id: attempt.problem_id, score: attempt.score } }
      total = scores.sum { |s| s[:score] } unless scores.empty?

      {
        user_id: user_id,
        full_name: full_name,
        scores: scores,
        total: total || "-" # "-" если нет попыток
      }
    end

    sorted_scores = all_user_scores.sort_by { |user| user[:total] == "-" ? -1 : -user[:total].to_i } # Сортируем по убыванию

    format_results(sorted_scores, problem_ids)
  end

  private

  def format_results(user_scores, problem_ids)
    formatted = []

    user_scores.each do |user|
      row = { user_id: user[:user_id], full_name: user[:full_name] }

      problem_ids.each do |pid|
        score = user[:scores].find { |s| s[:problem_id] == pid }&.dig(:score)
        row[pid] = score.nil? ? "-" : score
      end

      row[:total] = user[:total]
      formatted << row
    end

    formatted
  end
end
